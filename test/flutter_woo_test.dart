import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_woo/flutter_woo.dart';
import 'package:flutter_woo/flutter_woo_platform_interface.dart';
import 'package:flutter_woo/flutter_woo_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterWooPlatform
    with MockPlatformInterfaceMixin
    implements FlutterWooPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterWooPlatform initialPlatform = FlutterWooPlatform.instance;

  test('$MethodChannelFlutterWoo is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterWoo>());
  });

  test('getPlatformVersion', () async {
    FlutterWoo flutterWooPlugin = FlutterWoo();
    MockFlutterWooPlatform fakePlatform = MockFlutterWooPlatform();
    FlutterWooPlatform.instance = fakePlatform;

    expect(await flutterWooPlugin.getPlatformVersion(), '42');
  });
}
