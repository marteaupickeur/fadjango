// import 'dart:html'; // FOR WEB FEATURE
import 'package:http/http.dart' as http;
import 'dart:async';

Future logout(url, cookie, sessionid) async {
  if (url != null && cookie != null && sessionid != null) {
    Map<String, String> h = {
      'Cookie': 'csrftoken=$cookie; sessionid=$sessionid',
      'X-CSRFToken': cookie,
    };
    try {
      final response = await http
          .post(Uri.parse(url), headers: h)
          .timeout(const Duration(seconds: 5));
      return response;
    } on TimeoutException {
      return "Timeout";
    }
  } else {
    return 'Put parameters';
  }
}

//FOR WEB FEATURE
// Future logout(url) async {
//   if (url != null) {
//     try {
//       final response =
//           await http.post(Uri.parse(url)).timeout(const Duration(seconds: 5));
//       return response;
//     } on TimeoutException {
//       return "Timeout";
//     }
//   } else {
//     return 'Put parameters';
//   }
// }
