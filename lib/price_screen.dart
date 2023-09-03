import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'coin_data.dart';
import 'dart:io' show Platform;


class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  //var  rateDataInt = 0;
  String selectedCurrency = 'AUD';
  CoinData coinData = CoinData();
  String cryptoSymbol = cryptoList[0]; // Initialize with a default cryptocurrency


  DropdownButton<String> androidDropdown(String cryptoSymbol) {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      dropdownItems.add(newItem);
    }

    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropdownItems,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value;
          getData(value, selectedCurrency);
         // cryptoSymbol = '$rateDataInt  $selectedCurrency';
        });
       // print(cryptoSymbol);
      },
    );
  }

  CupertinoPicker iOSPicker(String cryptoSymbol) {
    List<Text> pickerItems = [];
    for (String currency in currenciesList) {
      pickerItems.add(Text(currency));
    }

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        //print(selectedIndex);
       getData(cryptoSymbol, selectedCurrency);
      },
      children: pickerItems,
    );
  }


  //TODO: Create a method here called getData() to get the coin data from coin_data.dart
  Future getData(String cryptoSymbol, String currency) async{
var rateDataInt = 0;
    var rateData = await coinData.getCoinData(cryptoSymbol, currency);
    setState(() {
      rateDataInt = rateData.toInt();
    });
    return rateDataInt;
  }


  @override
  void initState() {
    super.initState();
    //TODO: Call getData() when the screen loads up.
    getData(cryptoSymbol, selectedCurrency);
    androidDropdown(cryptoSymbol);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('🤑 COIN CONVERTER')),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: CoinCard(
                      cryptoSymbol: cryptoList[0],
                      selectedCurrency: selectedCurrency,
                    ),
                  ),
                  Expanded(
                    child: CoinCard(
                      cryptoSymbol: cryptoList[1],
                      selectedCurrency: selectedCurrency,
                    ),
                  ),

                  Expanded(
                    child: CoinCard(
                      cryptoSymbol: cryptoList[2],
                      selectedCurrency: selectedCurrency,
                    ),
                  ),
                ],
              ),

            ),
          ),
          SizedBox(height: 100,),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iOSPicker(cryptoSymbol) : androidDropdown(cryptoSymbol),
          ),
        ],
      ),
    );
  }
}

// class CoinCard extends StatelessWidget {
//    CoinCard({
//     Key key,
//     @required this.cryptoSymbol,
//     @required this.selectedCurrency,
//   }) : super(key: key);
//
//   final String cryptoSymbol;
//   final String selectedCurrency;
//   CoinData coinData = CoinData();
//
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       future: coinData.getCoinData(cryptoSymbol, selectedCurrency),
//
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return CircularProgressIndicator(); // Display loading indicator while waiting for data
//         } else if (snapshot.hasError) {
//           return Text('Error: ${snapshot.error}');
//         } else {
//           double rateData = snapshot.data;
//           return Card(
//             color: Colors.lightBlueAccent,
//             elevation: 5.0,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(10.0),
//             ),
//             child: Padding(
//               padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
//               child: Text(
//                 //TODO: Update the Text Widget with the live cryptocurrency data here.
//                 '1 $cryptoSymbol = ${rateData.toStringAsFixed(2)} $selectedCurrency',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 20.0,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           );
//         }
//       },
//     );
//   }
// }



// This can also be used instead of the above CoinCard class
class CoinCard extends StatefulWidget {
  final String cryptoSymbol;
  final String selectedCurrency;

  CoinCard({
    Key key,
    @required this.cryptoSymbol,
    @required this.selectedCurrency,
  }) : super(key: key);

  @override
  _CoinCardState createState() => _CoinCardState();
}

class _CoinCardState extends State<CoinCard> {
  double rateData;
  CoinData coinData =CoinData();

  @override
  void initState() {
    super.initState();
    // Fetch data when the widget is first created
    getData();
  }

  Future<void> getData() async {
    var data = await coinData.getCoinData(widget.cryptoSymbol, widget.selectedCurrency);
    setState(() {
      rateData = data;
    });
  }

  @override
  void didUpdateWidget(CoinCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Fetch new data when the widget updates (cryptocurrency symbol or selected currency changes)
    if (widget.cryptoSymbol != oldWidget.cryptoSymbol ||
        widget.selectedCurrency != oldWidget.selectedCurrency) {
      getData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.lightBlueAccent,
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
        child: rateData != null
            ? Text(
          //TODO: Update the Text Widget with the live cryptocurrency data here.
          '1 ${widget.cryptoSymbol} = ${rateData.toStringAsFixed(2)} ${widget.selectedCurrency}',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.white,
          ),
        )
            : CircularProgressIndicator(),
      ),
    );
  }
}
