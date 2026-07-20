import '../../../core/constants/enums.dart';

/// A trainer profile at `gyms/{gymId}/trainers/{id}`.
class Trainer {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String photoUrl;
  final String speciality;
  final bool active;

  const Trainer({
    required this.id,
    required this.name,
    this.email = '',
    this.phone = '',
    this.photoUrl = '',
    this.speciality = '',
    this.active = true,
  });

  Trainer copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? photoUrl,
    String? speciality,
    bool? active,
  }) {
    return Trainer(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      photoUrl: photoUrl ?? this.photoUrl,
      speciality: speciality ?? this.speciality,
      active: active ?? this.active,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'phone': phone,
        'photoUrl': photoUrl,
        'speciality': speciality,
        'active': active,
      };

  factory Trainer.fromJson(Map<String, dynamic> json) => Trainer(
        id: json['id'] as String? ?? '',
        name: json['name'] as String? ?? '',
        email: json['email'] as String? ?? '',
        phone: json['phone'] as String? ?? '',
        photoUrl: json['photoUrl'] as String? ?? '',
        speciality: json['speciality'] as String? ?? '',
        active: json['active'] as bool? ?? true,
      );
}

/// One check-in at `gyms/{gymId}/attendance/{id}`.
class AttendanceRecord {
  final String id;
  final String memberId;
  final String memberName;
  final DateTime checkInAt;
  final DateTime? checkOutAt;
  final CheckInMethod method;

  const AttendanceRecord({
    required this.id,
    required this.memberId,
    required this.memberName,
    required this.checkInAt,
    this.checkOutAt,
    this.method = CheckInMethod.manual,
  });

  AttendanceRecord copyWith({
    String? id,
    String? memberId,
    String? memberName,
    DateTime? checkInAt,
    DateTime? checkOutAt,
    CheckInMethod? method,
  }) {
    return AttendanceRecord(
      id: id ?? this.id,
      memberId: memberId ?? this.memberId,
      memberName: memberName ?? this.memberName,
      checkInAt: checkInAt ?? this.checkInAt,
      checkOutAt: checkOutAt ?? this.checkOutAt,
      method: method ?? this.method,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'memberId': memberId,
        'memberName': memberName,
        'checkInAt': checkInAt.toIso8601String(),
        'checkOutAt': checkOutAt?.toIso8601String(),
        'method': method.name,
      };

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) =>
      AttendanceRecord(
        id: json['id'] as String? ?? '',
        memberId: json['memberId'] as String? ?? '',
        memberName: json['memberName'] as String? ?? '',
        checkInAt: DateTime.tryParse(json['checkInAt'] as String? ?? '') ??
            DateTime.now(),
        checkOutAt: json['checkOutAt'] == null
            ? null
            : DateTime.tryParse(json['checkOutAt'] as String),
        method: CheckInMethod.fromString(json['method'] as String?),
      );
}

/// A payment at `gyms/{gymId}/payments/{id}`.
class PaymentRecord {
  final String id;
  final String memberId;
  final String memberName;
  final String planName;
  final int amount;
  final PaymentMethod method;
  final PaymentStatus status;
  final DateTime paidAt;
  final String note;

  const PaymentRecord({
    required this.id,
    required this.memberId,
    required this.memberName,
    this.planName = '',
    required this.amount,
    this.method = PaymentMethod.cash,
    this.status = PaymentStatus.paid,
    required this.paidAt,
    this.note = '',
  });

  PaymentRecord copyWith({
    String? id,
    String? memberId,
    String? memberName,
    String? planName,
    int? amount,
    PaymentMethod? method,
    PaymentStatus? status,
    DateTime? paidAt,
    String? note,
  }) {
    return PaymentRecord(
      id: id ?? this.id,
      memberId: memberId ?? this.memberId,
      memberName: memberName ?? this.memberName,
      planName: planName ?? this.planName,
      amount: amount ?? this.amount,
      method: method ?? this.method,
      status: status ?? this.status,
      paidAt: paidAt ?? this.paidAt,
      note: note ?? this.note,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'memberId': memberId,
        'memberName': memberName,
        'planName': planName,
        'amount': amount,
        'method': method.name,
        'status': status.name,
        'paidAt': paidAt.toIso8601String(),
        'note': note,
      };

  factory PaymentRecord.fromJson(Map<String, dynamic> json) => PaymentRecord(
        id: json['id'] as String? ?? '',
        memberId: json['memberId'] as String? ?? '',
        memberName: json['memberName'] as String? ?? '',
        planName: json['planName'] as String? ?? '',
        amount: (json['amount'] as num?)?.toInt() ?? 0,
        method: PaymentMethod.fromString(json['method'] as String?),
        status: PaymentStatus.fromString(json['status'] as String?),
        paidAt: DateTime.tryParse(json['paidAt'] as String? ?? '') ??
            DateTime.now(),
        note: json['note'] as String? ?? '',
      );
}

/// A workout plan at `gyms/{gymId}/workout_plans/{id}`.
class WorkoutPlan {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final String assignedMemberId;
  final List<String> exercises;

  const WorkoutPlan({
    required this.id,
    required this.name,
    this.description = '',
    this.imageUrl = '',
    this.assignedMemberId = '',
    this.exercises = const [],
  });

  WorkoutPlan copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    String? assignedMemberId,
    List<String>? exercises,
  }) {
    return WorkoutPlan(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      assignedMemberId: assignedMemberId ?? this.assignedMemberId,
      exercises: exercises ?? this.exercises,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'imageUrl': imageUrl,
        'assignedMemberId': assignedMemberId,
        'exercises': exercises,
      };

  factory WorkoutPlan.fromJson(Map<String, dynamic> json) => WorkoutPlan(
        id: json['id'] as String? ?? '',
        name: json['name'] as String? ?? '',
        description: json['description'] as String? ?? '',
        imageUrl: json['imageUrl'] as String? ?? '',
        assignedMemberId: json['assignedMemberId'] as String? ?? '',
        exercises: (json['exercises'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList() ??
            const [],
      );
}

/// A diet plan at `gyms/{gymId}/diet_plans/{id}`.
class DietPlan {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final String assignedMemberId;
  final List<String> meals;

  const DietPlan({
    required this.id,
    required this.name,
    this.description = '',
    this.imageUrl = '',
    this.assignedMemberId = '',
    this.meals = const [],
  });

  DietPlan copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    String? assignedMemberId,
    List<String>? meals,
  }) {
    return DietPlan(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      assignedMemberId: assignedMemberId ?? this.assignedMemberId,
      meals: meals ?? this.meals,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'imageUrl': imageUrl,
        'assignedMemberId': assignedMemberId,
        'meals': meals,
      };

  factory DietPlan.fromJson(Map<String, dynamic> json) => DietPlan(
        id: json['id'] as String? ?? '',
        name: json['name'] as String? ?? '',
        description: json['description'] as String? ?? '',
        imageUrl: json['imageUrl'] as String? ?? '',
        assignedMemberId: json['assignedMemberId'] as String? ?? '',
        meals: (json['meals'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList() ??
            const [],
      );
}

/// An announcement / notification at `gyms/{gymId}/notifications/{id}`.
class GymNotification {
  final String id;
  final String title;
  final String body;
  final String topic;
  final DateTime createdAt;

  const GymNotification({
    required this.id,
    required this.title,
    this.body = '',
    this.topic = 'announcements',
    required this.createdAt,
  });

  GymNotification copyWith({
    String? id,
    String? title,
    String? body,
    String? topic,
    DateTime? createdAt,
  }) {
    return GymNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      topic: topic ?? this.topic,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'body': body,
        'topic': topic,
        'createdAt': createdAt.toIso8601String(),
      };

  factory GymNotification.fromJson(Map<String, dynamic> json) =>
      GymNotification(
        id: json['id'] as String? ?? '',
        title: json['title'] as String? ?? '',
        body: json['body'] as String? ?? '',
        topic: json['topic'] as String? ?? 'announcements',
        createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
            DateTime.now(),
      );
}
