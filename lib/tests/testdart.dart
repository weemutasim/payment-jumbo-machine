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

         /* Future<void> _loadImages() async {
    try {
      ByteData dataLogo = await rootBundle.load('assets/images/JUMBO.png');
      Uint8List uint8ListLogo = dataLogo.buffer.asUint8List();
      img.Image? decodedHeadLogo = img.decodeImage(uint8ListLogo);
      headPop = img.copyResize(decodedHeadLogo!, width: 500);

      ByteData dataThank = await rootBundle.load('assets/images/thk1.png');
      Uint8List uint8ListsThank = dataThank.buffer.asUint8List();
      img.Image? decodedThank = img.decodeImage(uint8ListsThank);
      thank = img.copyResize(decodedThank!, width: 500);

      ByteData dataLogoGame = await rootBundle.load('assets/images/logoJR.png');
      Uint8List uint8ListsThankGame = dataLogoGame.buffer.asUint8List();
      img.Image? decodedThankGame = img.decodeImage(uint8ListsThankGame);
      lgogGame = img.copyResize(decodedThankGame!, width: 500);

      ByteData dataLogoHeadEng = await rootBundle.load('assets/images/headENG.png');
      Uint8List uint8ListsHeadEng = dataLogoHeadEng.buffer.asUint8List();
      img.Image? decodedHeadEng = img.decodeImage(uint8ListsHeadEng);
      headENG = img.copyResize(decodedHeadEng!, width: 500);

      ByteData dataqty2Game = await rootBundle.load('assets/images/2Game.png');
      Uint8List uint8Listsqty2Game = dataqty2Game.buffer.asUint8List();
      img.Image? decodedqty2Game = img.decodeImage(uint8Listsqty2Game);
      game2 = img.copyResize(decodedqty2Game!, width: 120);

      ByteData dataqty5Game = await rootBundle.load('assets/images/5Game.png');
      Uint8List uint8Listsqty5Game = dataqty5Game.buffer.asUint8List();
      img.Image? decodedqty5Game = img.decodeImage(uint8Listsqty5Game);
      game5 = img.copyResize(decodedqty5Game!, width: 120);

      ByteData dataqty10Game = await rootBundle.load('assets/images/10Game.png');
      Uint8List uint8Listsqty10Game = dataqty10Game.buffer.asUint8List();
      img.Image? decodedqty10Game = img.decodeImage(uint8Listsqty10Game);
      game10 = img.copyResize(decodedqty10Game!, width: 120);

      ByteData dataqty15Game = await rootBundle.load('assets/images/15Game.png');
      Uint8List uint8Listsqty15Game = dataqty15Game.buffer.asUint8List();
      img.Image? decodedqty15Game = img.decodeImage(uint8Listsqty15Game);
      game15 = img.copyResize(decodedqty15Game!, width: 120);

      ByteData dataqty20Game = await rootBundle.load('assets/images/20Game.png');
      Uint8List uint8Listsqty20Game = dataqty20Game.buffer.asUint8List();
      img.Image? decodedqty20Game = img.decodeImage(uint8Listsqty20Game);
      game20 = img.copyResize(decodedqty20Game!, width: 120);

      ByteData dataqty50Game = await rootBundle.load('assets/images/50Game.png');
      Uint8List uint8Listsqty50Game = dataqty50Game.buffer.asUint8List();
      img.Image? decodedqty50Game = img.decodeImage(uint8Listsqty50Game);
      game50 = img.copyResize(decodedqty50Game!, width: 120);
      
      ByteData datafstar = await rootBundle.load('assets/images/fstar.png');
      Uint8List uint8Listsfstar = datafstar.buffer.asUint8List();
      img.Image? decodedfstar = img.decodeImage(uint8Listsfstar);
      fStar = img.copyResize(decodedfstar!, width: 80); //df 500

      ByteData dataline1 = await rootBundle.load('assets/images/line1.png');
      Uint8List uint8Listsline1 = dataline1.buffer.asUint8List();
      img.Image? decodedline1 = img.decodeImage(uint8Listsline1);
      line1 = img.copyResize(decodedline1!, width: 550);

      ByteData dataline2 = await rootBundle.load('assets/images/line2.png');
      Uint8List uint8Listsline2 = dataline2.buffer.asUint8List();
      img.Image? decodedline2 = img.decodeImage(uint8Listsline2);
      line2 = img.copyResize(decodedline2!, width: 550);
      
      ByteData datanonrefun = await rootBundle.load('assets/images/non_refun.png');
      Uint8List uint8Listsnonrefun = datanonrefun.buffer.asUint8List();
      img.Image? decodednonrefun = img.decodeImage(uint8Listsnonrefun);
      nonRefun = img.copyResize(decodednonrefun!, width: 550);

    } catch (e) {
      print(e); 
    }
  } */

 /* SizedBox( //GridView
  height: height * .61,
  child: _buildContainer(width),
) */

 /* _showLoadingDialog();
      await Future.delayed(const Duration(seconds: 2));
      await Navigator.push(context,
        MaterialPageRoute(builder: (context) => PaymentPage(onSearchSaleno: _searchSaleno, controller: _controller, data: data ?? _filterTmp![0])),
      );
      _dialog.hide(); */
    /* Widget _buildContainer(double width) {
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
  } */