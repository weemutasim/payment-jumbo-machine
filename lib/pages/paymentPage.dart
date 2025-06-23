import 'package:dio/dio.dart';
import 'package:image/image.dart' as img;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';
import '../apis/DbConnect.dart';
import '../fonts/appColor.dart';
import '../fonts/appFonts.dart';
import '../model/mdDetail.dart';
import '../model/mdPopcornTMP.dart';
import '../receips/receipQRGameNew.dart';
import '../receips/receiptPopcorn.dart';
import '../utils/formatDateTime.dart';
import '../utils/numberPad.dart';

class PaymentPage extends StatefulWidget {
  final void Function(String) onSearchSaleno;
  final TextEditingController controller;
  final GetPopcornTMP data;
  const PaymentPage({super.key, required this.onSearchSaleno, required this.controller, required this.data});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  late SimpleFontelicoProgressDialog _dialog;
  final NumberFormat numberFormat = NumberFormat('#,###', 'en_US');
  final TextEditingController _controllNumPad = TextEditingController();
  img.Image? headPop, thank, headENG, fStar, line1, line2, nonRefun, combinedImage, game2, game5, game10, game15, game20, game50, select;

  // double price = 1350.00;
  // double vat = 0.0;
  double change = 0;

  @override
  void initState() {
    _dialog = SimpleFontelicoProgressDialog(context: context);
    _loadImages();

    super.initState();
  }

  @override
  void dispose() {
    _controllNumPad.dispose();

    super.dispose();
  }

  img.Image _combineImagesWithOffset(List<img.Image> images, int spacing, {int rightOffset = 30}) {
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
      if(_controllNumPad.text.isNotEmpty) _controllNumPad.clear();
    } else if (key == 'del') {
      if (_controllNumPad.text.isNotEmpty) _controllNumPad.text = _controllNumPad.text.substring(0, _controllNumPad.text.length - 1);
    } else {
      if (_controllNumPad.text.isEmpty && key == '0') return;
      if (_controllNumPad.text.length < 6) _controllNumPad.text += key;
    }

    setState(() {
      double input = double.tryParse(_controllNumPad.text) ?? .0;
      // vat = widget.price * .07;
      change = input - double.parse(widget.data.total ?? '0');
    });
  }

  void _showLoadingDialog() {
    _dialog.show(
      message: 'Loading...',
      type: SimpleFontelicoProgressDialogType.custom, 
      hideText: true, 
      loadingIndicator: LoadingAnimationWidget.threeArchedCircle(color: AppColors.golden, size: 100), 
      backgroundColor: Colors.transparent
    );
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

  Future<img.Image> _generateQRCode(String data, double size) async {
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
        toolbarHeight: height * .13,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.white, size: 30),
          onPressed: () {
            _controllNumPad.clear();
            widget.controller.clear();
            widget.onSearchSaleno('');
            Navigator.of(context).pop();
          },
        ),
        title: Text("Pay", style: TextStyle(fontFamily: AppFonts.traJanProBold, fontSize: width * .025, color: AppColors.white)),
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
                _buildContainerRow(width, height, 'Net', widget.data.total.toString(), AppColors.pinkcm, 150),
                _buildContainerRow(width, height, 'Net Total', double.parse(widget.data.total!).toStringAsFixed(2), AppColors.pinkcm, 20),
                _buildContainerRow(width, height, 'Total', double.parse(widget.data.total!).toStringAsFixed(2), AppColors.pinkcm, 110),
                _buildContainerRow(width, height, 'vat', widget.data.vat.toString(), AppColors.pinkcm, 160),
                _buildChange(width, height)
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
                control: _controllNumPad.text,
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
          _buildButton(width * .1, 'Cancel', () {
            _controllNumPad.clear();
            widget.onSearchSaleno('');
            widget.controller.clear();
            Navigator.of(context).pop();
          }, height * .15, width), //130
          const SizedBox(width: 10),
          _buildButton(width * .145, 'Confirm', (_controllNumPad.text.isNotEmpty && int.parse(_controllNumPad.text) >= double.parse(widget.data.total ?? '0')) ? () async {
            _showLoadingDialog();
            String chk = widget.data.saleno!.substring(0, 4);
            final dataDetails = ListDetails.fromJsonList(widget.data.details?.map((e) => e.toJson()).toList() ?? []);

            if(chk == 'ptmp') {
              await Dbconnect().getShoppopcorn().then((onValue) async {
                String paddedRunno = onValue![0].runno!.padLeft(10, '0');
                String saleno = '${onValue[0].shopchar}$paddedRunno';

                //Popcorn
                 await Dbconnect().insertPopcorn(
                  api: 'http://172.2.100.14/application/query_pos_popcorn/fluttercon.php?mode=INSERT_DATA', //'http://172.2.100.14/application/query_pos_popcorn/fluttercon.php?mode=INSERT_DATA'
                  uid: widget.data.uid ?? '',
                  arrayData: dataDetails,
                  saleno: saleno, // เลขที่ใบเสร็จ
                  saledate: formatDate(DateTime.now()),
                  taxid: onValue[0].taxid!, 
                  guidecode: "", //ว่าง
                  qtygood: "0", //total detail
                  total: widget.data.total ?? '0', //total ยอดรวมหลังหักส่วนลดในรายการ
                  totRec: _controllNumPad.text, //กรณีเงินสดรับเงินมา
                  totChange: change.toString(), //กรณีเงินสดเงินทอน
                  totDiscount: "0", //ส่วนลดเป็ยบาท
                  vat: widget.data.vat ?? '0', //ภาษี total - discout
                  grandTotal: widget.data.grandTotal ?? '0', //ราคาเต็มลบภาษี total - discout - vat
                  idCard: "", //credit 4 ตัวท้าย
                  flag: "N", //กรณีเงินสดเป็น W ปกติเป็น N
                  shopcode: "1",
                  location: onValue[0].shopchar!, 
                  personId: "", //ว่าง
                  staffcode: "", //ว่าง
                  sysdate: formatDateTime(DateTime.now()),
                  cardtype: "100", //100 เงินสด 101 credit
                  accode: "100", //100 เงินสด 101 credit
                  saleuser: "",
                  totCreditcard: "", //ยอดเงินเครดิต
                  billtype: "", //ว่าง
                  queue: "",
                  entcode: "", //ว่าง
                  voucher: "", //ว่าง
                  coupon: "", //ว่าง
                  totCoupon: "", //ว่าง
                ).then((value) async {
                  await printReceiptPopcorn(context, 1, headPop, line1, thank, saleno, onValue[0].taxid!, dataDetails!, double.parse(widget.data.total ?? '0'), change);
                });
              });
            } else if(chk == 'gtmp') {
              await Dbconnect().salenoGame().then((onValue) async {
                await Dbconnect().insertGamescard(
                  api: 'http://172.2.100.14/application/query_pos_popcorn/fluttercon.php?mode=INSERT_DATA_GAME&location=J8', //'http://172.2.100.14/application/query_pos_popcorn/fluttercon.php?mode=INSERT_DATA_GAME&location=J8'
                  arrayData: dataDetails,
                  uid: widget.data.uid ?? '',
                  saleno: onValue![0].saleno!, 
                  saledate: formatDate(DateTime.now()), 
                  taxid: onValue[0].taxid!, 
                  guidecode: "", 
                  qtygood: "0", 
                  total: widget.data.total ?? '0', 
                  totRec: _controllNumPad.text, 
                  totChange: change.toString(), 
                  totDiscount: "0", 
                  vat: widget.data.vat ?? '0', 
                  grandTotal: widget.data.grandTotal ?? '0', 
                  idCard: "", 
                  flag: "N", 
                  shopcode: "1", 
                  location: onValue[0].shopcode!, 
                  personId: "", 
                  staffcode: "", 
                  sysdate: formatDateTime(DateTime.now()), 
                  cardtype: "100", 
                  accode: "100", 
                  saleuser: "", 
                  totCreditcard: "", 
                  billtype: "", 
                  entcode: "", 
                  voucher: "", 
                  precentDiscount: "", 
                  coupon: ""
                ).then((value) async {
                  final imageMap = {3000: game50!, 1500: game20!, 1350: game15!, 1000: game10!, 600:  game5!, 300:  game2!};

                  for (int row = 0; row < dataDetails!.length; row++) {
                    final game = dataDetails[row];
                    final int quantity = double.parse(game.quantity ?? '0').toInt();

                    for (int col = 0; col < quantity; col++) {
                      final int price = double.parse(game.priceunit ?? '0').toInt();
                      final select = imageMap[price];

                      final qrImage = await _generateQRCode(onValue[0].saleno!, 180);
                      final combined = _combineImagesWithOffset([fStar!, qrImage, select!], 40);
                      await printReceiptQRGameNew(context, headENG, nonRefun, line1, thank, fStar, game, 100, onValue[0].saleno!, onValue[0].taxid!, combined, line2);
                      await Future.delayed(const Duration(milliseconds: 400));
                    }
                  }
                });
              });
            } else {
              print('not chose popcorn or game');
            }

            _controllNumPad.clear();
            widget.controller.clear();
            widget.onSearchSaleno('');
            _dialog.hide();
            Navigator.of(context).pop(); 
          } : null, height * .15, width)
        ],
      ),
    );
  }

  Widget _buildChange(double width, double height) {
    return Container(
      width: width * .39,
      height: height * .12,
      margin: EdgeInsets.only(left: width * .025),
      padding: EdgeInsets.only(left: width * .025),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        // border: Border.all(color: Colors.orangeAccent),
        color: const ui.Color.fromARGB(50, 255, 153, 0)
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Change :',
            style: TextStyle(fontFamily: AppFonts.traJanProBold, fontSize: width * .025, color: AppColors.blueReceive)),
          const SizedBox(width: 65),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(' ${change.toStringAsFixed(2)}',
                style: TextStyle(fontFamily: AppFonts.traJanProBold, fontSize: width * .025,
                  color: (_controllNumPad.text.isNotEmpty && int.parse(_controllNumPad.text) < double.parse(widget.data.total ?? '0')) ? Colors.red : _controllNumPad.text == widget.data.total.toString() ? Colors.green : Colors.orange)),
              SizedBox(height: height * .005), //2
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

  Widget _buildButton(double width, String title, VoidCallback? onPressed, double height, double size) {
    Color getTextColor(String title, String text, int price) {
      if (title == 'Cancel') return AppColors.redBg;
      final value = double.tryParse(text);
      return ((value ?? 0) >= price) ? const Color.fromARGB(255, 60, 114, 57) : Colors.grey;
    }

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width,
        height: height, //115
        decoration: BoxDecoration(
          border: Border.all(color: getTextColor(title, _controllNumPad.text, double.parse(widget.data.total ?? '0').toInt()), width: 3),
          borderRadius: BorderRadius.circular(8),
          color: title == 'Cancel' ? AppColors.cancelColor : (int.tryParse(_controllNumPad.text) ?? 0) >= double.parse(widget.data.total ?? '0') ? AppColors.confirmColor : null
        ),
        child: Center(child: Text(title, style: TextStyle(fontFamily: AppFonts.traJanPro, fontSize: size * .02, fontWeight: FontWeight.bold, color: getTextColor(title, _controllNumPad.text, double.parse(widget.data.total ?? '0').toInt())))),
      ),
    );
  }

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
              SizedBox(height: height * .005), //2
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
          text: _controllNumPad.text.isNotEmpty ? numberFormat.format(double.tryParse(_controllNumPad.text) ?? 0) : '0',
        ),
        keyboardType: TextInputType.none,
        style: TextStyle(fontFamily: AppFonts.traJanProBold, fontSize: width * .04, color: (_controllNumPad.text.isEmpty ? .0 : double.parse(_controllNumPad.text)) >= double.parse(widget.data.total ?? '0') ? Colors.green : Colors.red[400]),
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