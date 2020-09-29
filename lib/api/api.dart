import 'dart:convert';
import 'package:http/http.dart' as http;

class CallApi {
  final String _url = 'https://rozoom.com.ua/api/';

  postData(data, apiUrl) async {
    var fullUrl = _url + apiUrl;
    print(fullUrl);
    return await http.post(fullUrl,
        body: jsonEncode(data), headers: _setHeaders());
  }

  getData(apiUrl) async {
    var fullUrl = _url + apiUrl;
    print(fullUrl);
    return await http.get(fullUrl, headers: _setHeaders());
  }

  _setHeaders() => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };

  // _getToken() async {
  //   SharedPreferences localStorage = await SharedPreferences.getInstance();
  //   var token = localStorage.getString('token');
  //   return '?api_token=$token';
  // }
}

Future<http.Response> getData(apiUrl) async {
  const _url = 'https://rozoom.com.ua/api/mobile/auth/google?token=';
  var fullUrl = _url + apiUrl;
  print(fullUrl);
  return await http.get(fullUrl);
}

getResponse(apiUrl) {
  getData(apiUrl).then((response) {
    if (response.statusCode == 200) {
      // print(response.body);
    } else {
      print(response.statusCode);
    }
  }).catchError((error) {
    print(error.toString());
  });
}
