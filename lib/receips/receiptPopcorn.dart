// ignore_for_file: file_names
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/mdDetail.dart';
import '../utils/formatDateTime.dart';


Future<void> printReceiptPopcorn(BuildContext context, int num, img.Image? head, img.Image? underLine, img.Image? thank, String saleno, String taxid, List<ListDetails> popcorns, double total, double change, String ipPrinter) async {
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
  printer.text(formatDateReceip(DateTime.now()), styles: const PosStyles(align: PosAlign.center, height: PosTextSize.size2, width: PosTextSize.size2));
  printer.text('TIME : ${DateFormat('HH:mm').format(DateTime.now())}', styles: const PosStyles(align: PosAlign.center));
  printer.text('Carnival Magic Co.,Ltd. (0000)', styles: const PosStyles(align: PosAlign.center));
  printer.text('TAX ID: 0835557013779    *VAT INCLUDED*', styles: const PosStyles(align: PosAlign.center));
  printer.text('TEL : (076)385-555', styles: const PosStyles(align: PosAlign.center));
  printer.text('TAX INVOICE (ABB)', styles: const PosStyles(align: PosAlign.center));
  printer.text('NO. $saleno');
  printer.text('Queue No. : $num', styles: const PosStyles(width: PosTextSize.size2, bold: true));  //เพิ่ม queue J1
  printer.image(underLine!);
  printer.text('------------------------------------------------');
  printer.row(
    [
      buildPosCol('Qty', 1, PosAlign.left),
      buildPosCol('Item', 7, PosAlign.left),
      buildPosCol('Price', 2, PosAlign.left),
      buildPosCol('Total', 2, PosAlign.left),
    ]
  );
  List.generate(popcorns.length, (index) {
    final item = popcorns[index];
    printer.row( //เกิน 12 error
      [
        buildPosCol('${double.parse(item.quantity.toString()).toInt()}', 1, PosAlign.left), //quantity
        buildPosCol('${item.salename}', 7, PosAlign.left),
        buildPosCol('${double.parse(item.priceunit.toString()).toInt()}', 2, PosAlign.left),
        buildPosCol('${double.parse(item.total.toString()).toInt()}', 2, PosAlign.left),
      ]
    );
  });
  // printer.text('------------------------------------------------');
  // printer.text('  SUBTOTAL     ${total.toStringAsFixed(2)}');
  printer.text('------------------------------------------------');
  printer.text('  TOTAL        ${total.toStringAsFixed(2)}', styles: const PosStyles(width: PosTextSize.size2, bold: true));
  printer.text('------------------------------------------------');
  printer.text('  CREDIT       ${total.toStringAsFixed(2)}', styles: const PosStyles(width: PosTextSize.size2, bold: true));
  printer.text('------------------------------------------------');
  // printer.text('  CHANGE       ${change.toStringAsFixed(2)}', styles: const PosStyles(width: PosTextSize.size2, bold: true));
  // printer.text('------------------------------------------------');
  printer.image(thank!);
  printer.qrcode(saleno);
  printer.text('');
  printer.text('POS ID : $taxid', styles: const PosStyles(align: PosAlign.center));

  printer.feed(1);
  printer.cut();
  printer.disconnect();
}