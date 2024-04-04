import 'package:flutter/material.dart';
import 'package:managment/widgets/bottomnavigationbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CustomMoney extends StatefulWidget {
  const CustomMoney({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => CustomMoneyState();
}

class CustomMoneyState extends State<CustomMoney> {
  late List<dynamic> currencies = [];
  String? selectedCurrency;

  @override
  void initState() {
    super.initState();
    fetchCurrencies();
  }

  Future<void> fetchCurrencies() async {
    final response = await http.get(Uri.parse('https://660d04c73a0766e85dbf4c43.mockapi.io/api/tien'));

    if (response.statusCode == 200) {
      setState(() {
        currencies = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load currencies');
    }
  }

  Future<void> saveSelectedCurrency(String newValue) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('selectedCurrency', newValue);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Custom Money'),
        backgroundColor: Colors.blueGrey, // Thay đổi màu sắc của appbar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 32.0),
            Text(
              "Chọn đơn vị tiền tệ bạn sử dụng",
              style: TextStyle(color: Colors.black, fontSize: 22),
            ),
            const SizedBox(height: 32.0),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        // Thực hiện hành động khi nhấn nút "SỬA"
                      },
                      child: Text(
                        "Chọn",
                        style: TextStyle(color: Colors.blueGrey),
                      ),
                    ),
                    DropdownButton<String>(
                      value: selectedCurrency,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedCurrency = newValue!;
                        });
                        saveSelectedCurrency(newValue!);
                      },
                      items: currencies.map<DropdownMenuItem<String>>((dynamic value) {
                        return DropdownMenuItem<String>(
                          value: value['kihieu'],
                          child: Text(value['ten']),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => Bottom()));
        },
        label: Text("Lưu", style: TextStyle(color: Colors.white)), // Thay đổi màu chữ của nút "Lưu"
        backgroundColor: Colors.blueGrey,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat, // Đặt vị trí của button
    );
  }
}
