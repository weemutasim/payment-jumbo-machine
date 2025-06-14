import 'package:flutter/material.dart';
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
  final TextEditingController _controller = TextEditingController();
  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
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

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.pinkcm,
        title: Text("Jumbo machine payment", style: TextStyle(fontFamily: AppFonts.traJanProBold, fontSize: 25, color: AppColors.white)),
      ),
      body: Column(
        children: [
          SizedBox(height: height * .03),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: scanQRCode(width, height),
            ),
          ),
          // Divider(indent: 20, endIndent: 20, color: AppColors.black),
          SizedBox(
            height: height * .61,
            child: buildContainer(),
          )
        ],
      ),
    );
  }

  Widget buildContainer() {
    return GridView.builder(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 0),
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
          onTap: () {
            Navigator.push(context,
              MaterialPageRoute(builder: (context) => PaymentPage(price: price)),
            );
          },
          child: Card(
            color: Colors.pink[300],
            elevation: 5,
            child: Center(child: Text('$price', style: const TextStyle(fontSize: 25))),
          ),
        );
      },
    );
  }

  Widget scanQRCode(double width, double height) {
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
          print(value);
        },
        decoration: InputDecoration(
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
            child: Icon(Icons.qr_code_scanner_rounded, size: width * .045, color: Colors.black),
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