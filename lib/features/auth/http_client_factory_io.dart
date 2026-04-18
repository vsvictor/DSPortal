import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:cronet_http/cronet_http.dart' show CronetClient, CronetEngine;
import 'package:cupertino_http/cupertino_http.dart' show CupertinoClient, URLSessionConfiguration;

http.Client getClient() {
  if (Platform.isAndroid) {
    final engine = CronetEngine.build(
      enableQuic: true,
      enableHttp2: true,
      enableBrotli: true,
    );
    return CronetClient.fromCronetEngine(engine);
  } else if (Platform.isIOS || Platform.isMacOS) {
    // Включаємо HTTP/3 (QUIC) для Apple платформ
    final config = URLSessionConfiguration.ephemeralSessionConfiguration()
      ..allowsCellularAccess = true;
    return CupertinoClient.fromSessionConfiguration(config);
  } else {
    return http.Client();
  }
}
