import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:payment_jumbo_machine/apis/DbConnect.dart';
import 'package:payment_jumbo_machine/model/mdDetail.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';
import '../apis/data.dart';
import '../fonts/appColor.dart';
import '../fonts/appFonts.dart';
import '../model/mdPopcornTMP.dart';
import 'paymentPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late SimpleFontelicoProgressDialog _dialog;
  late FocusNode _focusNode;
  final TextEditingController _controller = TextEditingController();
  List<GetPopcornTMP> _listTmp = [];
  List<GetPopcornTMP>? _filterTmp;
  List<Details> _details = [];

  Timer? _autoRefreshTimer;
  bool loadData = false;

  @override
  void initState() {
    super.initState();

    _startAutoRefresh();
    _dBListTMP();

    _focusNode = FocusNode();
    _dialog = SimpleFontelicoProgressDialog(context: context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    super.dispose();

    _focusNode.dispose();
    _autoRefreshTimer?.cancel();
  }

  void _startAutoRefresh() {
    _autoRefreshTimer = Timer.periodic(const Duration(seconds: 30), (timer) async {
      await _dBListTMP();
      print('Refresh');
    });
  }

  Future<void> _dBListTMP() async {
    final popcornList = await Dbconnect().getListPopcornTMP();
    final gameList = await Dbconnect().getListGameTMP();

    _listTmp = [...popcornList ?? [], ...gameList ?? []];
    setState(() {
      if (_filterTmp != null) {
      final keyword = _controller.text.toLowerCase();
        _filterTmp = _listTmp.where((item) => (item.saleno ?? '').toLowerCase().contains(keyword)).toList();
      }
      loadData = true;
    });
  }

  void _searchSaleno(String searchDocNo, {GetPopcornTMP? data}) async {
    if (searchDocNo.isNotEmpty) {
      _filterTmp = _listTmp.where((item) => item.saleno!.toLowerCase().contains(searchDocNo.toLowerCase())).toList();
    } else {
      _filterTmp!.clear();
      _details.clear();
    }
    if(_filterTmp!.isNotEmpty && searchDocNo.length == 12) {
      _details.addAll(_filterTmp![0].details!);
    }
    setState(() {});
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

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.pinkcm,
        toolbarHeight: height * .13,
        title: Padding(
          padding: EdgeInsets.only(left: width * .02),
          child: Text("Jumbo machine payment", 
            style: TextStyle(fontFamily: AppFonts.traJanProBold, fontSize: width * .025, color: AppColors.white)
          ),
        ),
      ),
      body: loadData ? SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: height * .03),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _scanQRCode(width, height),
                    const SizedBox(width: 40),
                    Row(
                      children: [
                        Text('TOTAL :  ', style: TextStyle(fontSize: width * .03, fontFamily: AppFonts.traJanProBold, color: AppColors.blueReceive)),
                        Text(_details.isNotEmpty ? double.parse(_filterTmp![0].total!).toStringAsFixed(2) : '0.00', style: TextStyle(fontSize: width * .03, fontFamily: AppFonts.traJanProBold, color: AppColors.black))
                      ],
                    )
                  ],
                ),
                _payment(context, width),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _headerDetaile(width, width * .075, height * .09, 'No'), //100 70
                _headerDetaile(width, width * .19, height * .09, 'code'), //250
                _headerDetaile(width, width * .38, height * .09, 'product name'), //500
                _headerDetaile(width, width * .075, height * .09, 'qty'), //100
                _headerDetaile(width, width * .11, height * .09, 'price'), //150
                _headerDetaile(width, width * .125, height * .09, 'total'), //150
              ],
            ),
            if (_details.isNotEmpty) ...List.generate(
              _details.length, (index) {
                final data = _details[index];
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _bodyDetaile(width, width * .075, height * .06, data.items!, int.parse(data.items!)), //100
                    _bodyDetaile(width, width * .19, height * .06, data.salecode!, int.parse(data.items!)), //250
                    _bodyDetaile(width, width * .38, height * .06, data.salename!, int.parse(data.items!)), //500
                    _bodyDetaile(width, width * .075, height * .06, double.parse(data.quantity!).toInt().toString(), int.parse(data.items!)), //100
                    _bodyDetaile(width, width * .11, height * .06, double.parse(data.priceunit!).toInt().toString(), int.parse(data.items!)), //150
                    _bodyDetaile(width, width * .125, height * .06, double.parse(data.total!).toInt().toString(), int.parse(data.items!)), //150
                  ],
                );
              },
            ) else Container(
              width: width,
              height: height * .53,
              margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.pinkcm, width: 2),
              ),
              child: Center(
                child: Text('No data found', style: TextStyle(fontSize: width * .02, fontFamily: AppFonts.traJanProBold, color: AppColors.pinkcm))
              )
            )
          ],
        ),
      ) : Center(
        child: LoadingAnimationWidget.threeArchedCircle(
          color: AppColors.golden,
          size: 100,
        ),
      ),
    );
  }

  Widget _payment(BuildContext context, double width) {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          side: const BorderSide(
            color: Color.fromARGB(255, 60, 114, 57),
            width: 5,
          ),
          backgroundColor: const Color.fromARGB(255, 60, 114, 57),
          padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 25),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 5
        ),
        onPressed: _details.isNotEmpty ? () async {
          _showLoadingDialog();
          await Future.delayed(const Duration(seconds: 2));
          await Navigator.push(context,
            MaterialPageRoute(builder: (context) => PaymentPage(onSearchSaleno: _searchSaleno, controller: _controller, data: _filterTmp![0], focusNode: _focusNode)),
          );
          _dialog.hide();
        } : null,
        child: Text('Pay', style: TextStyle(fontSize: width * .02, fontFamily: AppFonts.traJanProBold, color: _details.isNotEmpty ? Colors.white : Colors.black)),
      ),
    );
  }

  Widget _headerDetaile(double fSize, double width, double height, String title) {
    return Container(
      width: width,
      height: height,
      color: AppColors.pinkcm,
      alignment: Alignment.center,
      margin: const EdgeInsets.only(left: 3, bottom: 3),
      child: Text(title, style: TextStyle(fontSize: fSize * .021, fontFamily: AppFonts.traJanPro, color: AppColors.white, fontWeight: FontWeight.bold)), //25
    );
  }

  Widget _bodyDetaile(double fSize, double width, double height, String data, int qty) {
    return Container(
      width: width,
      height: height,
      color: qty % 2 == 0 ? AppColors.pinkcm : AppColors.pinkcm.withOpacity(0.5),
      alignment: Alignment.center,
      margin: const EdgeInsets.only(left: 3, bottom: 1),
      child: Text(data, style: TextStyle(fontSize: fSize * .017, fontFamily: AppFonts.traJanPro, color: AppColors.white, fontWeight: FontWeight.bold)),
    );
  }

  Widget _scanQRCode(double width, double height) {
    return Container(
      width: width * 0.35,
      height: height * 0.15,
      margin: const EdgeInsets.only(left: 20, top: 10),
      child: TextField(
        // readOnly: true,
        showCursor: false,
        focusNode: _focusNode,
        controller: _controller,
        keyboardType: TextInputType.none, //TextInputType.none
        style: TextStyle(fontFamily: AppFonts.traJanProBold, fontSize: width * .025, color: AppColors.black),
        onChanged: (value) { //search
          _searchSaleno(value);
        },
        inputFormatters: <TextInputFormatter>[
          LengthLimitingTextInputFormatter(12),
        ],
        decoration: InputDecoration(
          prefixIcon: Padding(
          padding: EdgeInsets.only(left: width * .01, right: width * .01),
            child: Icon(Icons.qr_code_scanner_rounded, size: width * .045, color: AppColors.black),
          ),
          suffixIcon: _controller.text.isEmpty ? null : IconButton(
            onPressed: () {
              _controller.clear();
              _searchSaleno('');
              _focusNode.requestFocus();
            },
            icon: Icon(Icons.close_rounded, color: AppColors.redBg, size: width * .035),
          ),
          labelText: 'Scan QR Code',
          labelStyle: TextStyle(fontFamily: AppFonts.traJanProBold, fontSize: width * .025, color: AppColors.blueReceive),
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