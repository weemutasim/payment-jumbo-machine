class Shoppopcorn {
  String? idshop;
  String? shopname;
  String? shopchar;
  String? runno;
  String? ipPrinter;
  String? groupid;
  String? queue;
  String? ipPrinter2;
  String? taxid;
  String? printertype1;
  String? printertype2;

  Shoppopcorn(
      {this.idshop,
      this.shopname,
      this.shopchar,
      this.runno,
      this.ipPrinter,
      this.groupid,
      this.queue,
      this.ipPrinter2,
      this.taxid,
      this.printertype1,
      this.printertype2});

  Shoppopcorn.fromJson(Map<String, dynamic> json) {
    idshop = json['idshop'];
    shopname = json['shopname'];
    shopchar = json['shopchar'];
    runno = json['runno'];
    ipPrinter = json['ip_printer'];
    groupid = json['groupid'];
    queue = json['queue'];
    ipPrinter2 = json['ip_printer2'];
    taxid = json['taxid'];
    printertype1 = json['printertype1'];
    printertype2 = json['printertype2'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idshop'] = idshop;
    data['shopname'] = shopname;
    data['shopchar'] = shopchar;
    data['runno'] = runno;
    data['ip_printer'] = ipPrinter;
    data['groupid'] = groupid;
    data['queue'] = queue;
    data['ip_printer2'] = ipPrinter2;
    data['taxid'] = taxid;
    data['printertype1'] = printertype1;
    data['printertype2'] = printertype2;
    return data;
  }

  static List<Shoppopcorn>? fromJsonList(List list) => list.map((item) => Shoppopcorn.fromJson(item)).toList();
}