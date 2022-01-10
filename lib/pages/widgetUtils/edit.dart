import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fadjango/pages/services/update.dart';
import 'package:http/http.dart' as http;
import 'package:fadjango/utils/urls.dart';

Future updating(id, url, body, context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  try {
    var response = await update(
        url, id, body, prefs.getString('cookie'), prefs.getString('sessionid'));
    if (response is http.Response) {
      if (response.statusCode == 200) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Mis à jour !'),
        ));
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

class EditQuestionItem extends StatefulWidget {
  final int questionId;
  const EditQuestionItem({Key? key, required this.questionId})
      : super(key: key);

  @override
  _EditQuestionItemState createState() => _EditQuestionItemState();
}

class _EditQuestionItemState extends State<EditQuestionItem> {
  final _fkey = GlobalKey<FormState>();
  final _qtController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();

  callUpdatingQuestion() async {
    if (_fkey.currentState!.validate()) {
      Map body = {
        "id": '${widget.questionId}',
        "question_text": _qtController.text,
        "pub_date": "${_dateController.text}T${_timeController.text}.794216Z"
      };

      await updating(widget.questionId, questionUrl, body, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: 500,
        child: Form(
          key: _fkey,
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 18.0),
                  child: Text(
                    'Mis àjour Element Id: ${widget.questionId}',
                    style: const TextStyle(
                      fontSize: 19,
                    ),
                  ),
                ),
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
                    onPressed: callUpdatingQuestion,
                    child: const Text('Ajouter'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EditChoiceItem extends StatefulWidget {
  final int choiceId;

  const EditChoiceItem({Key? key, required this.choiceId}) : super(key: key);

  @override
  _EditChoiceItemState createState() => _EditChoiceItemState();
}

class _EditChoiceItemState extends State<EditChoiceItem> {
  final _fk = GlobalKey<FormState>();
  final _ctController = TextEditingController();
  final _vController = TextEditingController();
  final _qidController = TextEditingController();

  callUpdating() async {
    if (_fk.currentState!.validate()) {
      Map body = {
        "id": '${widget.choiceId}',
        "choice_text": _ctController.text,
        "votes": _vController.text,
        "question": _qidController.text
      };

      await updating(widget.choiceId, choixUrl, body, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: 500,
        child: Form(
            key: _fk,
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 18.0),
                    child: Text('Mis à jour Element id: ${widget.choiceId}',
                        style: const TextStyle(fontSize: 19)),
                  ),
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
                  ElevatedButton(
                      onPressed: callUpdating, child: const Text('Ajourer'))
                ],
              ),
            )),
      ),
    );
  }
}
