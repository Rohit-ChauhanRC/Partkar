import 'package:http/http.dart' as http;
import '../utilities/constants.dart';
import 'dart:convert';

class ApiProvider {
  static const String BASE_URL = Constants.BASE_URL;

  Future<Map<String, dynamic>> getData(String path,
      {Map<String, String> headers = const {}}) async {
    final url = '$BASE_URL$path';
    print('GET URL: $url');
    // print('GET headers: $headers');
    final response = await http.get(Uri.parse(url), headers: headers);
    Map<String, dynamic> res = json.decode(response.body);
    return res;
  }

  Future<Map<String, dynamic>> postData(String path,
      {Map<String, String> headers = const {},
      Map<String, dynamic> body = const {}}) async {
    final url = '$BASE_URL$path';
    Map<String, String> _headers = Map.of(headers);
    _headers['content-type'] = 'application/json';
    print('POST URL: $url');
    // print('POST headers: $_headers');
    print('POST params: $body');
    final response = await http.post(Uri.parse(url),
        headers: _headers, body: jsonEncode(body));
    // print('THE RESPONSE');
    // print(response.body);
    Map<String, dynamic> res = json.decode(response.body);
    return res;
  }

  // Future<Map<String, dynamic>> patchData(String path,
  //     {Map<String, String> headers = const {},
  //     Map<String, dynamic> body = const {}}) async {
  //   final url = '$BASE_URL$path';
  //   Map<String, String> _headers = Map.of(headers);
  //   _headers['content-type'] = 'application/json';
  //   print('URL: $url');
  //   print('PATCH headers: $_headers');
  //   print('PATCH params: $body');
  //   final response = await http.patch(Uri.parse(url),
  //       headers: _headers, body: jsonEncode(body));
  //   Map<String, dynamic> res = json.decode(response.body);
  //   return res;
  // }

  Future<Map<String, dynamic>> updateProfile(String path,
      {Map<String, String> headers = const {},
      Map<String, dynamic> body = const {},
      String imagePath}) async {
    final url = '$BASE_URL$path';
    Map<String, String> _headers = Map.of(headers);
    _headers['content-type'] = 'application/json';
    print('POST URL: $url');
    // print('POST headers: $_headers');
    print('POST params: $body');

    final request = http.MultipartRequest('POST', Uri.parse(url));
    request.headers.addAll(_headers);
    body.forEach((key, value) {
      request.fields[key] = value;
    });
    if (imagePath != null) {
      final image =
          await http.MultipartFile.fromPath('profile_image', imagePath);
      request.files.add(image);
    }

    final response = await request.send();
    final responseData = await response.stream.toBytes();
    final responseString = String.fromCharCodes(responseData);
    Map<String, dynamic> res = json.decode(responseString);
    return res;

    // final response = await http.post(Uri.parse(url),
    //     headers: _headers, body: jsonEncode(body));
    // print('THE RESPONSE');
    // print(response.body);
    // Map<String, dynamic> res = json.decode(response.body);
    // return res;
  }
}
