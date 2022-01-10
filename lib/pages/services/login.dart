// import 'dart:html';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:async';

Future login(url, body) async {
  if (url != null && body != null) {
    try {
      final response = await http
          .post(Uri.parse(url), body: body)
          .timeout(const Duration(seconds: 5));
      return response;
    } on TimeoutException {
      return "Timeout";
    }
  } else {
    return 'Put parameters';
  }
}
