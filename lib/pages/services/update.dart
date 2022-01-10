import 'dart:async';

import 'package:http/http.dart' as http;

Future update(url, id, body, cookie, sessionid) async {
  if (url != null &&
      id != null &&
      cookie != null &&
      sessionid != null &&
      body != null) {
    Map<String, String> h = {
      'Cookie': 'csrftoken=$cookie; sessionid=$sessionid',
      'X-CSRFToken': '$cookie'
    };

    try {
      final response = await http
          .put(Uri.parse('$url$id/'), body: body, headers: h)
          .timeout(const Duration(seconds: 5));
      return response;
    } on TimeoutException {
      return 'Timeout';
    }
  } else {
    return 'Put parameters';
  }
}
