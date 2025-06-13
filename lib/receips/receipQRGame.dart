import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:image/image.dart';
import '../utils/formatDateTime.dart';

const ipPrinter = "192.168.4.248";

Future<void> printReceiptQRGame(Image? head, Image? body, Image? bottom, Image? underLine, Image? thank, List<Map<String, dynamic>> dataGames, double total, String saleno, String taxid) async {
  const PaperSize paper = PaperSize.mm80;
  final profile = await CapabilityProfile.load();
  final printer = NetworkPrinter(paper, profile);
  final PosPrintResult res = await printer.connect(ipPrinter, port: 9100);
  if (res != PosPrintResult.success) {
    print("ไม่สามารถเชื่อมต่อเครื่องพิมพ์");
    print('Print result: ${res.msg}');
    return;
  }
  PosColumn buildPosCol(String value, int width, PosAlign align) {
    return PosColumn(
      text: value,
      width: width,
      styles: PosStyles(align: align),
    );
  }
  
  printer.image(head!);
  printer.qrcode(saleno, size: QRSize.Size8);
  printer.text('');
  printer.image(body!);
  printer.text('');
  printer.text(formatDateReceip(DateTime.now()), styles: const PosStyles(align: PosAlign.center, height: PosTextSize.size2, width: PosTextSize.size2));
  printer.text('Carnival Magic Co.,Ltd. (0000)', styles: const PosStyles(align: PosAlign.center));
  printer.text('Receipt/Tax Invoice (ABB)', styles: const PosStyles(align: PosAlign.center));
  printer.text('Tax ID : 0835557013779 (Vat Included)', styles: const PosStyles(align: PosAlign.center));
  printer.text('TEL : (076)385-555', styles: const PosStyles(align: PosAlign.center));
  printer.text('NO. $saleno');
  printer.text('JUMBOree 1', styles: const PosStyles(height: PosTextSize.size2, align: PosAlign.center));
  printer.text('------------------------------------------------');
  printer.row(
    [
      buildPosCol('Qty', 1, PosAlign.left),
      buildPosCol('Item', 7, PosAlign.left),
      buildPosCol('Price', 2, PosAlign.left),
      buildPosCol('Total', 2, PosAlign.left),
    ]
  );
  List.generate(dataGames.length, (index) {
    final item = dataGames[index];
    printer.row(
      [
        buildPosCol('${item['quantity']}', 1, PosAlign.left),
        buildPosCol('${item['salename']}', 7, PosAlign.left),
        buildPosCol('${item['priceunit'].toInt()}', 2, PosAlign.left),
        buildPosCol('${item['total'].toInt()}', 2, PosAlign.left),
      ]
    );
  });
  printer.text('------------------------------------------------');
  printer.text('  TOTAL        ${total.toStringAsFixed(2)}', styles: const PosStyles(width: PosTextSize.size2, bold: true));
  printer.text('------------------------------------------------');
  printer.text('  CREDIT       ${total.toStringAsFixed(2)}', styles: const PosStyles(width: PosTextSize.size2, bold: true));
  printer.text('------------------------------------------------');
  printer.image(thank!);
  printer.image(bottom!);
  printer.text('');
  printer.text('POS ID : $taxid', styles: const PosStyles(align: PosAlign.center));

  printer.feed(1);
  printer.cut();
  printer.disconnect();
}