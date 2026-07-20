import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/app_text_field.dart';
import '../domain/gym_info.dart';
import '../providers/settings_providers.dart';
import '../widgets/image_field.dart';
import '../widgets/settings_scaffold.dart';

const _weekdayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

class GeneralSettingsScreen extends ConsumerStatefulWidget {
  const GeneralSettingsScreen({super.key});

  @override
  ConsumerState<GeneralSettingsScreen> createState() =>
      _GeneralSettingsScreenState();
}

class _GeneralSettingsScreenState
    extends ConsumerState<GeneralSettingsScreen> {
  late final GymInfoSettings _initial =
      ref.read(settingsControllerProvider).info;

  late final _gymName = TextEditingController(text: _initial.gymName);
  late final _tagline = TextEditingController(text: _initial.tagline);
  late final _description = TextEditingController(text: _initial.description);
  late final _ownerName = TextEditingController(text: _initial.ownerName);
  late final _email = TextEditingController(text: _initial.email);
  late final _mobile = TextEditingController(text: _initial.mobile);
  late final _whatsapp = TextEditingController(text: _initial.whatsapp);
  late final _alternate =
      TextEditingController(text: _initial.alternateContact);
  late final _address = TextEditingController(text: _initial.address);
  late final _city = TextEditingController(text: _initial.city);
  late final _state = TextEditingController(text: _initial.state);
  late final _country = TextEditingController(text: _initial.country);
  late final _pin = TextEditingController(text: _initial.pinCode);
  late final _maps = TextEditingController(text: _initial.googleMapsUrl);
  late final _website = TextEditingController(text: _initial.website);
  late final _instagram = TextEditingController(text: _initial.instagram);
  late final _facebook = TextEditingController(text: _initial.facebook);
  late final _opening = TextEditingController(text: _initial.openingTime);
  late final _closing = TextEditingController(text: _initial.closingTime);

  late String _logoUrl = _initial.logoUrl;
  late String _coverUrl = _initial.coverBannerUrl;
  late final Set<int> _offDays = {..._initial.weeklyOffDays};

  @override
  void dispose() {
    for (final c in [
      _gymName, _tagline, _description, _ownerName, _email, _mobile,
      _whatsapp, _alternate, _address, _city, _state, _country, _pin,
      _maps, _website, _instagram, _facebook, _opening, _closing,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _pickTime(TextEditingController target) async {
    final parts = target.text.split(':');
    final initial = TimeOfDay(
      hour: int.tryParse(parts.isNotEmpty ? parts[0] : '') ?? 9,
      minute: int.tryParse(parts.length > 1 ? parts[1] : '') ?? 0,
    );
    final picked = await showTimePicker(context: context, initialTime: initial);
    if (picked == null) return;
    final hh = picked.hour.toString().padLeft(2, '0');
    final mm = picked.minute.toString().padLeft(2, '0');
    setState(() => target.text = '$hh:$mm');
  }

  void _save() {
    ref.read(settingsControllerProvider.notifier).updateInfo(
          _initial.copyWith(
            gymName: _gymName.text.trim(),
            tagline: _tagline.text.trim(),
            description: _description.text.trim(),
            logoUrl: _logoUrl,
            coverBannerUrl: _coverUrl,
            ownerName: _ownerName.text.trim(),
            email: _email.text.trim(),
            mobile: _mobile.text.trim(),
            whatsapp: _whatsapp.text.trim(),
            alternateContact: _alternate.text.trim(),
            address: _address.text.trim(),
            city: _city.text.trim(),
            state: _state.text.trim(),
            country: _country.text.trim(),
            pinCode: _pin.text.trim(),
            googleMapsUrl: _maps.text.trim(),
            website: _website.text.trim(),
            instagram: _instagram.text.trim(),
            facebook: _facebook.text.trim(),
            openingTime: _opening.text.trim(),
            closingTime: _closing.text.trim(),
            weeklyOffDays: _offDays,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return SettingsSectionScaffold(
      title: 'General',
      onSave: _save,
      children: [
        SettingsGroup(
          title: 'Identity',
          children: [
            ImageField(
              label: 'Gym Logo',
              reference: _logoUrl,
              storagePath: 'branding/logo',
              onChanged: (v) => setState(() => _logoUrl = v),
            ),
            const SizedBox(height: 16),
            ImageField(
              label: 'Cover Banner',
              reference: _coverUrl,
              storagePath: 'branding/cover',
              aspectRatio: 16 / 9,
              onChanged: (v) => setState(() => _coverUrl = v),
            ),
            const SizedBox(height: 16),
            AppTextField(
              label: 'Gym Name',
              hint: 'e.g. Iron Forge Fitness',
              icon: Icons.business_rounded,
              controller: _gymName,
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 14),
            AppTextField(
              label: 'Tagline',
              hint: 'A short line under your name',
              icon: Icons.short_text_rounded,
              controller: _tagline,
            ),
            const SizedBox(height: 14),
            AppTextField(
              label: 'Description',
              hint: 'Describe your gym',
              icon: Icons.description_outlined,
              controller: _description,
            ),
          ],
        ),
        SettingsGroup(
          title: 'Owner & Contact',
          children: [
            AppTextField(
              label: 'Owner Name',
              hint: 'Full name',
              icon: Icons.person_outline_rounded,
              controller: _ownerName,
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 14),
            AppTextField(
              label: 'Email',
              hint: 'you@gym.com',
              icon: Icons.mail_outline_rounded,
              controller: _email,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 14),
            AppTextField(
              label: 'Mobile',
              hint: '+91 …',
              icon: Icons.phone_outlined,
              controller: _mobile,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 14),
            AppTextField(
              label: 'WhatsApp',
              hint: '+91 …',
              icon: Icons.chat_outlined,
              controller: _whatsapp,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 14),
            AppTextField(
              label: 'Alternate Contact',
              hint: 'Optional',
              icon: Icons.phone_forwarded_outlined,
              controller: _alternate,
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
        SettingsGroup(
          title: 'Location',
          children: [
            AppTextField(
              label: 'Address',
              hint: 'Street address',
              icon: Icons.location_on_outlined,
              controller: _address,
            ),
            const SizedBox(height: 14),
            AppTextField(
              label: 'City',
              hint: 'City',
              icon: Icons.location_city_outlined,
              controller: _city,
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 14),
            AppTextField(
              label: 'State',
              hint: 'State',
              icon: Icons.map_outlined,
              controller: _state,
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 14),
            AppTextField(
              label: 'Country',
              hint: 'Country',
              icon: Icons.public_rounded,
              controller: _country,
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 14),
            AppTextField(
              label: 'PIN Code',
              hint: 'Postal code',
              icon: Icons.markunread_mailbox_outlined,
              controller: _pin,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 14),
            AppTextField(
              label: 'Google Maps Link',
              hint: 'https://maps.google.com/…',
              icon: Icons.pin_drop_outlined,
              controller: _maps,
              keyboardType: TextInputType.url,
            ),
          ],
        ),
        SettingsGroup(
          title: 'Online Presence',
          children: [
            AppTextField(
              label: 'Website',
              hint: 'https://…',
              icon: Icons.language_rounded,
              controller: _website,
              keyboardType: TextInputType.url,
            ),
            const SizedBox(height: 14),
            AppTextField(
              label: 'Instagram',
              hint: '@handle',
              icon: Icons.camera_alt_outlined,
              controller: _instagram,
            ),
            const SizedBox(height: 14),
            AppTextField(
              label: 'Facebook',
              hint: 'Page name or URL',
              icon: Icons.facebook_rounded,
              controller: _facebook,
            ),
          ],
        ),
        SettingsGroup(
          title: 'Working Hours',
          children: [
            Row(
              children: [
                Expanded(
                  child: _TimePickerField(
                    label: 'Opening',
                    controller: _opening,
                    onTap: () => _pickTime(_opening),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: _TimePickerField(
                    label: 'Closing',
                    controller: _closing,
                    onTap: () => _pickTime(_closing),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.only(left: 4, bottom: 8),
              child: Text('Weekly Off Days'),
            ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (var day = 1; day <= 7; day++)
                  FilterChip(
                    label: Text(_weekdayNames[day - 1]),
                    selected: _offDays.contains(day),
                    onSelected: (sel) => setState(() {
                      if (sel) {
                        _offDays.add(day);
                      } else {
                        _offDays.remove(day);
                      }
                    }),
                  ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class _TimePickerField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final VoidCallback onTap;

  const _TimePickerField({
    required this.label,
    required this.controller,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: IgnorePointer(
        child: AppTextField(
          label: label,
          hint: 'HH:mm',
          icon: Icons.schedule_rounded,
          controller: controller,
        ),
      ),
    );
  }
}
