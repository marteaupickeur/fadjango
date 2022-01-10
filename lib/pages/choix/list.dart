import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fadjango/pages/authentification/deconnexion.dart';
import 'package:fadjango/pages/services/list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fadjango/utils/urls.dart';
import 'package:http/http.dart' as http;
import 'package:fadjango/utils/choix.dart';
import 'package:fadjango/pages/widgetUtils/remove.dart';
import 'package:fadjango/pages/widgetUtils/edit.dart';

class ChoiceList extends StatefulWidget {
  const ChoiceList({Key? key}) : super(key: key);

  @override
  _ChoiceListState createState() => _ChoiceListState();
}

class _ChoiceListState extends State<ChoiceList> {
  List<Choix> listChoix = [];

  listing() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      var response = await list(
          choixUrl, prefs.getString("cookie"), prefs.getString("sessionid"));
      if (response is http.Response) {
        if (response.statusCode == 200) {
          List listChoixJson = jsonDecode(response.body);
          for (var lc in listChoixJson) {
            listChoix.add(Choix.fromJson(lc));
          }
          setState(() {
            listChoix;
          });
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

  Future<List<Choix>?> returnlist(List<Choix> L) async {
    if (L.length == 0) {
      return null;
    }
    return L;
  } //return data for my future builder

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listing(); // call it when all start and fill my listChoix
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Choice List',
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
        child: FutureBuilder(
            future: returnlist(listChoix),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const CircularProgressIndicator();
              } else {
                var data = snapshot.data as List<Choix>;
                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, i) {
                    return ListTile(
                      leading: Text(data[i].id.toString()),
                      title: Text(data[i].textChoix),
                      subtitle: Text(
                          'votes: ${data[i].votes.toString()} question n°:${data[i].questionId.toString()} '),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return RemoveItem(
                                  id: data[i].id,
                                  url: choixUrl,
                                  ctx: context,
                                );
                              }).then((value) => {
                                if (value == true)
                                  {data.removeAt(i), setState(() {})}
                              });
                        },
                      ),
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return EditChoiceItem(choiceId: data[i].id);
                            }).then((value) {
                          setState(() {
                            data.clear();
                            listing();
                          });
                        });
                      },
                    );
                  },
                );
              }
            }),
      ),
    );
  }
}
