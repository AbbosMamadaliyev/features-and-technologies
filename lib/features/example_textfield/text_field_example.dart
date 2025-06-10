import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'decimal_thousands_formatter.dart' show DecimalThousandsFormatter;

class ExampleDigitTextFieldScreen extends StatefulWidget {
  const ExampleDigitTextFieldScreen({super.key});

  @override
  State<ExampleDigitTextFieldScreen> createState() => _ExampleDigitTextFieldScreenState();
}

class _ExampleDigitTextFieldScreenState extends State<ExampleDigitTextFieldScreen> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Example Digit TextField'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter digits',
                hintText: 'Only digits allowed',
              ),
              inputFormatters: [
                DecimalThousandsFormatter(thousandSep: ' '),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
