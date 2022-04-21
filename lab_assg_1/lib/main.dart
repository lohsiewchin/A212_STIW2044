import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
      primarySwatch: Colors.yellow,
  ),
      home: const ExchangePage(),
    );
  }
}

class ExchangePage extends StatefulWidget {
  const ExchangePage({Key? key}) : super(key: key);

  @override
  State<ExchangePage> createState() => _ExchangePageState();
}

class _ExchangePageState extends State<ExchangePage> {
  TextEditingController valueController = TextEditingController();

  String? selectedType;
  String? selectedUnit;
  String unit = "";
  String valueExchange = "";
  double value = 0;
  double finalValue = 0;
  double amount = 0;
  
  List<String> typeList = ["Crypto", "Fiat", "Commodity"];
  List<String> units = [];
  List<String> moneyList = ["usd", "aed", "ard", "aud", "bdt", "bhd", "bmd", "brl", "ad", "chf",
                            "clp", "cny", "czk", "dkk", "eur", "gbp", "hkd", "huf", "idr", "ils",
                            "inr", "jpy", "krw", "kwd", "lkr", "mmk", "mxn", "myr", "ngn", "nok",
                            "nzd", "php", "pkr", "pln", "rub", "sar", "sek", "sgd", "thb", "try",
                            "twd", "uah", "vef", "vnd", "zar", "xdr"];
  List<String> cryptoList = ["btc", "eth", "ltc", "bch", "bnb", "eos", "xrp", "xlm", "link", "dot",
                            "yfi", "bits", "sats"];
  List<String> commodityList = ["xag", "xau"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Bitcoin Changer'), 
        ),
        body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Enter the amount of Bitcoin", style: TextStyle(fontSize: 20)),
                TextField(
                  textAlign: TextAlign.center,
                  controller: valueController,
                  keyboardType: const TextInputType.numberWithOptions(),
                  decoration: const InputDecoration(
                    hintText: "Amount of Bitcoin",
                  ),
                ),

                DropdownButton(
                  itemHeight: 60,
                  hint: const Text("Select Type"),
                  value: selectedType,
                  items: typeList.map((String value) {
                    return DropdownMenuItem(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                   onChanged: onChangedCallback1,
                ),

                Scrollbar(
                  child: DropdownButton(
                    itemHeight: 60,
                    hint: const Text("Select Unit"),
                    value: selectedUnit,
                    items: units.map((String value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (unit) {
                      setState(() {
                        selectedUnit = unit.toString();
                      });
                    },
                  ),
                ),

                const Text("The value is", style: TextStyle(fontSize: 20)),

                Text(valueExchange, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),

                ElevatedButton(onPressed: exchange, child: const Text("Exchange", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)))
              ],
            )
        ),
      );
  }

  void onChangedCallback1(type) {
    if (type == "Crypto") {
      units = cryptoList;
    } else if (type == "Fiat") {
      units = moneyList;
    } else if (type == "Commodity") {
      units = commodityList;
    } else {
      units = [];
    }
    setState(() {
      selectedType = type.toString();
      selectedUnit = null;
    });
  }

  Future<void> exchange() async {
    var url = Uri.parse('https://api.coingecko.com/api/v3/exchange_rates');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonData = response.body;
      var parsedData = json.decode(jsonData);

      amount = double.parse(valueController.text);

      setState(() {
        unit = parsedData['rates'][selectedUnit]['unit'];
        value = parsedData['rates'][selectedUnit]['value'];
        finalValue = amount*value;

        valueExchange = "$finalValue $unit";

      });
    }

  }

  
}