import 'dart:convert';
import 'dart:typed_data';
import 'package:warehouse/constants/url_constant.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

class ApiResponse {
  final bool isSuccess;
  final dynamic body;

  http.Response response;

  ApiResponse({
    required this.body,
    required this.isSuccess,
    required this.response,
  });
}

String formatJsonString(String jsonString) {
  final decoded = jsonDecode(jsonString);
  const encoder = JsonEncoder.withIndent('  ');
  return encoder.convert(decoded);
}

String formatJson(dynamic json) {
  const encoder = JsonEncoder.withIndent('  ');
  return encoder.convert(json);
}

Future<ApiResponse> postService(String url, dynamic body) async {
  var request_body = jsonEncode(body);

  http.Response response = await http.post(
    Uri.parse(url),
    headers: {"Content-Type": "application/json"},
    body: request_body,
  );

  var reponseBody = response.statusCode == 200
      ? jsonDecode(response.body)
      : response.body;

  final payload = request_body.length > 100
      ? 'Playload is large'
      : request_body;
  // if(Platform.isAndroid){

  print(
    'Status Code: ${response.statusCode} \nURL: $url \n Payload: ${formatJson(payload)}\n  \n Response Body:\n \t${formatJson(reponseBody)}',
  );
  // }
  return ApiResponse(
    body: reponseBody,
    isSuccess: response.statusCode == 200,
    response: response,
  );
}

Future<ApiResponse> getService(String url) async {
  http.Response response = await http.get(Uri.parse(url));
  var reponseBody = response.statusCode == 200
      ? jsonDecode(response.body)
      : response.body;
  return ApiResponse(
    body: reponseBody,
    isSuccess: response.statusCode == 200,
    response: response,
  );
}

Future<http.MultipartFile> getMultiParts(
  Uint8List fileBytes, [
  String name = 'image.png',
]) async {
  return http.MultipartFile.fromBytes('image', fileBytes, filename: name);
}

postWithProgress({
  required String url,
  required dynamic body,
  required void Function(int, int) progressCallback,
  required void Function(dynamic) onComplete,
}) async {
  final dio = Dio();
  var request_body = jsonEncode(body);

  try {
    final response = await dio.post(
      url,
      data: request_body,
      options: Options(headers: {'Content-Type': 'application/json'}),
      onSendProgress: (count, total) {
        progressCallback(count, total);
      },
    );

    if (response.statusCode == 200) {
      onComplete(response.data);
    } else {
      throw Exception('Failed to post data');
    }
  } catch (e) {
    throw Exception('Failed to post data: $e');
  }
}

insertScreen(
  int user_id,
  String screenName,
  int reference_id,
  String event_name,
) async {
  var body = {
    "user_id": user_id,
    "screen": screenName,
    "reference_id": reference_id,
    "event_name": event_name,
  };
  await postService(URL_SCREEN_RECORD, body);
}

Future<ApiResponse> postBytesService(
  String url,
  Uint8List bytes, [
  String fileName = 'sample',
]) async {
  var uri = Uri.parse(url);

  var request = http.MultipartRequest("POST", uri);

  request.files.add(
    http.MultipartFile.fromBytes(
      "file", // must match backend field name
      bytes,
      filename: fileName,
    ),
  );

  var responseStream = await request.send();

  http.Response response = await http.Response.fromStream(responseStream);

  var reponseBody = response.statusCode == 200
      ? jsonDecode(response.body)
      : response.body;

  // print(
  //   'Status Code: ${response.statusCode} \nURL: $url \n Payload: binary\n  \n Response Body:\n \t${formatJson(reponseBody)}',
  // );

  return ApiResponse(
    isSuccess: response.statusCode == 200,
    body: reponseBody,
    response: response,
  );
}
