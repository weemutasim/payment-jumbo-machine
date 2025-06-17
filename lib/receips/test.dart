// ignore_for_file: file_names
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/material.dart';
import '../utils/formatDateTime.dart';

const ipPrinter = "192.168.4.248";

Future<void> printReceiptTest(BuildContext context, img.Image? head) async {
  const PaperSize paper = PaperSize.mm80;
  final profile = await CapabilityProfile.load();
  final printer = NetworkPrinter(paper, profile);
  final PosPrintResult res = await printer.connect(ipPrinter, port: 9100);

  if (res != PosPrintResult.success) {
    print('Print result: ${res.msg}');
    return;
  }

  printer.image(head!);
  printer.text('');
  printer.text(formatDateReceip(DateTime.now()), styles: const PosStyles(align: PosAlign.center, height: PosTextSize.size2, width: PosTextSize.size2));
  printer.text('');
  printer.text('Test', styles: const PosStyles(align: PosAlign.center, width: PosTextSize.size2, height: PosTextSize.size2));
  printer.text('');
  printer.text('------------------------------------------------');
  printer.text('A B C D E F G H I J K L M N O P Q R S T U V W X Y Z', styles: const PosStyles(align: PosAlign.center));
  printer.text('a b c d e f g h i j k l m n o p q r s t u v w x y z', styles: const PosStyles(align: PosAlign.center));
  printer.text('1 2 3 4 5 6 7 8 9 / * - +', styles: const PosStyles(align: PosAlign.center));
  printer.text('------------------------------------------------');
  printer.text('');
  printer.qrcode('test_print', size: QRSize.Size5);

  printer.feed(1);
  printer.cut();
  printer.disconnect();
}