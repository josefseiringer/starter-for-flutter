import 'package:flutter/material.dart';

class CustomNumericKeyboard extends StatefulWidget {
  final ValueChanged<String> onValueChanged;

  const CustomNumericKeyboard({super.key, required this.onValueChanged});

  @override
  State<CustomNumericKeyboard> createState() => _CustomNumericKeyboardState();
}

class _CustomNumericKeyboardState extends State<CustomNumericKeyboard> {
  String _currentValue = '';

  void _onKeyPress(String key) {
    setState(() {
      if (key == 'DEL') {
        if (_currentValue.isNotEmpty) {
          _currentValue = _currentValue.substring(0, _currentValue.length - 1);
        }
      } else {
        _currentValue += key;
      }
      widget.onValueChanged(_currentValue);
    });
  }

  @override
  Widget build(BuildContext context) {
    final fontSizeOfInputData = 35.0;
    final fontSizeOfInputField = 20.0;
    return Column(
      children: [
        Text(
          _currentValue,
          style: TextStyle(
            fontSize: fontSizeOfInputData,
          ),
        ),
        Expanded(
          child: GridView.count(
            crossAxisCount: 3,
            mainAxisSpacing: 5.0,
            crossAxisSpacing: 2.5,
            childAspectRatio: 1.7,
            shrinkWrap: true,
            children: <Widget>[
              ...List.generate(9, (index) {
                return Container(
                  color: Colors.blue.shade400,
                  child: TextButton(
                    onPressed: () => _onKeyPress((index + 1).toString()),
                    child: Text(
                      (index + 1).toString(),
                      style: TextStyle(
                        fontSize: fontSizeOfInputField,
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              }),
              Container(
                color: Colors.blue.shade400,
                child: TextButton(
                  onPressed: () {},
                  child: const Text(''),
                ),
              ),
              Container(
                color: Colors.blue.shade400,
                child: TextButton(
                  onPressed: () => _onKeyPress('0'),
                  child: Text(
                    '0',
                    style: TextStyle(
                      fontSize: fontSizeOfInputField,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Container(
                color: Colors.blue.shade400,
                child: TextButton(
                  onPressed: () => _onKeyPress('DEL'),
                  child: Text(
                    'C',
                    style: TextStyle(
                      fontSize: fontSizeOfInputField,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
