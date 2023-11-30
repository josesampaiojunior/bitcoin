import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _resultado = "R\$ 0,00";

  Future<Map> _recuperarPreco() async {
    String url = "https://blockchain.info/ticker";
    final response = await http.get(Uri.parse(url));
    return jsonDecode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _recuperarPreco(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              break;
            case ConnectionState.active:
              break;
            case ConnectionState.waiting:
              _resultado = "Aguarde...";
              break;
            case ConnectionState.done:
              if (snapshot.hasError) {
                _resultado = "Erro ao carregar informações...";
              } else {
                Map<String, dynamic> data =
                    snapshot.data! as Map<String, dynamic>;
                _resultado = "R\$ ${data["BRL"]["buy"].toString()}";
              }
              break;
          }
          return Scaffold(
            appBar: AppBar(
              title: const Text("Consulta Bitcoin"),
              backgroundColor: Colors.orange,
            ),
            body: Container(
              padding: const EdgeInsets.all(26),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.asset("assets/images/bitcoin.png", height: 50),
                  Text(
                    _resultado,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 34,
                      color: Colors.deepOrange,
                    ),
                  ),
                  TextButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith(
                          (state) => Colors.deepOrange),
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                    ),
                    onPressed: _recuperarPreco,
                    child: const Text('Clique Aqui'),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
