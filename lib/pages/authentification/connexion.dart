// import 'dart:html' as html; // FOR WEB FEATURE
import 'package:fadjango/utils/urls.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fadjango/pages/services/login.dart';
import 'package:fadjango/utils/splitCookie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_platform/universal_platform.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  final _username = TextEditingController();
  final _password = TextEditingController();
  var body = {};
  final url = loginUrl;
  // html.window.session

  void validate() {
    if (_formKey.currentState!.validate()) {
      body = {"username": _username.text, "password": _password.text};

      recoverdata() async {
        setState(() {
          isLoading = true;
        });
        try {
          final response = await login(url, body);
          if (response is http.Response) {
            if (response.statusCode == 200) {
              if (UniversalPlatform.isLinux || UniversalPlatform.isAndroid) {
                Map cookie_session = crsftoken(response.headers['set-cookie']);
                SharedPreferences prefs = await SharedPreferences.getInstance();

                await prefs.setString('cookie', cookie_session['0']);
                await prefs.setString('username', _username.text);
                await prefs.setString('sessionid', cookie_session['1']);

                // Navigation to home
                Navigator.pushNamed(context, "/home");
              }
              // FOR WEB FEATURE
              // if (UniversalPlatform.isWeb) {
              //   Navigator.pushNamed(context, "/home");
              // }
              setState(() {
                isLoading = false;
              });
            } else {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Identifiants invalides'),
              ));
              setState(() {
                isLoading = false;
              });
            }
          }
          if (response == 'Timeout') {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Echec connexion trop long !'),
            ));
            setState(() {
              isLoading = false;
            });
          }
          if (response == 'Put parameters') {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Ajouter des paramètres !'),
            ));
            setState(() {
              isLoading = false;
            });
          }
        } on Exception catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Error : $e'),
          ));
          setState(() {
            isLoading = false;
          });
        }
      }

      recoverdata();
    }
  }

  cleanSP() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cleanSP();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /* appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Connexion',
          style: TextStyle(
            color: Colors.blue,
            fontSize: 40,
          ),
        ),
        centerTitle: true,
      ), */
      body: Padding(
        padding: EdgeInsets.all(18),
        child: Center(
          child: SizedBox(
            width: 500,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextFormField(
                    controller: _username,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez renseigner ce champ !';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Username',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 18, 0, 10),
                    child: TextFormField(
                      controller: _password,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez renseigner ce champ !';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Password',
                      ),
                      obscureText: true,
                    ),
                  ),
                  /* TextButton(
                    style: TextButton.styleFrom(padding: EdgeInsets.all(0)),
                    onPressed: () => {},
                    child: const Text(
                      "mot de passe oublié",
                      style: TextStyle(color: Colors.black),
                    ),
                  ), */
                  Padding(
                    padding: const EdgeInsets.only(top: 18.0),
                    child: ElevatedButton(
                        onPressed: validate,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text("Valider"),
                        )),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
