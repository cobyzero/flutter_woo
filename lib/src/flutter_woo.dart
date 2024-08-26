import 'package:dio/dio.dart';
import 'package:flutter_woo/src/genered_auth.dart';
import 'package:flutter_woo/src/models/product_woo.dart';

class FlutterWoo {
  FlutterWoo._privateConstructor();
  static final FlutterWoo instance = FlutterWoo._privateConstructor();
  late String consumerKey;
  late String consumerSecret;
  late Dio dio;
  Future<void> init({
    required String domain,
    required String consumerKey,
    required String consumerSecret,
    bool isHttps = false,
  }) async {
    this.consumerKey = consumerKey;
    this.consumerSecret = consumerSecret;

    dio = Dio(
      BaseOptions(
        baseUrl: "${isHttps ? "https" : "http"}://$domain/wp-json/wc/v3/",
        queryParameters: {
          "Authorization": GeneredAuth.generateOAuthHeader(
            httpMethod: isHttps ? "https" : "http",
            url: domain,
            consumerKey: consumerKey,
            consumerSecret: consumerSecret,
          ),
        },
      ),
    );
  }

  Future<List<ProductWoo>> getProducts() async {
    try {
      final response = await dio.get("products");

      return (response.data as List)
          .map(
            (e) => ProductWoo.fromJson(e),
          )
          .toList();
    } catch (e) {
      return [];
    }
  }
}
