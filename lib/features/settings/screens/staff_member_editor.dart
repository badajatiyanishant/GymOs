import 'package:flutter/material.dart';

import '../../../core/utils/extensions.dart';
import '../../../core/widgets/app_text_field.dart';
import '../domain/staff_settings.dart';

/// Bottom-sheet editor to add or edit a [StaffMember]. Returns the built member
/// via `Navigator.pop`, or null if cancelled. Choosing a role pre-fills that
/// role's default permissions (owner can still tweak individually).
class StaffMemberEditor extends StatefulWidget {
  final StaffMember? existing;

  const StaffMemberEditor({super.key, this.existing});

  @override
  State<StaffMemberEditor> createState() => _StaffMemberEditorState();
}

class _StaffMemberEditorState extends State<StaffMemberEditor> {
  final _formKey = GlobalKey<FormState>();
  late final _name =
      TextEditingController(text: widget.existing?.name ?? '');
  late final _phone =
      TextEditingController(text: widget.existing?.phone ?? '');

  late StaffRole _role = widget.existing?.role ?? StaffRole.trainer;
  late Set<StaffPermission> _permissions = {
    ...(widget.existing?.permissions ?? _role.defaultPermissions),
  };

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    super.dispose();
  }

  void _onRoleChanged(StaffRole role) {
    setState(() {
      _role = role;
      // Only overwrite permissions when adding — editing keeps custom choices.
      if (widget.existing == null) {
        _permissions = {...role.defaultPermissions};
      }
    });
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final id = widget.existing?.id ??
        'staff-${DateTime.now().microsecondsSinceEpoch}';
    Navigator.of(context).pop(
      StaffMember(
        id: id,
        name: _name.text.trim(),
        phone: _phone.text.trim(),
        role: _role,
        permissions: _permissions,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existing != null;
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.75,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        builder: (context, scrollController) {
          return Form(
            key: _formKey,
            child: ListView(
              controller: scrollController,
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              children: [
                Center(
                  child: Container(
                    height: 4,
                    width: 40,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: context.colors.outlineVariant,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Text(
                  isEditing ? 'Edit Staff' : 'Add Staff',
                  style: context.text.headlineSmall,
                ),
                const SizedBox(height: 20),
                AppTextField(
                  label: 'Name',
                  hint: 'Full name',
                  icon: Icons.person_outline_rounded,
                  controller: _name,
                  textCapitalization: TextCapitalization.words,
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Name required' : null,
                ),
                const SizedBox(height: 14),
                AppTextField(
                  label: 'Phone',
                  hint: '+91 …',
                  icon: Icons.phone_outlined,
                  controller: _phone,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.done,
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Phone required' : null,
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 4, bottom: 8),
                  child: Text('Role',
                      style: context.text.bodySmall
                          ?.copyWith(fontWeight: FontWeight.w600)),
                ),
                Wrap(
                  spacing: 8,
                  children: [
                    for (final role in StaffRole.values)
                      ChoiceChip(
                        label: Text(role.label),
                        selected: _role == role,
                        onSelected: (_) => _onRoleChanged(role),
                      ),
                  ],
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 4, bottom: 8),
                  child: Text('Permissions',
                      style: context.text.bodySmall
                          ?.copyWith(fontWeight: FontWeight.w600)),
                ),
                for (final perm in StaffPermission.values)
                  CheckboxListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    value: _permissions.contains(perm),
                    title: Text(perm.label),
                    onChanged: (checked) => setState(() {
                      if (checked ?? false) {
                        _permissions.add(perm);
                      } else {
                        _permissions.remove(perm);
                      }
                    }),
                  ),
                const SizedBox(height: 20),
                FilledButton.icon(
                  onPressed: _submit,
                  icon: const Icon(Icons.check_rounded),
                  label: Text(isEditing ? 'Save' : 'Add Staff'),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
