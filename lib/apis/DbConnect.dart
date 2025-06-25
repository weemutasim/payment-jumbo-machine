import 'dart:convert';
import 'package:dio/dio.dart';
import '../model/mdDocumentNoPopcorn.dart';
import '../model/mdShoppopcorn.dart';
import '../model/mdPopcornTMP.dart';
import '../model/mdget_saleno_game.dart';

class Dbconnect {
  String getSalenoPopcorn = "http://172.2.100.100/posdata/data_fb.php?select=shoppopcorn";
  String getSalenoGame = 'http://172.2.100.14/application/query_pos_popcorn/fluttercon.php?mode=get_saleno_game';
  String docnoPopcorn = "http://172.2.100.100/posdata/data_fb.php?select=DocumentNo&idshop=16";
  String listPopcornTMP = 'http://172.2.100.14/application/query_pos_popcorn/fluttercon.php?mode=SELECT_DATA_TMP';
  String listGameTMP = 'http://172.2.100.14/application/query_pos_popcorn/fluttercon.php?mode=SELECT_DATA_GAME_TMP';

  Future<List<Shoppopcorn>?> getShoppopcorn() async {
    try {
      var response = await Dio().get(getSalenoPopcorn);
      if (response.statusCode == 200) {
        var rawData = jsonDecode(response.data);
        var shoppopcorn = Shoppopcorn.fromJsonList(rawData);
        print('Shoppopcorn ok!');
        return shoppopcorn;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }
    return null;
  }

  Future<List<GetPopcornTMP>?> getListPopcornTMP() async {
    try {
      var response = await Dio().get(listPopcornTMP);
      if (response.statusCode == 200) {
        var listPopcornTMP = GetPopcornTMP.fromJsonList(response.data);
        print('listPopcornTMP ok!');
        return listPopcornTMP;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error ss: $e');
    }
    return null;
  }

  Future<List<GetPopcornTMP>?> getListGameTMP() async {
    try {
      var response = await Dio().get(listGameTMP);
      if (response.statusCode == 200) {
        var listGameTMP = GetPopcornTMP.fromJsonList(response.data);
        print('listGameTMP ok!');
        return listGameTMP;
      } else {
        throw Exception('Failed to load data'); //371.96
      }
    } catch (e) {
      print('Error: $e');
    }
    return null;
  }

  Future<List<GetSalenoGame>?> salenoGame() async {
    try {
      var response = await Dio().get(getSalenoGame);
      if (response.statusCode == 200) {
        var shopgame = GetSalenoGame.fromJsonList(response.data);
        print('Shopgames ok!');
        return shopgame;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }
    return null;
  }

  Future<List<DocumentNoPopcorn>?> getDocno() async {
    try {
      var response = await Dio().get(docnoPopcorn);
      if (response.statusCode == 200) {
        var rawData = jsonDecode(response.data);
        var docno = DocumentNoPopcorn.fromJsonList(rawData);
        print('Docno ok!');
        return docno;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }
    return null;
  }

  Future<dynamic> insertPopcorn({
    required dynamic arrayData,
    required String uid,
    required String saleno, // เลขที่ใบเสร็จ
    required String saledate, // วันที่ขาย format yyyy-mm-dd
    required String taxid, //
    required String guidecode, //ว่าง
    required String qtygood, //total detail
    required String total, //total ถยอดรวมหลังหักส่วนลดในรายการ
    required String totRec, //กรณีเงินสดรับเงินมา
    required String totChange, //กรณีเงินสดเงินทอน
    required String totDiscount, //ส่วนลดเป็ยบาท
    required String vat, //ภาษี total - discout
    required String grandTotal, //ราคาเต็มลบภาษี total - discout - vat
    required String idCard, //credit 3 ตัวท้าย
    required String flag, //กรณีเงินสดเป็น W ปกติเป็น N
    required String shopcode, //id shop
    required String location, //shopcode
    required String personId, //ว่าง
    required String staffcode, //ว่าง
    required String sysdate, //วันที่ขาย format yyyy-mm-dd hh:mm:ss
    required String cardtype, //100 เงินสด 101 credit
    required String accode, //100 เงินสด 101 credit
    required String saleuser, //self
    required String totCreditcard, //ยอดเงินเครดิต
    required String billtype, //ว่าง
    required String queue, 
    required String entcode, //ว่าง
    required String voucher, //ว่าง
    required String coupon, //ว่าง
    required String totCoupon, //ว่าง
    required String api
    }) async {
    String jsonData = json.encode(arrayData);
    FormData formData = FormData.fromMap({
      "uid": uid,
      "saleno": saleno,
      "saledate": saledate, 
      "taxid": taxid,
      "guidecode": guidecode,
      "qtygood": qtygood,
      "total": total,
      "tot_rec": totRec,
      "tot_change": totChange,
      "tot_discount": totDiscount,
      "vat": vat,
      "grand_total": grandTotal,
      "id_card": idCard,
      "flag": flag,
      "shopcode": shopcode,
      "location": location,
      "person_id": personId,
      "staffcode": staffcode,
      "sysdate": sysdate,
      "cardtype": cardtype,
      "accode": accode,
      "saleuser": saleuser,
      "tot_creditcard": totCreditcard,
      "billtype": billtype,
      "queue": queue,
      "entcode": entcode,
      "voucher": voucher,
      "coupon": coupon,
      "tot_coupon": totCoupon,
      "detail": jsonData
    });
    print('>>>>>>>>>>>${formData.fields}');
    /* try {
      var response = await Dio().post(api, data: formData);
      Response data = response.data;
      print("Status Code Popcorn: ${response.statusCode}");
      print("Response Data Popcorn: ${response.data}");
      return data;
    } catch (e) {
      if (e is DioException) {
        print("DioException: ${e.response?.statusCode} - ${e.response?.data}");
      } else {
        print("Error: $e");
      }
    } */
    try {
      Response response = await Dio().post( api, data: formData, options: Options(responseType: ResponseType.plain)); // รับเป็น text

      String raw = response.data.toString().trim();
      // print("Raw response:\n$raw");

      // หา JSON ส่วนที่เริ่มจาก { เช่น {"queue":5}
      int jsonStart = raw.lastIndexOf('{');
      if (jsonStart != -1) {
        String jsonPart = raw.substring(jsonStart);
        Map<String, dynamic> parsed = jsonDecode(jsonPart);
        // print("Queue value = ${parsed['queue']}");
        return parsed;
      } else {
        print("ไม่พบ JSON ที่ขึ้นต้นด้วย {");
      }

    } catch (e) {
      print("Dio error: $e");
    }
  }

  Future<dynamic> insertGamescard({
    required dynamic arrayData,
    required String uid,
    required String saleno, // เลขที่ใบเสร็จ
    required String saledate, // วันที่ขาย format yyyy-mm-dd
    required String taxid, //
    required String guidecode, //ว่าง
    required String qtygood, //total detail
    required String total, //total ยอดรวมหลังหักส่วนลดในรายการ
    required String totRec, //กรณีเงินสดรับเงินมา
    required String totChange, //กรณีเงินสดเงินทอน
    required String totDiscount, //ส่วนลดเป็ยบาท
    required String vat, //ภาษี total - discout
    required String grandTotal, //ราคาเต็มลบภาษี total - discout - vat
    required String idCard, //credit 3 ตัวท้าย
    required String flag, //กรณีเงินสดเป็น W ปกติเป็น N
    required String shopcode, //id shop
    required String location, //shopcode
    required String personId, //ว่าง
    required String staffcode, //ว่าง
    required String sysdate, //วันที่ขาย format yyyy-mm-dd hh:mm:ss
    required String cardtype, //100 เงินสด 101 credit
    required String accode, //100 เงินสด 101 credit
    required String saleuser, //self
    required String totCreditcard, //ยอดเงินเครดิต
    required String billtype, //ว่าง
    required String entcode, //ว่าง
    required String voucher, //ว่าง
    required String precentDiscount, 
    required String coupon, //ว่าง
    required String api
    }) async {
    String jsonData = json.encode(arrayData);
    FormData formData = FormData.fromMap({
      "uid": uid,
      "saleno": saleno,
      "saledate": saledate,
      "taxid": taxid,
      "guidecode": guidecode,
      "qtygood": qtygood,
      "total": total,
      "tot_rec": totRec,
      "tot_change": totChange,
      "tot_discount": totDiscount,
      "vat": vat,
      "grand_total": grandTotal,
      "id_card": idCard,
      "flag": flag,
      "shopcode": shopcode,
      "location": location,
      "person_id": personId,
      "staffcode": staffcode,
      "sysdate": sysdate,
      "cardtype": cardtype,
      "accode": accode,
      "saleuser": saleuser,
      "tot_creditcard": totCreditcard,
      "billtype": billtype,
      "entcode": entcode,
      "voucher": voucher,
      "percent_discount": precentDiscount,
      "coupon": coupon,
      "detail": jsonData
    });
    print('>>>>>>>>>>>${formData.fields}');
    try {
      var response = await Dio().post(api, data: formData);
      Response data = response.data;
      print("Status Code Popcorn: ${response.statusCode}");
      print("Response Data Popcorn: ${response.data}");
      return data;
    } catch (e) {
      if (e is DioException) {
        print("DioException: ${e.response?.statusCode} - ${e.response?.data}");
      } else {
        print("Error: $e");
      }
    }
  }
}