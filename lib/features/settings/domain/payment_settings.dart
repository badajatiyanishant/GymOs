import '../../../core/constants/enums.dart';

/// How the gym accepts money (Settings → Payments).
class PaymentSettings {
  /// Which payment methods the gym accepts (subset of [PaymentMethod]).
  final Set<PaymentMethod> acceptedMethods;

  final String upiId;
  final String bankAccountName;
  final String bankAccountNumber;
  final String bankName;
  final String bankIfsc;

  /// Image reference for the payment QR (https URL or local `data:` URI).
  final String qrImageUrl;

  const PaymentSettings({
    required this.acceptedMethods,
    required this.upiId,
    required this.bankAccountName,
    required this.bankAccountNumber,
    required this.bankName,
    required this.bankIfsc,
    required this.qrImageUrl,
  });

  factory PaymentSettings.seed() => const PaymentSettings(
        acceptedMethods: {
          PaymentMethod.cash,
          PaymentMethod.upi,
          PaymentMethod.card,
        },
        upiId: '',
        bankAccountName: '',
        bankAccountNumber: '',
        bankName: '',
        bankIfsc: '',
        qrImageUrl: '',
      );

  PaymentSettings copyWith({
    Set<PaymentMethod>? acceptedMethods,
    String? upiId,
    String? bankAccountName,
    String? bankAccountNumber,
    String? bankName,
    String? bankIfsc,
    String? qrImageUrl,
  }) {
    return PaymentSettings(
      acceptedMethods: acceptedMethods ?? this.acceptedMethods,
      upiId: upiId ?? this.upiId,
      bankAccountName: bankAccountName ?? this.bankAccountName,
      bankAccountNumber: bankAccountNumber ?? this.bankAccountNumber,
      bankName: bankName ?? this.bankName,
      bankIfsc: bankIfsc ?? this.bankIfsc,
      qrImageUrl: qrImageUrl ?? this.qrImageUrl,
    );
  }

  Map<String, dynamic> toJson() => {
        'acceptedMethods': acceptedMethods.map((m) => m.name).toList(),
        'upiId': upiId,
        'bankAccountName': bankAccountName,
        'bankAccountNumber': bankAccountNumber,
        'bankName': bankName,
        'bankIfsc': bankIfsc,
        'qrImageUrl': qrImageUrl,
      };

  factory PaymentSettings.fromJson(Map<String, dynamic> json) {
    final seed = PaymentSettings.seed();
    final methods = (json['acceptedMethods'] as List<dynamic>?)
        ?.map((e) => PaymentMethod.fromString(e as String?))
        .toSet();
    return PaymentSettings(
      acceptedMethods:
          (methods == null || methods.isEmpty) ? seed.acceptedMethods : methods,
      upiId: json['upiId'] as String? ?? '',
      bankAccountName: json['bankAccountName'] as String? ?? '',
      bankAccountNumber: json['bankAccountNumber'] as String? ?? '',
      bankName: json['bankName'] as String? ?? '',
      bankIfsc: json['bankIfsc'] as String? ?? '',
      qrImageUrl: json['qrImageUrl'] as String? ?? '',
    );
  }
}
