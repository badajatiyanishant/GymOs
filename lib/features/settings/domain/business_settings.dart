/// Legal / billing configuration for a gym (Settings → Business).
class BusinessSettings {
  final String gstNumber;
  final String panNumber;

  /// Prepended to generated invoice numbers, e.g. "IF" → "IF-0007".
  final String invoicePrefix;

  /// ISO 4217 currency code, e.g. "INR", "USD".
  final String currencyCode;

  /// IANA time zone id, e.g. "Asia/Kolkata".
  final String timeZone;

  const BusinessSettings({
    required this.gstNumber,
    required this.panNumber,
    required this.invoicePrefix,
    required this.currencyCode,
    required this.timeZone,
  });

  factory BusinessSettings.seed() => const BusinessSettings(
        gstNumber: '',
        panNumber: '',
        invoicePrefix: 'INV',
        currencyCode: 'INR',
        timeZone: 'Asia/Kolkata',
      );

  BusinessSettings copyWith({
    String? gstNumber,
    String? panNumber,
    String? invoicePrefix,
    String? currencyCode,
    String? timeZone,
  }) {
    return BusinessSettings(
      gstNumber: gstNumber ?? this.gstNumber,
      panNumber: panNumber ?? this.panNumber,
      invoicePrefix: invoicePrefix ?? this.invoicePrefix,
      currencyCode: currencyCode ?? this.currencyCode,
      timeZone: timeZone ?? this.timeZone,
    );
  }

  Map<String, dynamic> toJson() => {
        'gstNumber': gstNumber,
        'panNumber': panNumber,
        'invoicePrefix': invoicePrefix,
        'currencyCode': currencyCode,
        'timeZone': timeZone,
      };

  factory BusinessSettings.fromJson(Map<String, dynamic> json) {
    final seed = BusinessSettings.seed();
    return BusinessSettings(
      gstNumber: json['gstNumber'] as String? ?? '',
      panNumber: json['panNumber'] as String? ?? '',
      invoicePrefix: json['invoicePrefix'] as String? ?? seed.invoicePrefix,
      currencyCode: json['currencyCode'] as String? ?? seed.currencyCode,
      timeZone: json['timeZone'] as String? ?? seed.timeZone,
    );
  }
}
