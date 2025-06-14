class GetSalenoGame {
  String? saleno;
  String? shopcode;
  String? shopname;
  String? ipPrinter;
  String? taxid;
  String? printertype;

  GetSalenoGame(
      {this.saleno,
      this.shopcode,
      this.shopname,
      this.ipPrinter,
      this.taxid,
      this.printertype});

  GetSalenoGame.fromJson(Map<String, dynamic> json) {
    saleno = json['saleno'];
    shopcode = json['shopcode'];
    shopname = json['shopname'];
    ipPrinter = json['ip_printer'];
    taxid = json['taxid'];
    printertype = json['printertype'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['saleno'] = saleno;
    data['shopcode'] = shopcode;
    data['shopname'] = shopname;
    data['ip_printer'] = ipPrinter;
    data['taxid'] = taxid;
    data['printertype'] = printertype;
    return data;
  }
  static List<GetSalenoGame>? fromJsonList(List list) => list.map((item) => GetSalenoGame.fromJson(item)).toList();
}