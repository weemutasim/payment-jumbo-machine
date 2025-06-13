/* import 'package:flutter/material.dart';

class CustomInputWithNumberPad extends StatefulWidget {
  const CustomInputWithNumberPad({super.key});

  @override
  State<CustomInputWithNumberPad> createState() => _CustomInputWithNumberPadState();
}

class _CustomInputWithNumberPadState extends State<CustomInputWithNumberPad> {
  final TextEditingController _controller = TextEditingController();

  void _handleKeyTap(String key) {
    setState(() {
      if (key == 'DEL') {
        if (_controller.text.isNotEmpty) {
          _controller.text = _controller.text.substring(0, _controller.text.length - 1);
        }
      } else {
        _controller.text += key;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Column(
      children: [
        SizedBox(
          width: width * .15,
          height: height * .15,
          child: TextField(
            controller: _controller,
            readOnly: true, // ปิดการใช้แป้นพิมพ์
            decoration: InputDecoration(
              labelText: 'receive',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              labelStyle: TextStyle(
                fontFamily: 'TrajanPro', // แทน AppFonts.traJanProBold
                fontSize: 25,
                color: const Color.fromARGB(255, 20, 91, 214),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.pink, width: 2), // แทน AppColors.pinkcm
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: height * 0.4,
          child: GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            padding: const EdgeInsets.all(16),
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            children: [
              ...['1','2','3','4','5','6','7','8','9','DEL','0'].map((key) {
                return ElevatedButton(
                  onPressed: () => _handleKeyTap(key),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(24),
                    backgroundColor: key == 'DEL' ? Colors.red : null,
                  ),
                  child: Text(
                    key,
                    style: const TextStyle(fontSize: 24),
                  ),
                );
              }),
            ],
          ),
        )
      ],
    );
  }
}
 */

/* Container(
                  width: width * .15,
                  height: width * .1,
                  decoration: BoxDecoration(
                    border: Border.all()
                  ),
                  child: Column(
                    children: [
                      Text('Net', style: TextStyle(fontFamily: AppFonts.traJanProBold, fontSize: 30, color: Colors.lightBlue)),
                      Text(price.toInt().toString(), style: TextStyle(fontFamily: AppFonts.traJanProBold, fontSize: 30, color: AppColors.black)),
                      const Divider(indent: 10, endIndent: 10)
                    ],
                  ),
                ),
                Container(
                  width: width * .15,
                  height: width * .1,
                  decoration: BoxDecoration(
                    border: Border.all()
                  ),
                  child: Column(
                    children: [
                      Text('Total', style: TextStyle(fontFamily: AppFonts.traJanProBold, fontSize: 30, color: Colors.lightBlue)),
                      Text(price.toStringAsFixed(2), style: TextStyle(fontFamily: AppFonts.traJanProBold, fontSize: 30, color: AppColors.black)),
                      const Divider(indent: 10, endIndent: 10)
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: width * .15,
                  height: height * .15,
                  child: TextField(
                    readOnly: true,
                    controller: _controller,
                    decoration: InputDecoration(
                      labelText: 'receive',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      labelStyle: TextStyle(fontFamily: AppFonts.traJanProBold, fontSize: 25, color: const Color.fromARGB(255, 20, 91, 214)),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.pinkcm, width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: width * .3,
                  height: width * .1,
                  decoration: BoxDecoration(
                    border: Border.all()
                  ),
                  child: Row(
                    children: [
                      Text('Net total : ', style: TextStyle(fontFamily: AppFonts.traJanProBold, fontSize: 30, color: Colors.lightBlue)),
                      Text(price.toStringAsFixed(2), style: TextStyle(fontFamily: AppFonts.traJanProBold, fontSize: 30, color: AppColors.black)),
                    ],
                  ),
                ),
                Container(
                  width: width * .3,
                  height: width * .1,
                  decoration: BoxDecoration(
                    border: Border.all()
                  ),
                  child: Row(
                    children: [
                      Text('Change : ', style: TextStyle(fontFamily: AppFonts.traJanProBold, fontSize: 30, color: Colors.lightBlue)),
                      Text(price.toStringAsFixed(2), style: TextStyle(fontFamily: AppFonts.traJanProBold, fontSize: 30, color: AppColors.black)),
                    ],
                  ),
                ), */

               /* SizedBox(
                  width: width * .35,
                  height: height * .15,
                  child: TextField(
                    readOnly: true,
                    controller: _controller,
                    decoration: InputDecoration(
                      labelText: 'receive',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      labelStyle: TextStyle(fontFamily: AppFonts.traJanProBold, fontSize: 25, color: const Color.fromARGB(255, 20, 91, 214)),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.pinkcm, width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ), */
         /* SizedBox(
            height: 500,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 3, // width/height ratio of items
              ),
              itemCount: 50,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: AppColors.black),
                    borderRadius: BorderRadius.circular(8)
                  ),
                );
              },
            ),
          ) */