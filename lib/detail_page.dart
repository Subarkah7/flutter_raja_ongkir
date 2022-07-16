import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class DetailPage extends StatefulWidget {
  final String? city;
  final String? cityDestination;
  final String? weight;
  final String? expedisi;

  const DetailPage({Key? key, this.city, this.cityDestination, this.weight, this.expedisi})
      : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  List _data = [];
  String? key = dotenv.env['API_KEY'];

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    _getData();
  }

  Future _getData() async {
    try {
      await http.post(
        Uri.parse(
          "https://api.rajaongkir.com/starter/cost",
        ),
        //MENGIRIM PARAMETER
        body: {
          "key": key,
          "origin": widget.city,
          "destination": widget.cityDestination,
          "weight": widget.weight,
          "courier": widget.expedisi
        },
      ).then((value) {
        var data = jsonDecode(value.body);

        setState(() {
          _data = data['rajaongkir']['results'][0]['costs'];
        });
      });
    } catch (e) {
      //ERROR
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Cek Ongkir"),
      ),
      body: ListView.builder(
        itemCount: _data.length,
        itemBuilder: (_, index) {
          return ListTile(
            title: Text("${_data[index]['service']}"),
            subtitle: Text("${_data[index]['description']}"),
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const SizedBox(
                  height: 5,
                ),
                Text(
                  "Rp ${_data[index]['cost'][0]['value']}",
                  style: const TextStyle(fontSize: 20, color: Colors.red),
                ),
                const SizedBox(
                  height: 3,
                ),
                Text("${_data[index]['cost'][0]['etd']} Days")
              ],
            ),
          );
        },
      ),
    );
  }
}
