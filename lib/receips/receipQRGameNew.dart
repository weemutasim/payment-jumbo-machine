// ignore_for_file: file_names
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/mdDetail.dart';
import '../utils/formatDateTime.dart';

Future<void> printReceiptQRGameNew(BuildContext context, img.Image? head, img.Image? body, img.Image? underLine, img.Image? thank, img.Image? fstar, ListDetails games, double total, String saleno, String taxid, img.Image? combinedImage, img.Image? line2) async {
  const ipPrinter = "192.168.4.248";
  
  const PaperSize paper = PaperSize.mm80;
  final profile = await CapabilityProfile.load();
  final printer = NetworkPrinter(paper, profile);
  final PosPrintResult res = await printer.connect(ipPrinter, port: 9100);

  if (res != PosPrintResult.success) {
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
  (games.salecode == '0100002900011' || games.salecode == '0100002900023') ? printer.qrcode(saleno, size: QRSize.Size8) : printer.image(combinedImage!, align: PosAlign.center);
  printer.text('');
  printer.image(body!);
  printer.text('');
  printer.image(underLine!);
  printer.text('');
  printer.text(formatDateReceip(DateTime.now()), styles: const PosStyles(align: PosAlign.center, height: PosTextSize.size2, width: PosTextSize.size2));
  printer.text('TIME : ${DateFormat('HH:mm').format(DateTime.now())}', styles: const PosStyles(align: PosAlign.center));
  printer.text('Carnival Magic Co.,Ltd. (0000)', styles: const PosStyles(align: PosAlign.center));
  printer.text('Receipt/Tax Invoice (ABB)', styles: const PosStyles(align: PosAlign.center));
  printer.text('Tax ID : 0835557013779 (Vat Included)', styles: const PosStyles(align: PosAlign.center));
  printer.text('TEL : (076)385-555', styles: const PosStyles(align: PosAlign.center));
  printer.text('NO. $saleno');
  printer.text('JUMBOree 1', styles: const PosStyles(height: PosTextSize.size2, align: PosAlign.center));
  printer.text('');
  printer.image(underLine);
  printer.text('');
  printer.row(
    [
      buildPosCol('Qty', 1, PosAlign.left),
      buildPosCol('Item', 7, PosAlign.left),
      buildPosCol('Price', 2, PosAlign.left),
      buildPosCol('Total', 2, PosAlign.left),
    ]
  );
  printer.row( //เกิน 12 error
    [
      buildPosCol('1', 1, PosAlign.left), //${games['quantity']}
      buildPosCol('${games.salename}', 7, PosAlign.left),
      buildPosCol('${double.parse(games.priceunit ?? '0').toInt()}', 2, PosAlign.left),
      buildPosCol('${double.parse(games.priceunit ?? '0').toInt()}', 2, PosAlign.left), //${games['total'].toInt()}
    ]
  );
  printer.image(line2!);
  printer.text('  TOTAL        ${double.parse(games.priceunit ?? '0').toStringAsFixed(2)}', styles: const PosStyles(width: PosTextSize.size2, bold: true)); //${total.toStringAsFixed(2)}
  printer.image(line2);
  printer.text('  CREDIT       ${double.parse(games.priceunit ?? '0').toStringAsFixed(2)}', styles: const PosStyles(width: PosTextSize.size2, bold: true)); //${total.toStringAsFixed(2)}
  printer.text('');
  printer.image(underLine);
  printer.text('');
  printer.image(thank!);
  printer.text('');
  printer.text('POS ID : $taxid', styles: const PosStyles(align: PosAlign.center));

  printer.feed(1);
  printer.cut();
  printer.disconnect();
}