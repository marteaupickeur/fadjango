import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fadjango/pages/authentification/deconnexion.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<String?> getUserName() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString('username');
    } on Exception catch (e) {
      print("Error : $e");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false, //remove back button
        title: Align(
            alignment: Alignment.topRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Text(
                //   'Chargement...',
                //   style: TextStyle(color: Colors.black),
                // ),
                FutureBuilder(
                    future: getUserName(),
                    builder: (context, snapshot) {
                      return Text(
                        snapshot.hasData ? snapshot.data.toString() : "No One",
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                      );
                    }),
                const Icon(
                  Icons.person_outline_rounded,
                  color: Colors.black,
                )
              ],
            )),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.logout,
        ),
        onPressed: () => showDialog(
            context: context,
            builder: (context) {
              return const DiologFAB();
            }),
      ),
      body: Center(
          child: SizedBox(
        width: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
                onPressed: () => {Navigator.pushNamed(context, '/question')},
                child: const Text("Questions")),
            const Divider(
              color: Colors.black,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/choice');
                },
                child: const Text("Choix")),
          ],
        ),
      )),
    );
  }
}
