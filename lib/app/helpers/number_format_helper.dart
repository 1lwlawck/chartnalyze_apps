import 'package:intl/intl.dart';

class NumberFormatHelper {
  static String usdt(double value, {int decimal = 2}) {
    return NumberFormat.currency(symbol: '\$', decimalDigits: decimal)
        .format(value);
  }

  static String compact(double value) {
    return NumberFormat.compactCurrency(symbol: '\$', decimalDigits: 0)
        .format(value);
  }

  static String percent(double value) {
    return '${value.toStringAsFixed(2)}%';
  }
}
