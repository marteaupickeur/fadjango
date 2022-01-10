import 'dart:convert';

import 'package:fadjango/utils/urls.dart';
import 'package:flutter/material.dart';
import 'package:fadjango/pages/authentification/deconnexion.dart';
import 'package:fadjango/pages/services/add.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AddChoice extends StatefulWidget {
  const AddChoice({Key? key}) : super(key: key);

  @override
  _AddChoiceState createState() => _AddChoiceState();
}

class _AddChoiceState extends State<AddChoice> {
  final _fk = GlobalKey<FormState>();
  final _ctController = TextEditingController();
  final _vController = TextEditingController();
  final _qidController = TextEditingController();

  addChoice() async {
    if (_fk.currentState!.validate()) {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      try {
        Map<String, dynamic> b = {
          "choice_text": _ctController.text,
          "votes": _vController.text,
          "question": _qidController.text
        };
        // var f = jsonEncode(b);
        var response = await add(choixUrl, b, prefs.getString("cookie"),
            prefs.getString("sessionid"));
        if (response is http.Response) {
          if (response.statusCode == 201) {
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text('Created !')));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Code Erreur Http :${response.statusCode}')));
          }
          if (response.toString() == 'Timeout') {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Echec deconnexion trop long")));
          }
          if (response.toString() == 'Put parameters') {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Ajouter des parametres")));
          }
        }
      } on Exception catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error : $e')));
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // adding();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Choice',
          style: TextStyle(color: Colors.blue),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.blue),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
            context: context,
            builder: (context) {
              return const DiologFAB();
            }),
        child: const Icon(
          Icons.logout,
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: SizedBox(
            width: 700,
            child: Form(
                key: _fk,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 18.0),
                      child: TextFormField(
                        minLines: 5,
                        maxLines: 5,
                        keyboardType: TextInputType.multiline,
                        controller: _ctController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez renseigner ce champ !';
                          }
                        },
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: '...',
                            labelText: 'Choix'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 18.0),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        controller: _vController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez renseigner ce champ !';
                          }
                        },
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'number',
                            labelText: 'Vote'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 18.0),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        controller: _qidController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez renseigner ce champ !';
                          }
                        },
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'number',
                            labelText: 'Question'),
                      ),
                    ),
                    ElevatedButton(onPressed: addChoice, child: Text('Ajourer'))
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
