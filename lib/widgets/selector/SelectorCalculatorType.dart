import 'package:flutter/material.dart';

class SelectorCalculatorType extends StatefulWidget {
  final SelectorCalculatorTypeController controller;

  const SelectorCalculatorType({
    key,
    required this.controller,
  }) : super(key: key);

  @override
  _SelectorCalculatorTypeState createState() => _SelectorCalculatorTypeState();
}

class _SelectorCalculatorTypeState extends State<SelectorCalculatorType> {
  @override
  Widget build(BuildContext context) {

    //todo build dropdown
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Colors.white70, width: 1),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Container(
        // width: double.infinity,
        height: 44,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(22)),

      ),
    );
  }

}

class SelectorCalculatorTypeController {
  late Function(CalculatorType) onAgreementChange;
  late CalculatorType calculatorType;

  SelectorCalculatorTypeController.standard() {
    calculatorType = CalculatorType.Standard;
  }
  SelectorCalculatorTypeController.sameday() {
    calculatorType = CalculatorType.SamedayPreBook;
  }

  SelectorCalculatorTypeController.value(this.calculatorType);

  CalculatorType getAgreement() {
    return calculatorType;
  }

  addListener(Function(CalculatorType) listener) {
    onAgreementChange = listener;
  }
}

enum CalculatorType { Standard, SamedayPreBook, SamedayOnDemand }
