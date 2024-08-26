import 'package:dio/dio.dart';
import 'package:flutter_woo/src/models/product_woo.dart';
import 'package:flutter_woo/src/oauth1.dart';

class FlutterWoo {
  FlutterWoo._privateConstructor();
  static final FlutterWoo instance = FlutterWoo._privateConstructor();
  late String consumerKey;
  late String consumerSecret;
  late OAuth1 auth;

  Future<void> init({
    required String domain,
    required String consumerKey,
    required String consumerSecret,
    bool isHttps = false,
  }) async {
    this.consumerKey = consumerKey;
    this.consumerSecret = consumerSecret;

    auth = OAuth1(
      consumerKey: consumerKey,
      consumerSecret: consumerSecret,
      options: BaseOptions(
        baseUrl: "http://localhost/wp-json/wc/v3/",
      ),
    );
  }

  Future<List<ProductWoo>> getProducts() async {
    final response = await auth.get(
      "products",
    );

    return (response.data as List)
        .map(
          (e) => ProductWoo.fromJson(e),
        )
        .toList();
  }
}
