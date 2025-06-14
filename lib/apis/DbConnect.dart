import 'dart:convert';
import 'package:dio/dio.dart';
import '../model/mdDocumentNoPopcorn.dart';
import '../model/mdShoppopcorn.dart';
import '../model/mdget_saleno_game.dart';

class Dbconnect {
  String getSalenoPopcorn = "http://172.2.100.100/posdata/data_fb.php?select=shoppopcorn";
  String getSalenoGame = 'http://172.2.100.14/application/query_pos_popcorn/fluttercon.php?mode=get_saleno_game';
  String docnoPopcorn = "http://172.2.100.100/posdata/data_fb.php?select=DocumentNo&idshop=16";

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
}