import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';
import '../apis/data.dart';
import '../fonts/appColor.dart';
import '../fonts/appFonts.dart';
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

  @override
  void initState() {
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

    super.dispose();
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
      body: Column(
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
      itemCount: prices.length,
      itemBuilder: (context, index) {
        int price = prices[index];
        return GestureDetector(
          onTap: () async {
            _showLoadingDialog();
            await Future.delayed(const Duration(seconds: 2));
            await Navigator.push(context,
              MaterialPageRoute(builder: (context) => PaymentPage(price: price)),
            );
            _dialog.hide();
          },
          child: Card(
            color: Colors.pink[300],
            elevation: 5,
            child: ListTile(
              title: Text('Price', style: TextStyle(fontSize: 25, fontFamily: AppFonts.pgVim, fontWeight: FontWeight.bold)),
              subtitle: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text('$price', style: TextStyle(fontSize: 25, fontFamily: AppFonts.pgVim)),
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
        // showCursor: true,
        focusNode: _focusNode,
        controller: _controller,
        keyboardType: TextInputType.none, //TextInputType.none
        style: TextStyle(fontFamily: AppFonts.traJanProBold, fontSize: width * .025, color: AppColors.black),
        onChanged: (value) { //search
          setState(() {});
        },
        decoration: InputDecoration(
          prefixIcon: Padding(
          padding: EdgeInsets.only(left: width * .01, right: width * .01),
            child: Icon(Icons.qr_code_scanner_rounded, size: width * .045, color: AppColors.black),
          ),
          suffixIcon: _controller.text.isEmpty ? null : IconButton(
            onPressed: () {
              setState(() {
                _controller.clear();
              });
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