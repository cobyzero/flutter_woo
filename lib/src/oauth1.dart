import 'dart:collection';
import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart' as crypto;
import 'package:dio/dio.dart';
import 'package:flutter_woo/src/query_string.dart';

class OAuth1 {
  late Dio dio;
  final String consumerKey;
  final String consumerSecret;
  final BaseOptions options;

  OAuth1({
    required this.options,
    required this.consumerKey,
    required this.consumerSecret,
  }) {
    dio = Dio(options);
  }

  Future<Response> get(String url) async {
    return await dio.get(getUrl("GET", options.baseUrl + url));
  }

  String getUrl(String method, String url) {
    String token = "";

    bool containsQueryParams = url.contains("?");

    Random rand = Random();
    List<int> codeUnits = List.generate(10, (index) {
      return rand.nextInt(26) + 97;
    });

    /// Random string uniquely generated to identify each signed request
    String nonce = String.fromCharCodes(codeUnits);

    /// The timestamp allows the Service Provider to only keep nonce values for a limited time
    int timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    String parameters =
        "oauth_consumer_key=$consumerKey&oauth_nonce=$nonce&oauth_signature_method=HMAC-SHA1&oauth_timestamp=$timestamp&oauth_token=$token&oauth_version=1.0&";

    if (containsQueryParams == true) {
      parameters = parameters + url.split("?")[1];
    } else {
      parameters = parameters.substring(0, parameters.length - 1);
    }

    Map<dynamic, dynamic> params = QueryString.parse(parameters);
    Map<dynamic, dynamic> treeMap = SplayTreeMap<dynamic, dynamic>();
    treeMap.addAll(params);

    String parameterString = "";

    for (var key in treeMap.keys) {
      parameterString =
          // ignore: prefer_interpolation_to_compose_strings
          "${"$parameterString${Uri.encodeQueryComponent(key)}=" + treeMap[key]}&";
    }

    parameterString = parameterString.substring(0, parameterString.length - 1);

    String baseString =
        "$method&${Uri.encodeQueryComponent(containsQueryParams == true ? url.split("?")[0] : url)}&${Uri.encodeQueryComponent(parameterString)}";

    String signingKey = "$consumerSecret&$token";
    crypto.Hmac hmacSha1 =
        crypto.Hmac(crypto.sha1, utf8.encode(signingKey)); // HMAC-SHA1

    /// The Signature is used by the server to verify the
    /// authenticity of the request and prevent unauthorized access.
    /// Here we use HMAC-SHA1 method.
    crypto.Digest signature = hmacSha1.convert(utf8.encode(baseString));

    String finalSignature = base64Encode(signature.bytes);

    String requestUrl = "";

    if (containsQueryParams == true) {
      requestUrl =
          "${url.split("?")[0]}?$parameterString&oauth_signature=${Uri.encodeQueryComponent(finalSignature)}";
    } else {
      requestUrl =
          "$url?$parameterString&oauth_signature=${Uri.encodeQueryComponent(finalSignature)}";
    }

    return requestUrl;
  }
}
