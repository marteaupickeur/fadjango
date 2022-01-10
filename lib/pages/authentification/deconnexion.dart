import 'package:flutter/material.dart';
import 'package:fadjango/pages/services/logout.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:fadjango/utils/urls.dart';
import 'package:universal_platform/universal_platform.dart';

Future exit(context) async {
  if (UniversalPlatform.isAndroid || UniversalPlatform.isLinux) {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      var response = await logout(
          logoutUrl, prefs.getString('cookie'), prefs.getString('sessionid'));
      if (response is http.Response) {
        if (response.statusCode == 200) {
          prefs.clear();
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/login', (Route<dynamic> route) => false);
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Deconnexion !')));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Code Erreur Http :${response.statusCode}')));
        }
      }
      if (response == 'Timeout') {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Echec deconnexion trop long")));
      }
      if (response == 'Put parameters') {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Ajouter des parametres")));
      }
    } on Exception catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error : $e')));
    }
  }
  // FOR WEB FEATURE
  // if (UniversalPlatform.isWeb) {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   var response = await logout(url);
  //   Navigator.of(context)
  //       .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
  //   ScaffoldMessenger.of(context)
  //       .showSnackBar(const SnackBar(content: Text('Deconnexion !')));
  // }
}

class DiologFAB extends StatefulWidget {
  const DiologFAB({Key? key}) : super(key: key);

  @override
  _DiologFABState createState() => _DiologFABState();
}

class _DiologFABState extends State<DiologFAB> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Confirmation deconnexion"),
      content: const Text("Etes vous sure?"),
      actions: [
        ElevatedButton(
            // call function exit to logout
            onPressed: () => exit(context),
            child: const Text("Oui")),
        ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Non"))
      ],
    );
    // CUSTOM DIALOG
    // return Dialog(
    //     child: Column(
    //   mainAxisSize: MainAxisSize.min,
    //   mainAxisAlignment: MainAxisAlignment.center,
    //   children: [
    //     Text("Confirmation deconnexion"),
    //     Text("Etes vous sure?"),
    //     Row(
    //       mainAxisSize: MainAxisSize.min,
    //       children: [
    //         ElevatedButton(
    //             // call function exit to logout
    //             onPressed: () => exit(context),
    //             child: const Text("Oui")),
    //         ElevatedButton(
    //             onPressed: () {
    //               Navigator.pop(context);
    //             },
    //             child: const Text("Non"))
    //       ],
    //     ),
    //   ],
    // ));
  }
}
