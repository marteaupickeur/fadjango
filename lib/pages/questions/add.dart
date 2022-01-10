import 'package:flutter/material.dart';
import 'package:fadjango/pages/authentification/deconnexion.dart';
import 'package:fadjango/pages/services/add.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/urls.dart';

class AddQuestion extends StatefulWidget {
  const AddQuestion({Key? key}) : super(key: key);

  @override
  _AddQuestionState createState() => _AddQuestionState();
}

class _AddQuestionState extends State<AddQuestion> {
  final _fk = GlobalKey<FormState>();
  final _qtController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();

  addQuestion() async {
    if (_fk.currentState!.validate()) {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      try {
        Map<String, dynamic> b = {
          "question_text": _qtController.text,
          "pub_date": "${_dateController.text}T${_timeController.text}.794216Z"
        };
        var response = await add(questionUrl, b, prefs.getString("cookie"),
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
          'Add Question',
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
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 18),
                  child: TextFormField(
                    minLines: 5,
                    maxLines: 5,
                    keyboardType: TextInputType.multiline,
                    controller: _qtController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez renseigner ce champ !';
                      }
                      return null; // its the dislpay value not the controller
                    },
                    decoration: const InputDecoration(
                      labelText: 'Question',
                      border: OutlineInputBorder(),
                      hintText: '...',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 18),
                  child: TextFormField(
                    controller: _dateController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez renseigner ce champ !';
                      }
                      return null; // its the dislpay value not the controller
                    },
                    decoration: const InputDecoration(
                      labelText: 'Date',
                      border: OutlineInputBorder(),
                      hintText: 'aaaa-mm-jj',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 18),
                  child: TextFormField(
                    controller: _timeController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez renseigner ce champ !';
                      }
                      return null; // its the dislpay value not the controller
                    },
                    decoration: const InputDecoration(
                      labelText: 'Heure',
                      border: OutlineInputBorder(),
                      hintText: 'HH:mm:ss',
                    ),
                  ),
                ),
                ElevatedButton(
                    onPressed: () => {addQuestion()}, child: Text('Ajouter'))
              ],
            ),
          ),
        ),
      )),
    );
  }
}
