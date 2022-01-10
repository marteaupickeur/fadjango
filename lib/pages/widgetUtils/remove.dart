import 'package:flutter/material.dart';
import 'package:fadjango/pages/services/delete.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class RemoveItem extends StatefulWidget {
  final int id;
  final String url;
  final BuildContext ctx;

  const RemoveItem(
      {Key? key, required this.id, required this.url, required this.ctx})
      : super(key: key);

  @override
  _RemoveItemState createState() => _RemoveItemState();
}

class _RemoveItemState extends State<RemoveItem> {
  bool isOk = false;

  Future remove(url, id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      var response = await delete(
          url, id, prefs.getString('cookie'), prefs.getString('sessionid'));
      if (response is http.Response) {
        if (response.statusCode == 204) {
          setState(() {
            isOk = true;
          });

          ScaffoldMessenger.of(widget.ctx).showSnackBar(const SnackBar(
            content: Text('Supprimmé !'),
          ));
          // return isOk;
        } else {
          ScaffoldMessenger.of(widget.ctx).showSnackBar(SnackBar(
            content: Text('Code Erreur Http :${response.statusCode}'),
          ));
        }
      }
      if (response == 'Timeout') {
        ScaffoldMessenger.of(widget.ctx).showSnackBar(
            const SnackBar(content: Text("Echec deconnexion trop long")));
      }
      if (response == 'Put parameters') {
        ScaffoldMessenger.of(widget.ctx).showSnackBar(
            const SnackBar(content: Text("Ajouter des parametres")));
      }
    } on Exception catch (e) {
      ScaffoldMessenger.of(widget.ctx)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Voulez vous Supprimer cet élément ?'),
      content: Text('Element Id: ${widget.id}'),
      actions: [
        ElevatedButton(
            onPressed: () async {
              await remove(widget.url, widget.id);
              Navigator.pop(context, isOk);
            },
            child: const Text('Oui')),
        ElevatedButton(
            onPressed: () {
              Navigator.pop(context, isOk);
            },
            child: const Text('Non')),
      ],
    );
  }
}
