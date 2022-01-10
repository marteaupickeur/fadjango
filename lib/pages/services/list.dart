import 'dart:async';
import 'package:http/http.dart' as http;

Future list(url, cookie, sessionid) async {
  if (url != null && cookie != null && sessionid != null) {
    Map<String, String> h = {
      'Cookie': 'csrftoken=$cookie; sessionid=$sessionid',
      'X-CSRFToken': cookie,
    };
    try {
      var response = await http
          .get(Uri.parse(url), headers: h)
          .timeout(const Duration(seconds: 5));
      return response;
    } on TimeoutException {
      return 'Timeout';
    }
  } else {
    return 'Put parameters';
  }
}

//FOR WEB FEATURE
// Future lister(url) async {
//  TODO
// }
