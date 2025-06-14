import 'package:image/image.dart' as img;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:payment_jumbo_machine/apis/DbConnect.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../fonts/appColor.dart';
import '../fonts/appFonts.dart';
import '../receips/receiptPopcorn.dart';
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
  img.Image? headPop, thank, headENG, fStar, line1, line2, nonRefun, combinedImage, game2, game5, game10, game15, game20, game50, select;

  // double price = 1350.00;
  double change = 0;
  double vat = 0.0;

  @override
  void initState() {
    _loadImages();

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  img.Image combineImagesWithOffset(List<img.Image> images, int spacing, {int rightOffset = 30}) {
    if (images.isEmpty) return img.Image(1, 1);

    int totalWidth = 0;
    int maxHeight = 0;
    for (final image in images) {
      totalWidth += image.width;
      if (image.height > maxHeight) maxHeight = image.height;
    }

    totalWidth += spacing * (images.length - 1);
    final canvasWidth = totalWidth + rightOffset;
    final combinedImage = img.Image(canvasWidth, maxHeight);

    int currentX = rightOffset;
    for (final image in images) {
      final y = (maxHeight - image.height) ~/ 2;
      img.copyInto(combinedImage, image, dstX: currentX, dstY: y);
      currentX += image.width + spacing;
    }
    return combinedImage;
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

  Future<img.Image> loadAndResizeImage(String path, int width) async {
    final data = await rootBundle.load(path);
    final bytes = data.buffer.asUint8List();
    final image = img.decodeImage(bytes);
    return img.copyResize(image!, width: width);
  }

  Future<void> _loadImages() async {
    try {
      headPop = await loadAndResizeImage('assets/images/JUMBO.png', 500);
      thank = await loadAndResizeImage('assets/images/thk1.png', 500);
      headENG = await loadAndResizeImage('assets/images/headENG.png', 500);
      game2 = await loadAndResizeImage('assets/images/2Game.png', 120);
      game5 = await loadAndResizeImage('assets/images/5Game.png', 120);
      game10 = await loadAndResizeImage('assets/images/10Game.png', 120);
      game15 = await loadAndResizeImage('assets/images/15Game.png', 120);
      game20 = await loadAndResizeImage('assets/images/20Game.png', 120);
      game50 = await loadAndResizeImage('assets/images/50Game.png', 120);
      fStar = await loadAndResizeImage('assets/images/fstar.png', 80);
      line1 = await loadAndResizeImage('assets/images/line1.png', 550);
      line2 = await loadAndResizeImage('assets/images/line2.png', 550);
      nonRefun = await loadAndResizeImage('assets/images/non_refun.png', 550);
      
    } catch (e) {
      print('Error loading images: $e');
    }
  }

  Future<img.Image> generateQRCodeWithQrFlutter(String data, double size) async {
    final qrValidationResult = QrValidator.validate(
      data: data,
      version: QrVersions.auto,
      errorCorrectionLevel: QrErrorCorrectLevel.M,
    );

    if (qrValidationResult.status == QrValidationStatus.valid) {
      final painter = QrPainter(
        data: data,
        version: QrVersions.min,
        gapless: false,
      );

      final picRecorder = ui.PictureRecorder();
      final canvas = Canvas(picRecorder);
      
      painter.paint(canvas, Size(size, size));
      final pic = picRecorder.endRecording();
      final uiImage = await pic.toImage(size.toInt(), size.toInt());
      final byteData = await uiImage.toByteData(format: ui.ImageByteFormat.png);
      final uint8list = byteData!.buffer.asUint8List();

      return img.decodeImage(uint8list)!;
    }

    throw Exception('Invalid QR Code data');
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
          SizedBox(
            width: width * .55,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: height * .05),
                _buildContainerRow(width, height, 'Net', widget.price.toInt().toString(), AppColors.pinkcm, 150),
                _buildContainerRow(width, height, 'Net Total', widget.price.toStringAsFixed(2), AppColors.pinkcm, 20),
                _buildContainerRow(width, height, 'Total', widget.price.toStringAsFixed(2), AppColors.pinkcm, 110),
                _buildContainerRow(width, height, 'vat', vat.toStringAsFixed(2), AppColors.pinkcm, 160),
                _buildContainerRow(width, height, 'Change', change.toStringAsFixed(2), 
                  (_controller.text.isNotEmpty && int.parse(_controller.text) < widget.price) ? Colors.red : _controller.text == widget.price.toString() ? Colors.green : Colors.orange, 65),
              ],
            ),
          ),
          Container( //KeyTap
            width: width * .45,
            padding: EdgeInsets.only(left: width * .05, right: width * .04),
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
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(width: width * .05),
          _receive(width, height),
          const SizedBox(width: 20),
          _buildButton(130, 'cancel', Colors.red, () => Navigator.of(context).pop(), 0),
          const SizedBox(width: 10),
          _buildButton(180, 'confirm', Colors.green, _controller.text.isNotEmpty ? () {
            Dbconnect().getShoppopcorn().then((onValue) {
              String paddedRunno = onValue![0].runno!.padLeft(10, '0');
              String saleno = '${onValue[0].shopchar}$paddedRunno';

              printReceiptPopcorn(context, 1, headPop, line1, thank, saleno, onValue[0].taxid!, [], 350);
            });

            /* Dbconnect().salenoGame().then((value) async {
              final imageMap = {3000: game50!, 1500: game20!, 1350: game15!, 1000: game10!, 600:  game5!, 300:  game2!};

              for (int row = 0; row < _insertDataGames.length; row++) {
                final game = _insertDataGames[row];
                final int quantity = game['quantity'];

                for (int col = 0; col < quantity; col++) {
                  final int price = (game['priceunit'] as double).toInt();
                  final select = imageMap[price];

                  final qrImage = await generateQRCodeWithQrFlutter(value![0].saleno!, 180);
                  final combined = combineImagesWithOffset([fStar!, qrImage, select!], 40);
                  await printReceiptQRGameNew(context, headENG, nonRefun, line1, thank, fStar, game, 100, value[0].saleno!, value[0].taxid!, combined, line2);
                  await Future.delayed(const Duration(milliseconds: 400));
                }
              }
            }); */
          } : null, 1)
        ],
      ),
    );
  }

  Widget _buildButton(double width, String title, Color color, VoidCallback? onPressed, int chk) {
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

  /* Widget _buildContainer(double width, String title, String total, Color colors) {
    return SizedBox(
      width: width * .15,
      height: width * .1,
      child: Column(
        children: [
          Text(title, style: TextStyle(fontFamily: AppFonts.traJanProBold, fontSize: width * .023, color: AppColors.text)), //30
          Text(total, style: TextStyle(fontFamily: AppFonts.traJanProBold, fontSize: width * .023, color: colors)),
          Divider(indent: 10, endIndent: 10, color: AppColors.black)
        ],
      ),
    );
  } */

  Widget _buildContainerRow(double width, double height, String title, String value, Color colorValue, double range) {
    return Container(
      width: width * .37,
      height: height * .12,
      margin: EdgeInsets.only(left: width * .05),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$title :',
            style: TextStyle(fontFamily: AppFonts.traJanProBold, fontSize: width * .025, color: AppColors.blueReceive)),
          SizedBox(width: range),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(' $value',
                style: TextStyle(fontFamily: AppFonts.traJanProBold, fontSize: width * .025, color: colorValue)),
              const SizedBox(height: 2),
              Container(
                width: width * .15,
                height: 1,
                color: AppColors.black,
              ),
            ],
          ),
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
        keyboardType: TextInputType.none,
        style: TextStyle(fontFamily: AppFonts.traJanProBold, fontSize: width * .04, color: (_controller.text.isEmpty ? .0 : double.parse(_controller.text)) >= widget.price ? Colors.green : Colors.red[400]),
        decoration: InputDecoration(
          labelText: 'Receive',
          labelStyle: TextStyle(fontFamily: AppFonts.traJanProBold, fontSize: width * .03, color: AppColors.text),
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