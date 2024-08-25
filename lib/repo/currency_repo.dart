import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:plan_together/models/CurrencyExchangeModel.dart';

class CurrencyExchangeRepo {
  static Future exchangeCurrency(
      {required String from,
      required String to,
      required String amount}) async {

    print("exchangeCurrency Called");
    final url = Uri.parse(
            'https://currency-conversion-and-exchange-rates.p.rapidapi.com/convert')
        .replace(queryParameters: {
      'from': from,
      'to': to,
      'amount': amount,
    });

    final response = await http.get(
      url,
      headers: {
        'X-RapidAPI-Key': 'bcb347d234msh694356ea8d93965p1c3afcjsnbeaf6e5f7a36',
        'X-RapidAPI-Host':
            'currency-conversion-and-exchange-rates.p.rapidapi.com',
      },
    );

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON
      print(response.body);
      print(response.body);
      var decodedData = jsonDecode(response.body);
      print("decodedData['result'] ${decodedData['result']}");
      return CurrencyExchangeModel.fromJson(decodedData);
    } else {
      // If the server did not return a 200 OK response, throw an exception
      throw Exception('Failed to load data');
    }
  }
}
