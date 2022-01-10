import 'dart:async';

import 'package:http/http.dart' as http;

Future delete(url, id, cookie, sessionid) async {
  if (url != null && id != null) {
    Map<String, String> h = {
      'Cookie': 'csrftoken=$cookie; sessionid=$sessionid',
      'X-CSRFToken': cookie
    };
    try {
      final response = await http
          .delete(Uri.parse('$url$id/'), headers: h)
          .timeout(const Duration(seconds: 5));
      return response;
    } on TimeoutException {
      return 'Timeout';
    }
  } else {
    return 'Put parameters';
  }
}
