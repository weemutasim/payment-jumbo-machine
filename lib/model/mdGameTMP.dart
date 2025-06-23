class GetGameTMP {
  String? saleno;
  String? saledate;
  String? taxid;
  String? guidecode;
  String? qtygood;
  String? total;
  String? totRec;
  String? totChange;
  String? totDiscount;
  String? vat;
  String? grandTotal;
  String? idCard;
  String? flag;
  String? location;
  String? personId;
  String? staffcode;
  String? sysdate;
  String? cardtype;
  String? accode;
  String? saleuser;
  String? totCreditcard;
  String? billtype;
  String? entcode;
  String? voucher;
  String? percentDiscount;
  String? coupon;
  String? uid;
  List<Details>? details;

  GetGameTMP(
      {this.saleno,
      this.saledate,
      this.taxid,
      this.guidecode,
      this.qtygood,
      this.total,
      this.totRec,
      this.totChange,
      this.totDiscount,
      this.vat,
      this.grandTotal,
      this.idCard,
      this.flag,
      this.location,
      this.personId,
      this.staffcode,
      this.sysdate,
      this.cardtype,
      this.accode,
      this.saleuser,
      this.totCreditcard,
      this.billtype,
      this.entcode,
      this.voucher,
      this.percentDiscount,
      this.coupon,
      this.uid,
      this.details});

  GetGameTMP.fromJson(Map<String, dynamic> json) {
    saleno = json['saleno'];
    saledate = json['saledate'];
    taxid = json['taxid'];
    guidecode = json['guidecode'];
    qtygood = json['qtygood'];
    total = json['total'];
    totRec = json['tot_rec'];
    totChange = json['tot_change'];
    totDiscount = json['tot_discount'];
    vat = json['vat'];
    grandTotal = json['grand_total'];
    idCard = json['id_card'];
    flag = json['flag'];
    location = json['location'];
    personId = json['person_id'];
    staffcode = json['staffcode'];
    sysdate = json['sysdate'];
    cardtype = json['cardtype'];
    accode = json['accode'];
    saleuser = json['saleuser'];
    totCreditcard = json['tot_creditcard'];
    billtype = json['billtype'];
    entcode = json['entcode'];
    voucher = json['voucher'];
    percentDiscount = json['percent_discount'];
    coupon = json['coupon'];
    uid = json['uid'];
    if (json['details'] != null) {
      details = <Details>[];
      json['details'].forEach((v) {
        details!.add(Details.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['saleno'] = saleno;
    data['saledate'] = saledate;
    data['taxid'] = taxid;
    data['guidecode'] = guidecode;
    data['qtygood'] = qtygood;
    data['total'] = total;
    data['tot_rec'] = totRec;
    data['tot_change'] = totChange;
    data['tot_discount'] = totDiscount;
    data['vat'] = vat;
    data['grand_total'] = grandTotal;
    data['id_card'] = idCard;
    data['flag'] = flag;
    data['location'] = location;
    data['person_id'] = personId;
    data['staffcode'] = staffcode;
    data['sysdate'] = sysdate;
    data['cardtype'] = cardtype;
    data['accode'] = accode;
    data['saleuser'] = saleuser;
    data['tot_creditcard'] = totCreditcard;
    data['billtype'] = billtype;
    data['entcode'] = entcode;
    data['voucher'] = voucher;
    data['percent_discount'] = percentDiscount;
    data['coupon'] = coupon;
    data['uid'] = uid;
    if (details != null) {
      data['details'] = details!.map((v) => v.toJson()).toList();
    }
    return data;
  }
  static List<GetGameTMP>? fromJsonList(List list) => list.map((item) => GetGameTMP.fromJson(item)).toList();
}

class Details {
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

  Details(
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

  Details.fromJson(Map<String, dynamic> json) {
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
}