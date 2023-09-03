//TODO: Add your imports here.
import 'package:http/http.dart' as http;
import 'dart:convert';

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

const coinAPIURL = 'https://rest.coinapi.io/v1/exchangerate';
const apiKey = '16D24F17-EAB7-48B2-892B-ECDA61BF0B4D';


class CoinData {
  //TODO: Create your getCoinData() method here.
  Future getCoinData(String cryptoSymbol, String currency) async{
    var url = '$coinAPIURL/$cryptoSymbol/$currency?apikey=$apiKey';
    http.Response response = await http.get(Uri.parse(url));
    if(response.statusCode == 200){
      String data = await response.body;
      var decodedData = jsonDecode(data)['rate'];


      return decodedData;
    }else{

      // Handle error
      throw Exception('Failed to fetch data');


    }
  }
}
