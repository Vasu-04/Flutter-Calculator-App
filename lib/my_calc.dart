import 'package:flutter/material.dart';

class MyCalc extends StatefulWidget {
  const MyCalc({super.key});

  @override
  State<MyCalc> createState() => _MyCalcState();
}

class _MyCalcState extends State<MyCalc> {
  String display = "";
  TextEditingController ctlr = TextEditingController();
  List<String> stack = [];

  void evaluate(String variable) {
    var op = ['%', '+', '-', '/', '*'];
    if (stack.isEmpty && variable == '=') return;

    if (op.contains(variable)) {
      if (stack.isNotEmpty && op.contains(stack.last)) {
        stack[stack.length - 1] = variable;
      } else {
        stack.add(variable);
      }
    } else if (variable == "~") {
      if (stack.isNotEmpty && !op.contains(stack.last)) {
        stack[stack.length - 1] = ((-1) * (int.parse(stack.last))).toString();
      }
    } else if (variable == "X") {
      if (stack.isNotEmpty) {
        stack.removeLast();
      }
    } else if (variable == "C") {
      stack.clear();
    } else if (variable == "=") {
      if (stack.isNotEmpty && !op.contains(stack.last)) {
        while (stack.contains('/')) {
          int i = stack.indexOf('/');
          stack[i - 1] = (double.parse(stack[i - 1]) / double.parse(stack[i + 1])).toString();
          stack.removeAt(i);
          stack.removeAt(i);
        }
        while (stack.contains('*')) {
          int i = stack.indexOf('*');
          stack[i - 1] = (double.parse(stack[i - 1]) * double.parse(stack[i + 1])).toString();
          stack.removeAt(i);
          stack.removeAt(i);
        }
        while (stack.contains('%')) {
          int i = stack.indexOf('%');
          stack[i - 1] = (double.parse(stack[i - 1]) % double.parse(stack[i + 1])).toString();
          stack.removeAt(i);
          stack.removeAt(i);
        }
        while (stack.contains('+')) {
          int i = stack.indexOf('+');
          stack[i - 1] = (double.parse(stack[i - 1]) + double.parse(stack[i + 1])).toString();
          stack.removeAt(i);
          stack.removeAt(i);
        }
        while (stack.contains('-')) {
          int i = stack.indexOf('-');
          stack[i - 1] = (double.parse(stack[i - 1]) - double.parse(stack[i + 1])).toString();
          stack.removeAt(i);
          stack.removeAt(i);
        }
        display = stack[0];
        stack.clear();
        stack.add(display);
      }
    } else {
      if (stack.isEmpty || op.contains(stack.last)) {
        stack.add(variable);
      } else {
        stack[stack.length - 1] += variable;
      }
    }

    setState(() {
      display = stack.join(' ');
      ctlr.text = display;
    });
  }

  void submitForm(String temp) {
    evaluate(temp);
  }

  @override
  Widget build(BuildContext context) {
    List<List> btnsTxt = [
      ['C', 'X', '~', '/'],
      ['7', '8', '9', '*'],
      ['4', '5', '6', '-'],
      ['1', '2', '3', '+'],
      ['%', '0', '.', '='],
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: const Icon(
          Icons.calculate,
          size: 50,
          color: Colors.white,
        ),
        title: const Text(
          "Calculator",
          style: TextStyle(
            fontSize: 30,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: Container(
        padding: const EdgeInsets.all(30),
        margin: const EdgeInsets.only(top: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextField(
              controller: ctlr,
              textAlign: TextAlign.right,
              style: const TextStyle(color: Colors.white, fontSize: 50),
              decoration: const InputDecoration(
                  hintText: "0",
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 50),
                  border: InputBorder.none),
            ),
            Divider(
              indent: 10,
              endIndent: 10,
              color: Color.fromARGB(255, 32, 32, 32),
            ),
            // const SizedBox(
            //   height: 20,
            // ),
            ...btnsTxt.map((element) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ...element.map((val) {
                    return ElevatedButton(
                      onPressed: () => submitForm(val),
                      child: Text(
                        val,
                        style: const TextStyle(fontSize: 35, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(33),
                        
                        backgroundColor: 
                        (val == 'C' || val == 'X' || val == '~' || val == '/' || val == '*' || val == '-' || val == '+')?
                        Color.fromARGB(255, 78, 47, 34):
                          (val == '=')?Color.fromARGB(255, 121, 42, 18):Color.fromARGB(255, 32, 32, 32)
                      ),
                    );
                  }).toList()
                ],
              );
            }).toList()
          ],
        ),
      ),
    );
  }
}