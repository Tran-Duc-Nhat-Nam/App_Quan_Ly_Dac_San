import 'dart:convert';

import 'package:http/http.dart';

class ApiHelper {
  static const String baseUrl = "http://localhost:8080/";
}

Future<dynamic> docAPI(String url) async {
  var reponse = await get(
    Uri.parse(url),
    headers: {"Access-Control-Allow-Origin": "*"},
  );
  return json.decode(utf8.decode(reponse.bodyBytes));
}

Future<Response> taoAPI(String url, String body) async {
  return await post(
    Uri.parse(url),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: body,
  );
}

Future<Response> capNhatAPI(String url, String body) async {
  return await put(
    Uri.parse(url),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: body,
  );
}

Future<Response> xoaAPI(String url, String body) async {
  return await delete(
    Uri.parse(url),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: body,
  );
}
