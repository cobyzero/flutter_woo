import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';

class GeneredAuth {
  static String generateOAuthHeader({
    required String httpMethod,
    required String url,
    required String consumerKey,
    required String consumerSecret,
    Map<String, String>? additionalParams,
  }) {
    // Generar parámetros básicos de OAuth
    final timestamp =
        (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString();
    final nonce =
        base64Encode(List<int>.generate(32, (index) => Random().nextInt(256)))
            .replaceAll('=', '')
            .replaceAll('+', '')
            .replaceAll('/', '');

    final params = {
      'oauth_consumer_key': consumerKey,
      'oauth_nonce': nonce,
      'oauth_signature_method': 'HMAC-SHA1',
      'oauth_timestamp': timestamp,
      'oauth_version': '1.0',
      ...?additionalParams,
    };

    // Ordenar parámetros por clave
    final sortedParams = Map<String, String>.fromEntries(
      params.entries.toList()..sort((e1, e2) => e1.key.compareTo(e2.key)),
    );

    // Crear base string
    final parameterString = sortedParams.entries
        .map((e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
    final baseString =
        '${httpMethod.toUpperCase()}&${Uri.encodeComponent(url)}&${Uri.encodeComponent(parameterString)}';

    // Crear key para la firma (sin token secret)
    final signingKey = '${Uri.encodeComponent(consumerSecret)}&';

    // Generar la firma usando HMAC-SHA1
    final hmacSha1 = Hmac(sha1, utf8.encode(signingKey));
    final signature =
        base64Encode(hmacSha1.convert(utf8.encode(baseString)).bytes);

    // Agregar la firma a los parámetros
    sortedParams['oauth_signature'] = signature;

    // Crear el encabezado de autorización
    final authHeader = sortedParams.entries
        .map((e) =>
            '${Uri.encodeComponent(e.key)}="${Uri.encodeComponent(e.value)}"')
        .join(', ');

    return 'OAuth $authHeader';
  }
}
