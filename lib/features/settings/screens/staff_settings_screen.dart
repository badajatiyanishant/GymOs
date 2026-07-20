import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/extensions.dart';
import '../../../core/widgets/user_avatar.dart';
import '../domain/staff_settings.dart';
import '../providers/settings_providers.dart';
import 'staff_member_editor.dart';

class StaffSettingsScreen extends ConsumerWidget {
  const StaffSettingsScreen({super.key});

  Future<void> _addOrEdit(
    BuildContext context,
    WidgetRef ref, {
    StaffMember? existing,
  }) async {
    final result = await showModalBottomSheet<StaffMember>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => StaffMemberEditor(existing: existing),
    );
    if (result == null) return;

    final current = ref.read(settingsControllerProvider).staff;
    final members = [...current.members];
    final index = members.indexWhere((m) => m.id == result.id);
    if (index == -1) {
      members.add(result);
    } else {
      members[index] = result;
    }
    ref
        .read(settingsControllerProvider.notifier)
        .updateStaff(current.copyWith(members: members));
  }

  void _remove(WidgetRef ref, StaffMember member) {
    final current = ref.read(settingsControllerProvider).staff;
    final members =
        current.members.where((m) => m.id != member.id).toList();
    ref
        .read(settingsControllerProvider.notifier)
        .updateStaff(current.copyWith(members: members));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final staff = ref.watch(settingsControllerProvider).staff;

    return Scaffold(
      appBar: AppBar(title: const Text('Staff')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addOrEdit(context, ref),
        icon: const Icon(Icons.person_add_alt_1_rounded),
        label: const Text('Add Staff'),
      ),
      body: SafeArea(
        child: staff.members.isEmpty
            ? Center(
                child: Text('No staff yet', style: context.text.bodyLarge),
              )
            : Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 640),
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 96),
                    itemCount: staff.members.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, i) {
                      final m = staff.members[i];
                      return _StaffCard(
                        member: m,
                        onTap: () => _addOrEdit(context, ref, existing: m),
                        onRemove: () => _remove(ref, m),
                      );
                    },
                  ),
                ),
              ),
      ),
    );
  }
}

class _StaffCard extends StatelessWidget {
  final StaffMember member;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const _StaffCard({
    required this.member,
    required this.onTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              UserAvatar(name: member.name, radius: 24),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      member.name,
                      style: context.text.titleSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      member.phone,
                      style: context.text.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            member.role.label,
                            style: context.text.labelSmall
                                ?.copyWith(color: AppColors.primary),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            '${member.permissions.length} permissions',
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
              IconButton(
                onPressed: onRemove,
                icon: const Icon(Icons.delete_outline_rounded,
                    color: AppColors.danger),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
