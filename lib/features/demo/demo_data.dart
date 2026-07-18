import '../../core/constants/enums.dart';

/// Static, realistic dummy data powering the client demo. Kept in one place so
/// screens stay declarative and the data reads consistently across the app.
///
/// Nothing here touches a backend — it exists purely to make the UI feel like a
/// real, populated product during a gym-owner walkthrough.
class DemoData {
  DemoData._();

  static const String gymName = 'Iron Forge Fitness';
  static const String ownerName = 'Arjun Mehta';
  static const String ownerEmail = 'arjun@ironforge.fit';

  // ---- Dashboard KPIs -------------------------------------------------------

  static const int todayRevenue = 48200;
  static const int activeMembers = 342;
  static const int todayAttendance = 128;
  static const int pendingRenewals = 17;

  /// Weekly revenue in ₹ thousands, Mon→Sun — feeds the dashboard line chart.
  static const List<double> weeklyRevenue = [32, 41, 38, 52, 47, 61, 48];
  static const List<String> weekdayLabels = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];

  // ---- Recent payments ------------------------------------------------------

  static const List<DemoPayment> recentPayments = [
    DemoPayment('Rohan Sharma', 'Quarterly', 4500, PaymentStatus.paid, 0),
    DemoPayment('Priya Nair', 'Monthly', 1800, PaymentStatus.paid, 0),
    DemoPayment('Kabir Singh', 'Yearly', 14000, PaymentStatus.partial, 1),
    DemoPayment('Ananya Rao', 'Monthly', 1800, PaymentStatus.pending, 1),
    DemoPayment('Vikram Patel', 'Half Yearly', 8000, PaymentStatus.paid, 2),
    DemoPayment('Sneha Iyer', 'Quarterly', 4500, PaymentStatus.paid, 3),
  ];

  // ---- Members --------------------------------------------------------------

  static const List<DemoMember> members = [
    DemoMember('Rohan Sharma', 'Quarterly', MembershipStatus.active, 42),
    DemoMember('Priya Nair', 'Monthly', MembershipStatus.active, 12),
    DemoMember('Kabir Singh', 'Yearly', MembershipStatus.active, 210),
    DemoMember('Ananya Rao', 'Monthly', MembershipStatus.expiringSoon, 3),
    DemoMember('Vikram Patel', 'Half Yearly', MembershipStatus.active, 88),
    DemoMember('Sneha Iyer', 'Quarterly', MembershipStatus.expiringSoon, 5),
    DemoMember('Aditya Kumar', 'Monthly', MembershipStatus.expired, -6),
    DemoMember('Meera Joshi', 'Yearly', MembershipStatus.active, 150),
    DemoMember('Rahul Verma', 'Monthly', MembershipStatus.frozen, 20),
    DemoMember('Isha Gupta', 'Quarterly', MembershipStatus.active, 33),
    DemoMember('Karan Malhotra', 'Monthly', MembershipStatus.expired, -14),
    DemoMember('Divya Menon', 'Half Yearly', MembershipStatus.active, 74),
  ];

  // ---- Analytics ------------------------------------------------------------

  /// Six-month revenue trend in ₹ thousands.
  static const List<double> monthlyRevenue = [180, 210, 195, 240, 268, 305];
  static const List<String> monthLabels = [
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
  ];

  /// Daily attendance for the current week — feeds the analytics bar chart.
  static const List<double> weeklyAttendance = [96, 112, 104, 128, 118, 141, 88];

  /// New member sign-ups over six months.
  static const List<double> newMembers = [24, 31, 28, 40, 46, 52];

  /// Membership plan distribution — feeds the analytics donut chart.
  static const List<DemoDistribution> planDistribution = [
    DemoDistribution('Monthly', 148),
    DemoDistribution('Quarterly', 96),
    DemoDistribution('Half Yearly', 58),
    DemoDistribution('Yearly', 40),
  ];
}

class DemoPayment {
  final String name;
  final String plan;
  final int amount;
  final PaymentStatus status;

  /// Whole days before "now" the payment landed — rendered as a relative date.
  final int daysAgo;

  const DemoPayment(this.name, this.plan, this.amount, this.status, this.daysAgo);
}

class DemoMember {
  final String name;
  final String plan;
  final MembershipStatus status;

  /// Days until expiry (negative = already expired).
  final int daysToExpiry;

  const DemoMember(this.name, this.plan, this.status, this.daysToExpiry);
}

class DemoDistribution {
  final String label;
  final int value;
  const DemoDistribution(this.label, this.value);
}
