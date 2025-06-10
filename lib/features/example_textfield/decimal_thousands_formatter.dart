import 'package:flutter/services.dart';

class DecimalThousandsFormatter extends TextInputFormatter {
  final String thousandSep;
  final String decimalSep;
  DecimalThousandsFormatter({
    this.thousandSep = ' ',
    this.decimalSep = ',',
  });

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // 1) Nuqtani ham vergulga almashtiramiz (agar kimdir nuqta bossagina ham ishlasin)
    String text = newValue.text.replaceAll('.', decimalSep);

    // 2) Faqat raqam va bitta vergul ruxsat: ortiqcha belgilarni olib tashlaymiz
    final allowed = RegExp('[0-9${RegExp.escape(decimalSep)}]');
    text = text.split('').where((c) => allowed.hasMatch(c)).join();

    // 3) Bitta vergul qolishi uchun bo‘lib, qolganlarini birlashtiramiz
    final parts = text.split(decimalSep);
    final intPart = parts[0];
    final fracPart = parts.length > 1 ? parts.sublist(1).join() : '';

    // 4) Minglik ajratuvchini qo‘llaymiz
    final formattedInt = intPart.replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (_) => thousandSep,
    );

    print('formattedInt: $formattedInt');

    // 5) Yakuniy natija: agar kasr qismi bo‘lsa, vergul bilan birga qo‘shamiz
    final result = text.contains(',') ? '$formattedInt$decimalSep$fracPart' : formattedInt;

    // 6) Kursor joyini to‘g‘rilaymiz
    var offset = newValue.selection.end + (result.length - newValue.text.length);
    offset = offset.clamp(0, result.length);

    return TextEditingValue(
      text: result,
      selection: TextSelection.collapsed(offset: offset),
    );
  }
}
