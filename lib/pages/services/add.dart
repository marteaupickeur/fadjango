import 'dart:async';

import 'package:http/http.dart' as http;

Future add(url, body, cookie, sessionid) async {
  if (url != null && body != null && cookie != null) {
    Map<String, String> h = {
      'Cookie': 'csrftoken=$cookie; sessionid=$sessionid',
      'X-CSRFToken': cookie,
    };

    try {
      var response = await http
          .post(Uri.parse(url), body: body, headers: h)
          .timeout(const Duration(seconds: 5));
      return response;
    } on TimeoutException {
      return 'Timeout';
    }
  } else {
    return 'Put parameters';
  }
}

// FOR WEB FEATURE
// Future add()async{
  // TODO
// }