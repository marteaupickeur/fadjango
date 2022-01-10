import 'dart:convert';
import 'package:fadjango/pages/widgetUtils/remove.dart';
import 'package:flutter/material.dart';
import 'package:fadjango/pages/authentification/deconnexion.dart';
import 'package:fadjango/pages/services/list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:fadjango/utils/question.dart';
import '../../utils/urls.dart';
import 'package:fadjango/pages/services/update.dart';
import 'package:fadjango/pages/widgetUtils/edit.dart';

class QuestionList extends StatefulWidget {
  const QuestionList({Key? key}) : super(key: key);

  @override
  _QuestionListState createState() => _QuestionListState();
}

class _QuestionListState extends State<QuestionList> {
  List<Question> listQuestion = [];

  updating() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map body = {
      "id": '10',
      "question_text": "momarUpdate12",
      "pub_date": "2021-10-16T14:25:48.794216Z"
    };

    try {
      var response = await update(questionUrl, 10, body,
          prefs.getString('cookie'), prefs.getString('sessionid'));

      if (response is http.Response) {
        if (response.statusCode == 200) {
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Code Erreur Http :${response.statusCode}')));
        }
      }
    } on Exception catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  listing() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      var response = await list(
          questionUrl, prefs.getString("cookie"), prefs.getString("sessionid"));
      if (response is http.Response) {
        if (response.statusCode == 200) {
          List listQuestionJson = jsonDecode(response.body);
          for (var lq in listQuestionJson) {
            listQuestion.add(Question.fromJson(lq));
          }
          setState(() {
            listQuestion;
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

  Future<List<Question>?> returnList() async {
    if (listQuestion.length == 0) {
      return null;
    }
    return listQuestion;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listing();
    updating();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Question List',
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
        child: Center(
          child: FutureBuilder(
              future: returnList(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                } else {
                  var data = snapshot.data as List<Question>;
                  return ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, i) {
                        return ListTile(
                          leading: Text(data[i].id.toString()),
                          title: Text(data[i].textQuestion),
                          subtitle: Text('DateTime: ${data[i].dateTime}'),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return RemoveItem(
                                        id: data[i].id,
                                        url: questionUrl,
                                        ctx: context);
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
                                  return EditQuestionItem(
                                      questionId: data[i].id);
                                }).then((value) {
                              setState(() {
                                data.clear();
                                listing();
                              });
                            });
                          },
                        );
                      });
                }
              }),
        ),
      ),
    );
  }
}
