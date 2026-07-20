import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/enums.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/extensions.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/demo_dialogs.dart';
import '../../../core/widgets/fade_in_up.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/responsive_center.dart';
import '../../../core/widgets/state_views.dart';
import '../../../core/widgets/status_pill.dart';
import '../../../core/widgets/user_avatar.dart';
import '../../demo/demo_data.dart';
import '../../gym/providers/gym_data_providers.dart';

/// Members management: a live search field, status filter chips and a scrollable
/// list of member cards, with a floating "Add Member" action.
///
/// The list watches the member repository stream — realtime with Firestore —
/// and falls back to demo rows while the gym has no members yet.
class MembersScreen extends ConsumerStatefulWidget {
  const MembersScreen({super.key});

  @override
  ConsumerState<MembersScreen> createState() => _MembersScreenState();
}

/// Backend-agnostic row model (live member or demo entry).
class _MemberRow {
  final String name;
  final String plan;
  final MembershipStatus status;
  final int daysToExpiry;
  const _MemberRow(this.name, this.plan, this.status, this.daysToExpiry);
}

class _MembersScreenState extends ConsumerState<MembersScreen> {
  final _searchController = TextEditingController();
  String _query = '';
  _MemberFilter _filter = _MemberFilter.all;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<_MemberRow> _allRows() {
    final live = ref.watch(membersStreamProvider).valueOrNull ?? const [];
    if (live.isNotEmpty) {
      return [
        for (final m in live)
          _MemberRow(m.name, m.planName, m.status, m.daysToExpiry),
      ];
    }
    return [
      for (final m in DemoData.members)
        _MemberRow(m.name, m.plan, m.status, m.daysToExpiry),
    ];
  }

  List<_MemberRow> _filtered(List<_MemberRow> all) {
    return all.where((m) {
      final matchesQuery =
          m.name.toLowerCase().contains(_query.toLowerCase().trim());
      final matchesFilter = switch (_filter) {
        _MemberFilter.all => true,
        _MemberFilter.active => m.status == MembershipStatus.active,
        _MemberFilter.expiring => m.status == MembershipStatus.expiringSoon,
        _MemberFilter.expired => m.status == MembershipStatus.expired,
      };
      return matchesQuery && matchesFilter;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final all = _allRows();
    final members = _filtered(all);
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => DemoDialogs.addMember(context),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.person_add_alt_1_rounded),
        label: const Text('Add Member'),
      ),
      body: SafeArea(
        bottom: false,
        child: ResponsiveCenter(
          child: Column(
            children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Row(
                children: [
                  Text('Members', style: context.text.headlineSmall),
                  const Spacer(),
                  Text(
                    '${all.length} total',
                    style: context.text.bodySmall,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: TextField(
                controller: _searchController,
                onChanged: (v) => setState(() => _query = v),
                decoration: InputDecoration(
                  hintText: 'Search members',
                  prefixIcon: const Icon(Icons.search_rounded, size: 20),
                  suffixIcon: _query.isEmpty
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.close_rounded, size: 20),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _query = '');
                          },
                        ),
                ),
              ),
            ),
            _FilterChips(
              selected: _filter,
              onSelected: (f) => setState(() => _filter = f),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: members.isEmpty
                  ? const EmptyView(
                      title: 'No members found',
                      subtitle: 'Try a different search or filter',
                      icon: Icons.person_search_rounded,
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 4, 20, 100),
                      itemCount: members.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, i) => FadeInUp(
                        key: ValueKey(members[i].name),
                        delay: Duration(milliseconds: 40 * i),
                        child: _MemberCard(member: members[i]),
                      ),
                    ),
            ),
          ],
          ),
        ),
      ),
    );
  }
}

enum _MemberFilter { all, active, expiring, expired }

extension on _MemberFilter {
  String get label => switch (this) {
        _MemberFilter.all => 'All',
        _MemberFilter.active => 'Active',
        _MemberFilter.expiring => 'Expiring',
        _MemberFilter.expired => 'Expired',
      };
}

class _FilterChips extends StatelessWidget {
  final _MemberFilter selected;
  final ValueChanged<_MemberFilter> onSelected;

  const _FilterChips({required this.selected, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          for (final f in _MemberFilter.values)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(f.label),
                selected: selected == f,
                onSelected: (_) => onSelected(f),
                showCheckmark: false,
                selectedColor: AppColors.primary,
                labelStyle: TextStyle(
                  color: selected == f
                      ? Colors.white
                      : context.text.bodySmall?.color,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _MemberCard extends StatelessWidget {
  final _MemberRow member;
  const _MemberCard({required this.member});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(14),
      onTap: () => context.showSnack('${member.name} — profile coming soon'),
      child: Row(
        children: [
          UserAvatar(name: member.name, radius: 26),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member.name,
                  style: context.text.bodyLarge
                      ?.copyWith(fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.card_membership_rounded,
                        size: 14, color: context.text.bodySmall?.color),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        '${member.plan} • ${_expiryLabel(member)}',
                        style: context.text.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          StatusPill.membership(member.status),
        ],
      ),
    );
  }

  String _expiryLabel(_MemberRow m) {
    final date = DateTime.now().add(Duration(days: m.daysToExpiry));
    return Formatters.relativeExpiry(date);
  }
}
