import 'package:intl/intl.dart';

/// Formatting helpers for currency, dates and numbers, centralized so the whole
/// app shows values consistently (₹ by default — configurable per gym later).
class Formatters {
  Formatters._();

  static final NumberFormat _currency = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 0,
  );

  static final NumberFormat _compact =
      NumberFormat.compactCurrency(locale: 'en_IN', symbol: '₹');

  static String currency(num value) => _currency.format(value);
  static String compactCurrency(num value) => _compact.format(value);

  static String date(DateTime d) => DateFormat('dd MMM yyyy').format(d);
  static String dateTime(DateTime d) => DateFormat('dd MMM, hh:mm a').format(d);
  static String time(DateTime d) => DateFormat('hh:mm a').format(d);
  static String dayMonth(DateTime d) => DateFormat('dd MMM').format(d);
  static String monthYear(DateTime d) => DateFormat('MMM yyyy').format(d);
  static String weekday(DateTime d) => DateFormat('EEE').format(d);
  static String isoDate(DateTime d) => DateFormat('yyyy-MM-dd').format(d);

  /// "3 days left" / "Expired 2 days ago" style relative expiry text.
  static String relativeExpiry(DateTime expiry) {
    final now = DateTime.now();
    final diff =
        expiry.difference(DateTime(now.year, now.month, now.day)).inDays;
    if (diff == 0) return 'Expires today';
    if (diff > 0) return '$diff day${diff == 1 ? '' : 's'} left';
    final ago = -diff;
    return 'Expired $ago day${ago == 1 ? '' : 's'} ago';
  }

  static String initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }
}
