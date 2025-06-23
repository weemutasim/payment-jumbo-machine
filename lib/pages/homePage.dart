import 'dart:async';
import 'package:flutter/material.dart';
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
  final TextEditingController _controller = TextEditingController();
  FocusNode _focusNode = FocusNode();
  List<GetPopcornTMP> _listTmp = [];
  List<GetPopcornTMP>? _filterTmp;

  Timer? _autoRefreshTimer;
  bool loadData = false;

  @override
  void initState() {
    _startAutoRefresh();
    _dBListTMP();

    _dialog = SimpleFontelicoProgressDialog(context: context);
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
    WidgetsFlutterBinding.ensureInitialized();
    WidgetsBinding.instance.addPostFrameCallback((focus) {
      FocusScope.of(context).requestFocus(_focusNode);
    });

    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _autoRefreshTimer?.cancel();

    super.dispose();
  }

  /* Future<void> _dBListTMP() async {
    await Dbconnect().getListPopcornTMP().then((onValue) async {
      _listTmp = onValue!;
      await Dbconnect().getListGameTMP().then((value) {
        _listTmp.addAll(value!);
        setState(() {
          loadData = true;
        });
      });
    });
  } */

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
      loadData = true;
    });
  }

  void _searchSaleno(String searchDocNo, {GetPopcornTMP? data}) async {
    if (searchDocNo.isNotEmpty) {
      _filterTmp = _listTmp.where((item) => item.saleno!.toLowerCase().contains(searchDocNo.toLowerCase())).toList();
    } else {
      _filterTmp = _listTmp;
    }
    if(_filterTmp!.isNotEmpty && searchDocNo.length == 12) {
      _showLoadingDialog();
      await Future.delayed(const Duration(seconds: 2));
      await Navigator.push(context,
        MaterialPageRoute(builder: (context) => PaymentPage(onSearchSaleno: _searchSaleno, controller: _controller, data: data ?? _filterTmp![0])),
      );
      _dialog.hide();
    }
    setState(() {});
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus) FocusScope.of(context).requestFocus(_focusNode);
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
          children: [
            SizedBox(height: height * .03),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: _scanQRCode(width, height),
              ),
            ),
            // const Divider(indent: 20, endIndent: 20, color: Colors.grey),
            SizedBox(
              height: height * .61,
              child: _buildContainer(width),
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

  Widget _buildContainer(double width) {
    return GridView.builder(
      padding: EdgeInsets.only(left: width * .015, right: width * .015, top: 0, bottom: 0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 3, // width/height ratio of items
      ),
      itemCount: (_filterTmp ?? _listTmp).length,
      itemBuilder: (context, index) {
        final data = (_filterTmp ?? _listTmp)[index];
        return GestureDetector(
          onTap: () {
            _searchSaleno(data.saleno!, data: data);
          },
          child: Card(
            color: Colors.pink[300],
            elevation: 5,
            child: ListTile(
              title: Text('Saleno', style: TextStyle(fontSize: 25, fontFamily: AppFonts.pgVim, fontWeight: FontWeight.bold)),
              subtitle: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text('${data.saleno}', style: TextStyle(fontSize: 25, fontFamily: AppFonts.pgVim, color: Colors.white)),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _scanQRCode(double width, double height) {
    return Container(
      width: width * 0.35,
      height: height * 0.15,
      margin: const EdgeInsets.all(20),
      child: TextField(
        // readOnly: true,
        showCursor: true,
        focusNode: _focusNode,
        controller: _controller,
        keyboardType: TextInputType.text, //TextInputType.none
        style: TextStyle(fontFamily: AppFonts.traJanProBold, fontSize: width * .025, color: AppColors.black),
        onChanged: (value) { //search
          _searchSaleno(value);
        },
        decoration: InputDecoration(
          prefixIcon: Padding(
          padding: EdgeInsets.only(left: width * .01, right: width * .01),
            child: Icon(Icons.qr_code_scanner_rounded, size: width * .045, color: AppColors.black),
          ),
          suffixIcon: _controller.text.isEmpty ? null : IconButton(
            onPressed: () {
              _controller.clear();
              _searchSaleno('');
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