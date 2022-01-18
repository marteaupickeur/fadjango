import 'package:flutter/material.dart';

class Splash extends StatelessWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(28.0),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'fadjango as FIRST APP DJANGO \n\n A Flutter App wich use the API of my firstapp(A backend app develop with django) \n\n Without Test, only CRUD request',
              style: TextStyle(fontSize: 14),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 28.0),
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text('fadjano'),
                      Icon(Icons.arrow_forward_ios_sharp)
                    ],
                  )),
            )
          ],
        ),
      ),
    ));
  }
}
