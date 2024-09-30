import 'package:flutter/material.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CalculatorHome(),
      theme: ThemeData(primarySwatch: Colors.blue),
    );
  }
}

class CalculatorHome extends StatefulWidget {
  @override
  _CalculatorHomeState createState() => _CalculatorHomeState();
}

class _CalculatorHomeState extends State<CalculatorHome> {
  String display = "";
  double num1 = 0;
  String operator = "";
  bool hasDecimal = false;
  bool isError = false; // I added this to show append the numbers when ERROR gets shown

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Simple Calculator')),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.all(20),
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey, width: 2),
              ),
              child: Text(
                display.isEmpty ? "0" : display,
                style: TextStyle(fontSize: 48, color: Colors.black),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: GridView.count(
              crossAxisCount: 4,
              children: [
                ...['7', '8', '9', '/'].map(buildButton),
                ...['4', '5', '6', '*'].map(buildButton),
                ...['1', '2', '3', '-'].map(buildButton),
                ...['C', '0', '.', '=', '+'].map(buildButton),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildButton(String label) {
    return InkWell(
      onTap: () {
        setState(() {
          if (isError) {
            // In order to reset if the last state was an error
            clearCalculator();
          }

          if (label == 'C') {
            clearCalculator();
          } else if (label == '=') {
            performCalculation();
          } else if (label == '.' && !hasDecimal) {
            display += label;
            hasDecimal = true;
          } else if (['+', '-', '*', '/'].contains(label)) {
            if (display.isNotEmpty && !isError) {
              num1 = double.parse(display);
              operator = label;
              display = "";
              hasDecimal = false;
            }
          } else if (label != '.') {
            display += label;
          }
        });
      },
      child: Container(
        margin: EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.blueGrey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }

  void clearCalculator() {
    setState(() {
      display = "";
      num1 = 0;
      operator = "";
      hasDecimal = false;
      isError = false;
    });
  }

  void performCalculation() {
    double num2 = double.parse(display);
    double result;

    if (operator == '/' && num2 == 0) {
      setState(() {
        display = "Error";
        isError = true;
      });
      return;
    }

    switch (operator) {
      case '+':
        result = num1 + num2;
        break;
      case '-':
        result = num1 - num2;
        break;
      case '*':
        result = num1 * num2;
        break;
      case '/':
        result = num1 / num2;
        break;
      default:
        result = 0;
    }

    setState(() {
      display = result.toStringAsFixed(2).replaceAll(RegExp(r"([.]*0+)(?!.*\d)"), ""); // Added this for floating point issue
      hasDecimal = display.contains('.');
    });
  }
}
