import 'dart:convert';

import 'package:cek_ongkir/model/city.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import 'detail_page.dart';

void main() async {
  await dotenv.load(fileName: ".env");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cek Ongkos Kirim',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? key = dotenv.env['API_KEY'];
  dynamic city;
  dynamic cityDestination;
  dynamic weight;
  dynamic expedisi;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownSearch<City>(
              dropdownSearchDecoration:
                  const InputDecoration(labelText: "Kota Asal", hintText: "Pilih Kota Asal"),
              mode: Mode.MENU,
              showSearchBox: true,
              onChanged: (value) {
                city = value?.cityId;
              },
              itemAsString: (item) => "${item!.type} ${item.cityName}",
              onFind: (text) async {
                var response =
                    await http.get(Uri.parse("https://api.rajaongkir.com/starter/city?key=$key"));

                List allCity =
                    (jsonDecode(response.body) as Map<String, dynamic>)['rajaongkir']['results'];
                var dataCity = City.fromJsonList(allCity);

                return dataCity;
              },
            ),
            const SizedBox(height: 20),
            DropdownSearch<City>(
              dropdownSearchDecoration:
                  const InputDecoration(labelText: "Kota Tujuan", hintText: "Pilih Kota Tujuan"),
              mode: Mode.MENU,
              showSearchBox: true,
              onChanged: (value) {
                cityDestination = value?.cityId;
              },
              itemAsString: (item) => "${item!.type} ${item.cityName}",
              onFind: (text) async {
                var response =
                    await http.get(Uri.parse("https://api.rajaongkir.com/starter/city?key=$key"));

                List allCity =
                    (jsonDecode(response.body) as Map<String, dynamic>)['rajaongkir']['results'];
                var dataCity = City.fromJsonList(allCity);

                return dataCity;
              },
            ),
            const SizedBox(height: 20),
            TextField(
              //input hanya angka
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Berat Paket (gram)",
                hintText: "Input Berat Paket",
              ),
              onChanged: (text) {
                weight = text;
              },
            ),
            const SizedBox(height: 20),
            DropdownSearch<String>(
                mode: Mode.MENU,
                showSelectedItems: true,
                //pilihan kurir
                items: const ["jne", "tiki", "pos"],
                dropdownSearchDecoration: const InputDecoration(
                  labelText: "Kurir",
                  hintText: "Kurir",
                ),
                popupItemDisabled: (String s) => s.startsWith('I'),
                onChanged: (text) {
                  expedisi = text;
                }),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                //validasi
                if (city == '' || cityDestination == '' || weight == '' || expedisi == '') {
                  const snackBar = SnackBar(content: Text("Isi bidang yang masih kosong!"));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                } else {
                  //berpindah halaman dan bawa data
                  Navigator.push(
                    context,
                    // DetailPage adalah halaman yang dituju
                    MaterialPageRoute(
                        builder: (context) => DetailPage(
                              city: city,
                              cityDestination: cityDestination,
                              weight: weight,
                              expedisi: expedisi,
                            )),
                  );
                }
              },
              child: const Center(
                child: Text("Cek Ongkir"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
