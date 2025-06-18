import 'package:payment_jumbo_machine/fonts/appFonts.dart';
import 'package:flutter/material.dart';
import '../fonts/appColor.dart';

class NumberPad extends StatefulWidget {
  final Function(String) onPressed;
  final String control;

  const NumberPad({super.key, required this.onPressed, required this.control});

  @override
  _NumberPadState createState() => _NumberPadState();
}

class _NumberPadState extends State<NumberPad> {
  final List<String> keys = [
    '7', '8', '9',
    '4', '5', '6',
    '1', '2', '3',
    'clr', '0', 'del',
  ];

  Color _getBackgroundColor(String key) {
    if (widget.control.isEmpty && (key == 'del' || key == 'clr')) {
      return Colors.grey;
    }
    if (key == 'del') return Colors.redAccent;
    if (key == 'clr') return Colors.orangeAccent;
    return AppColors.pinkcm;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 3,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      padding: const EdgeInsets.all(15),
      children: keys.map((key) {
        return ElevatedButton(
          onPressed: () {
            widget.onPressed(key);
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(24),
            backgroundColor: _getBackgroundColor(key),
            elevation: 10,
          ),
          child: Text(key,
            style: TextStyle(fontSize: (key == 'clr' || key == 'del') ? width * .025 : width * .05, fontFamily: AppFonts.traJanProBold, color: AppColors.white), //35 : 60
          ),
        );
      }).toList(),
    );
  }
}
