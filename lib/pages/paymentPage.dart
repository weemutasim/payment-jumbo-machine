import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../fonts/appColor.dart';
import '../fonts/appFonts.dart';
import '../utils/numberPad.dart';

class PaymentPage extends StatefulWidget {
  final int price;
  const PaymentPage({super.key, required this.price});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final NumberFormat numberFormat = NumberFormat('#,###', 'en_US');
  final TextEditingController _controller = TextEditingController();
  // double price = 1350.00;
  double change = 0;
  double vat = 0.0;

  img.Image? headPop;
  img.Image? thank;
  img.Image? lgogGame;
  img.Image? line;

  @override
  void initState() {
    _loadImages();

    super.initState();
  }

  void _handleKeyTap(String key) {
    if(key == 'clr') {
      if(_controller.text.isNotEmpty) _controller.clear();
    } else if (key == 'del') {
      if (_controller.text.isNotEmpty) _controller.text = _controller.text.substring(0, _controller.text.length - 1);
    } else {
      if (_controller.text.isEmpty && key == '0') return;
      if (_controller.text.length < 6) _controller.text += key;
    }

    setState(() {
      double input = double.tryParse(_controller.text) ?? .0;
      vat = widget.price * .07;
      change = input - widget.price;
    });
  }

  Future<void> _loadImages() async {
    try {
      ByteData dataLogo = await rootBundle.load('assets/images/bill/JUMBO.png');
      Uint8List uint8ListLogo = dataLogo.buffer.asUint8List();
      img.Image? decodedHeadLogo = img.decodeImage(uint8ListLogo);
      headPop = img.copyResize(decodedHeadLogo!, width: 500);

      ByteData dataThank = await rootBundle.load('assets/images/bill/thk1.png');
      Uint8List uint8ListsThank = dataThank.buffer.asUint8List();
      img.Image? decodedThank = img.decodeImage(uint8ListsThank);
      thank = img.copyResize(decodedThank!, width: 500);

      ByteData dataLogoGame = await rootBundle.load('assets/images/bill/logoJR.png');
      Uint8List uint8ListsThankGame = dataLogoGame.buffer.asUint8List();
      img.Image? decodedThankGame = img.decodeImage(uint8ListsThankGame);
      lgogGame = img.copyResize(decodedThankGame!, width: 500);

      ByteData dataline = await rootBundle.load('assets/recipt/lineBT.png');
      Uint8List uint8Listsline = dataline.buffer.asUint8List();
      img.Image? decodedline = img.decodeImage(uint8Listsline);
      line = img.copyResize(decodedline!, width: 550);

    } catch (e) {
      print(e); 
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.pinkcm,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.white, size: 30),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text("pay", style: TextStyle(fontFamily: AppFonts.traJanProBold, fontSize: 25, color: AppColors.white)),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: width * .55,
            decoration: BoxDecoration(
              // border: Border.all()
            ),
            child: Column(
              children: [
                SizedBox(height: height * .05),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildContainer(width, 'Net', widget.price.toInt().toString(), AppColors.pinkcm),
                    _buildContainer(width, 'Net Total', widget.price.toStringAsFixed(2), AppColors.pinkcm),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                    _buildContainer(width, 'Total', widget.price.toStringAsFixed(2), AppColors.pinkcm),
                    _buildContainer(width, 'Change', change.toStringAsFixed(2), 
                      (_controller.text.isNotEmpty && int.parse(_controller.text) < widget.price) ? Colors.red : _controller.text == widget.price.toString() ? Colors.green : Colors.orange),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: width * .15,
                      height: width * .1,
                    ),
                    _buildContainer(width, 'Vat', vat.toStringAsFixed(2), AppColors.pinkcm),
                  ],
                ),
                SizedBox(height: height * .1),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _receive(width, height),
                    const SizedBox(width: 20),
                    _buildButton(130, 'cancel', Colors.red, () => Navigator.of(context).pop(), 0),
                    const SizedBox(width: 10),
                    _buildButton(180, 'confirm', Colors.green, _controller.text.isNotEmpty ? () {
                      
                    } : null, 1)
                  ],
                ),
              ],
            ),
          ),
          Container( //KeyTap
            width: width * .45,
            padding: EdgeInsets.only(left: width * .05, right: width * .04),
            decoration: BoxDecoration(
              // border: Border.all()
            ),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.pinkcm),
                borderRadius: BorderRadius.circular(25),
              ),
              child: NumberPad(
                onPressed: (String key) => _handleKeyTap(key),
                control: _controller.text,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(double width, String title, MaterialColor color, VoidCallback? onPressed, int chk) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width,
        height: 115,
        decoration: BoxDecoration(
          border: Border.all(color: (chk == 1 && _controller.text.isEmpty) ? Colors.grey : color, width: 3),
          borderRadius: BorderRadius.circular(8)
        ),
        child: Center(child: Text(title, style: TextStyle(fontFamily: AppFonts.traJanPro, fontSize: 25, fontWeight: FontWeight.bold, color: (chk == 1 && _controller.text.isEmpty) ? Colors.grey : color))),
      ),
    );
  }

  Widget _buildContainer(double width, String title, String total, Color colors) {
    return Container(
      width: width * .15,
      height: width * .1,
      decoration: BoxDecoration(
        // border: Border.all()
      ),
      child: Column(
        children: [
          Text(title, style: TextStyle(fontFamily: AppFonts.traJanProBold, fontSize: width * .023, color: AppColors.text)), //30
          Text(total, style: TextStyle(fontFamily: AppFonts.traJanProBold, fontSize: width * .023, color: colors)),
          Divider(indent: 10, endIndent: 10, color: AppColors.black)
        ],
      ),
    );
  }

  Widget _receive(double width, double height) {
    return SizedBox(
      width: width * 0.26,
      height: height * 0.15,
      child: TextField(
        readOnly: true,
        showCursor: false, // ||?
        controller: TextEditingController(
          text: _controller.text.isNotEmpty ? numberFormat.format(double.tryParse(_controller.text) ?? 0) : '',
        ),
        keyboardType: TextInputType.number,
        style: TextStyle(fontFamily: AppFonts.traJanProBold, fontSize: width * .04, color: (_controller.text.isEmpty ? .0 : double.parse(_controller.text)) >= widget.price ? Colors.green : Colors.red[400]),
        decoration: InputDecoration(
          labelText: 'Receive',
          labelStyle: TextStyle(fontFamily: AppFonts.traJanProBold, fontSize: width * .03, color: AppColors.blueReceive),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.pinkcm, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        ),
      ),
    );
  }
}