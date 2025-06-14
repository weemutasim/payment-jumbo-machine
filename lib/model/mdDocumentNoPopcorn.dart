class DocumentNoPopcorn {
  String? docno;
  String? shopname;

  DocumentNoPopcorn({this.docno, this.shopname});

  DocumentNoPopcorn.fromJson(Map<String, dynamic> json) {
    docno = json['docno'];
    shopname = json['shopname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['docno'] = docno;
    data['shopname'] = shopname;
    return data;
  }
  static List<DocumentNoPopcorn>? fromJsonList(List list) => list.map((item) => DocumentNoPopcorn.fromJson(item)).toList();
}