import 'dart:convert';
import 'dart:html';

import 'package:http/http.dart' as http;

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

class CoinData {
  final String apiKey = '397D048F-DC08-4BC7-81D3-E8BE349A500B';
  final String coinAPIURL = 'https://rest.coinapi.io/v1/exchangerate';

  Future<double> getCoinData() async {
    http.Response response =
        await http.get(Uri.parse('$coinAPIURL/BTC/USD?apikey=$apiKey') );
    if (response.statusCode == 200) {
      var decodedData = jsonDecode(response.body);
      double lastPrice = decodedData['rate'];
      return lastPrice;
    } else {
      print(response.statusCode);
      throw 'Problem with request';
    }
  }
}
