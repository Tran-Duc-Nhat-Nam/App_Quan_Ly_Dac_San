import 'dart:convert';

import 'package:http/http.dart';

Future<dynamic> docJson(String url) async {
  var reponse = await get(
    Uri.parse(url),
    headers: {"Access-Control-Allow-Origin": "*"},
  );
  return json.decode(utf8.decode(reponse.bodyBytes));
}

Future<Response> ghiJson(String url, String body) async {
  return await post(
    Uri.parse(url),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: body,
  );
}
