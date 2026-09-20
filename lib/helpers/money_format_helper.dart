// String formatMoney(
//   dynamic value, {
//   int decimalDigits = 2,
//   String fallback = '0.00',
// }) {
//   if (value == null) {
//     return fallback;
//   }

//   double? amount;

//   if (value is num) {
//     amount = value.toDouble();
//   } else {
//     final raw = value.toString().trim().replaceAll(',', '').replaceAll(' ', '');

//     if (raw.isEmpty || raw.toLowerCase() == 'null') {
//       return fallback;
//     }

//     amount = double.tryParse(raw);
//   }

//   if (amount == null) {
//     return fallback;
//   }

//   final isNegative = amount < 0;
//   final fixed = amount.abs().toStringAsFixed(decimalDigits);
//   final parts = fixed.split('.');

//   final integerPart = parts.first;
//   final decimalPart = parts.length > 1 ? parts[1] : '';

//   String formattedInteger;

//   if (integerPart.length <= 3) {
//     formattedInteger = integerPart;
//   } else {
//     final lastThree = integerPart.substring(integerPart.length - 3);
//     final remaining = integerPart.substring(0, integerPart.length - 3);

//     final groups = <String>[];
//     var end = remaining.length;

//     while (end > 0) {
//       final start = end - 2 < 0 ? 0 : end - 2;
//       groups.insert(0, remaining.substring(start, end));
//       end = start;
//     }

//     formattedInteger = '${groups.join(',')},$lastThree';
//   }

//   final sign = isNegative ? '-' : '';

//   if (decimalDigits <= 0) {
//     return '$sign$formattedInteger';
//   }

//   return '$sign$formattedInteger.$decimalPart';
// }

//--------------------------------------------------------------------------------------------------------

String formatMoney(
  dynamic value, {
  int decimalDigits = 2,
  String fallback = '0.00',
}) {
  if (value == null) {
    return fallback;
  }

  double? amount;

  if (value is num) {
    amount = value.toDouble();
  } else {
    final raw = value.toString().trim().replaceAll(',', '').replaceAll(' ', '');

    if (raw.isEmpty || raw.toLowerCase() == 'null') {
      return fallback;
    }

    amount = double.tryParse(raw);
  }

  if (amount == null) {
    return fallback;
  }

  final isNegative = amount < 0;
  final fixed = amount.abs().toStringAsFixed(decimalDigits);
  final parts = fixed.split('.');

  final integerPart = parts.first;
  final decimalPart = parts.length > 1 ? parts[1] : '';

  final formattedInteger = integerPart.replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (match) => ',',
  );

  final sign = isNegative ? '-' : '';

  if (decimalDigits <= 0) {
    return '$sign$formattedInteger';
  }

  return '$sign$formattedInteger.$decimalPart';
}
