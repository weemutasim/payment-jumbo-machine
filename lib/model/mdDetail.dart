class ListDetails {
  String? items;
  String? saleno;
  String? salecode;
  String? quantity;
  String? unit;
  String? priceunit;
  String? total;
  String? vat;
  String? discount;
  String? updateDate;
  String? salename;

  ListDetails(
      {this.items,
      this.saleno,
      this.salecode,
      this.quantity,
      this.unit,
      this.priceunit,
      this.total,
      this.vat,
      this.discount,
      this.updateDate,
      this.salename});

  ListDetails.fromJson(Map<String, dynamic> json) {
    items = json['items'];
    saleno = json['saleno'];
    salecode = json['salecode'];
    quantity = json['quantity'];
    unit = json['unit'];
    priceunit = json['priceunit'];
    total = json['total'];
    vat = json['vat'];
    discount = json['discount'];
    updateDate = json['update_date'];
    salename = json['salename'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['items'] = items;
    data['saleno'] = saleno;
    data['salecode'] = salecode;
    data['quantity'] = quantity;
    data['unit'] = unit;
    data['priceunit'] = priceunit;
    data['total'] = total;
    data['vat'] = vat;
    data['discount'] = discount;
    data['update_date'] = updateDate;
    data['salename'] = salename;
    return data;
  }
  static List<ListDetails>? fromJsonList(List list) => list.map((item) => ListDetails.fromJson(item)).toList();
}