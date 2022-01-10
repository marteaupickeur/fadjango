import 'package:fadjango/pages/choix/add.dart';
import 'package:fadjango/pages/choix/choix.dart';
import 'package:fadjango/pages/choix/list.dart';
import 'package:fadjango/pages/home.dart';
import 'package:fadjango/pages/authentification/connexion.dart';
import 'package:fadjango/pages/questions/add.dart';
import 'package:fadjango/pages/questions/choix.dart';
import 'package:fadjango/pages/questions/list.dart';
import 'package:fadjango/pages/splash.dart';
import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/splash',
        routes: {
          '/splash': (context) => const Splash(),
          '/login': (context) => const Login(),
          '/home': (context) => const Home(),
          '/question': (context) => const Question(),
          '/question/list': (context) => const QuestionList(),
          '/question/add': (context) => const AddQuestion(),
          '/choice': (context) => const Choice(),
          '/choice/list': (context) => const ChoiceList(),
          '/choice/add': (context) => const AddChoice(),
        }));
