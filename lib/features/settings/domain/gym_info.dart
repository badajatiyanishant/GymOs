/// Core identity + contact + location + hours for a gym. Every field here is
/// owner-editable from Settings → General, and the dashboard reads its
/// identity (name, logo, owner, contact) from this model — never from
/// hardcoded constants.
class GymInfoSettings {
  final String gymName;
  final String tagline;
  final String description;

  /// Image references. May be an https URL (Firebase Storage / CDN) or a
  /// `data:` URI (local implementation). Empty string = not set.
  final String logoUrl;
  final String coverBannerUrl;

  final String ownerName;
  final String email;
  final String mobile;
  final String whatsapp;
  final String alternateContact;

  final String address;
  final String city;
  final String state;
  final String country;
  final String pinCode;
  final String googleMapsUrl;

  final String website;
  final String instagram;
  final String facebook;

  /// Stored as 24h "HH:mm" strings so they're timezone/locale independent.
  final String openingTime;
  final String closingTime;

  /// ISO weekday numbers that are days off (1 = Mon … 7 = Sun).
  final Set<int> weeklyOffDays;

  const GymInfoSettings({
    required this.gymName,
    required this.tagline,
    required this.description,
    required this.logoUrl,
    required this.coverBannerUrl,
    required this.ownerName,
    required this.email,
    required this.mobile,
    required this.whatsapp,
    required this.alternateContact,
    required this.address,
    required this.city,
    required this.state,
    required this.country,
    required this.pinCode,
    required this.googleMapsUrl,
    required this.website,
    required this.instagram,
    required this.facebook,
    required this.openingTime,
    required this.closingTime,
    required this.weeklyOffDays,
  });

  /// Seed values so a fresh install looks populated (matches the original demo
  /// gym). Owners overwrite these from Settings.
  factory GymInfoSettings.seed() => const GymInfoSettings(
        gymName: 'Iron Forge Fitness',
        tagline: 'Forge your strongest self.',
        description:
            'A premium strength & conditioning studio with certified '
            'trainers, modern equipment and personalised programs.',
        logoUrl: '',
        coverBannerUrl: '',
        ownerName: 'Arjun Mehta',
        email: 'arjun@ironforge.fit',
        mobile: '+91 98765 43210',
        whatsapp: '+91 98765 43210',
        alternateContact: '',
        address: '2nd Floor, Vardhaman Complex, MG Road',
        city: 'Bengaluru',
        state: 'Karnataka',
        country: 'India',
        pinCode: '560001',
        googleMapsUrl: '',
        website: 'https://ironforge.fit',
        instagram: '@ironforge.fit',
        facebook: 'ironforgefitness',
        openingTime: '05:30',
        closingTime: '22:30',
        weeklyOffDays: {7},
      );

  GymInfoSettings copyWith({
    String? gymName,
    String? tagline,
    String? description,
    String? logoUrl,
    String? coverBannerUrl,
    String? ownerName,
    String? email,
    String? mobile,
    String? whatsapp,
    String? alternateContact,
    String? address,
    String? city,
    String? state,
    String? country,
    String? pinCode,
    String? googleMapsUrl,
    String? website,
    String? instagram,
    String? facebook,
    String? openingTime,
    String? closingTime,
    Set<int>? weeklyOffDays,
  }) {
    return GymInfoSettings(
      gymName: gymName ?? this.gymName,
      tagline: tagline ?? this.tagline,
      description: description ?? this.description,
      logoUrl: logoUrl ?? this.logoUrl,
      coverBannerUrl: coverBannerUrl ?? this.coverBannerUrl,
      ownerName: ownerName ?? this.ownerName,
      email: email ?? this.email,
      mobile: mobile ?? this.mobile,
      whatsapp: whatsapp ?? this.whatsapp,
      alternateContact: alternateContact ?? this.alternateContact,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      country: country ?? this.country,
      pinCode: pinCode ?? this.pinCode,
      googleMapsUrl: googleMapsUrl ?? this.googleMapsUrl,
      website: website ?? this.website,
      instagram: instagram ?? this.instagram,
      facebook: facebook ?? this.facebook,
      openingTime: openingTime ?? this.openingTime,
      closingTime: closingTime ?? this.closingTime,
      weeklyOffDays: weeklyOffDays ?? this.weeklyOffDays,
    );
  }

  Map<String, dynamic> toJson() => {
        'gymName': gymName,
        'tagline': tagline,
        'description': description,
        'logoUrl': logoUrl,
        'coverBannerUrl': coverBannerUrl,
        'ownerName': ownerName,
        'email': email,
        'mobile': mobile,
        'whatsapp': whatsapp,
        'alternateContact': alternateContact,
        'address': address,
        'city': city,
        'state': state,
        'country': country,
        'pinCode': pinCode,
        'googleMapsUrl': googleMapsUrl,
        'website': website,
        'instagram': instagram,
        'facebook': facebook,
        'openingTime': openingTime,
        'closingTime': closingTime,
        'weeklyOffDays': weeklyOffDays.toList()..sort(),
      };

  factory GymInfoSettings.fromJson(Map<String, dynamic> json) {
    final seed = GymInfoSettings.seed();
    return GymInfoSettings(
      gymName: json['gymName'] as String? ?? seed.gymName,
      tagline: json['tagline'] as String? ?? seed.tagline,
      description: json['description'] as String? ?? seed.description,
      logoUrl: json['logoUrl'] as String? ?? '',
      coverBannerUrl: json['coverBannerUrl'] as String? ?? '',
      ownerName: json['ownerName'] as String? ?? seed.ownerName,
      email: json['email'] as String? ?? seed.email,
      mobile: json['mobile'] as String? ?? seed.mobile,
      whatsapp: json['whatsapp'] as String? ?? seed.whatsapp,
      alternateContact: json['alternateContact'] as String? ?? '',
      address: json['address'] as String? ?? seed.address,
      city: json['city'] as String? ?? seed.city,
      state: json['state'] as String? ?? seed.state,
      country: json['country'] as String? ?? seed.country,
      pinCode: json['pinCode'] as String? ?? seed.pinCode,
      googleMapsUrl: json['googleMapsUrl'] as String? ?? '',
      website: json['website'] as String? ?? seed.website,
      instagram: json['instagram'] as String? ?? seed.instagram,
      facebook: json['facebook'] as String? ?? seed.facebook,
      openingTime: json['openingTime'] as String? ?? seed.openingTime,
      closingTime: json['closingTime'] as String? ?? seed.closingTime,
      weeklyOffDays: (json['weeklyOffDays'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toSet() ??
          seed.weeklyOffDays,
    );
  }
}
