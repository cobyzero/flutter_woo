import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_woo_method_channel.dart';

abstract class FlutterWooPlatform extends PlatformInterface {
  /// Constructs a FlutterWooPlatform.
  FlutterWooPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterWooPlatform _instance = MethodChannelFlutterWoo();

  /// The default instance of [FlutterWooPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterWoo].
  static FlutterWooPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterWooPlatform] when
  /// they register themselves.
  static set instance(FlutterWooPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
