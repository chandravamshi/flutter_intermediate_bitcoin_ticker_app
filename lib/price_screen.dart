import 'dart:js_util';

import 'package:bitcoin_ticker/coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class PriceScreen extends StatefulWidget {
  const PriceScreen({super.key});

  @override
  State<PriceScreen> createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';

  DropdownButton<String> androidDropDown() {
    List<DropdownMenuItem<String>> dropDownItems = [];
    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(value: currency, child: Text(currency));
      dropDownItems.add(newItem);
    }
    return DropdownButton(
      items: dropDownItems,
      value: selectedCurrency,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value.toString();
          getData();
        });
      },
    );
  }

  CupertinoPicker iosPicker() {
    List<Text> pickerItems = [];
    for (String currency in currenciesList) {
      var newItem = Text(currency);
      pickerItems.add(newItem);
    }

    return CupertinoPicker(
        itemExtent: 32.0,
        onSelectedItemChanged: (selctedIndex) {
          // print(selctedIndex);
          selectedCurrency = currenciesList[selctedIndex];
          getData();
        },
        children: pickerItems);
  }

  Map<String, String> coinValues = {};
  bool isWaiting = false;

  getCoinWidgets() {
    List<CoinWidget> coinWidgets = [];
    for (String coin in cryptoList) {
      coinWidgets.add(CoinWidget(
          coin: coin,
          selectedCurrency: selectedCurrency,
          value: isWaiting ? '?' : coinValues[coin] ?? '?'));
    }
    return coinWidgets;
  }

  void getData() async {
    isWaiting = true;
    try {
      Map<String, String> data = await CoinData().getCoinData(selectedCurrency);
      isWaiting = false;
      setState(() {
        coinValues = data;
      });
    } catch (e) {
      rethrow;
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🤑 Coin Ticker'),
        backgroundColor: Colors.redAccent,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ...getCoinWidgets(),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: const EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: iosPicker(),
          ),
        ],
      ),
    );
  }
}

class CoinWidget extends StatelessWidget {
  const CoinWidget({
    super.key,
    required this.coin,
    required this.selectedCurrency,
    required this.value,
  });

  final String coin;
  final String selectedCurrency;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0.0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '$coin = $value $selectedCurrency',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
