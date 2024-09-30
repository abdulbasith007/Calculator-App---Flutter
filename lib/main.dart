import 'package:flutter/material.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CalculatorHome(),
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
              child: Text(
                display,
                style: TextStyle(fontSize: 48),
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
          if (label == 'C') {
            clearCalculator();
          } else if (label == '=') {
            performCalculation();
          } else if (['+', '-', '*', '/'].contains(label)) {
            num1 = double.parse(display);
            operator = label;
            display = "";
          } else {
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
    });
  }

  void performCalculation() {
    double num2 = double.parse(display);
    double result;
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
    display = result.toString();
  }
}
