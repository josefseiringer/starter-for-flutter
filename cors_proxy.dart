/// Simple CORS proxy for PTV API during web development
/// Run with: dart run cors_proxy.dart
///
/// This proxy forwards requests to api.myptv.com and adds CORS headers
library;

import 'dart:io';
import 'package:http/http.dart' as http;

void main() async {
  final port = 8010;
  final targetBase = 'https://api.myptv.com/geocoding/v1';

  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, port);
  print('🚀 CORS Proxy running on http://localhost:$port');
  print('📡 Forwarding to: $targetBase');
  print('🛑 Press Ctrl+C to stop\n');

  await for (var request in server) {
    // Build target URL
    final path = request.uri.path;
    final query = request.uri.query;
    final targetUrl = '$targetBase$path${query.isNotEmpty ? '?$query' : ''}';

    print('➡️  ${request.method} ${request.uri}');
    print('📤 Forwarding to: $targetUrl');

    try {
      // Forward request
      final response = await http.get(
        Uri.parse(targetUrl),
        headers: {'Accept': 'application/json'},
      );

      print('✅ Response: ${response.statusCode}\n');

      // Send response with CORS headers
      request.response
        ..statusCode = response.statusCode
        ..headers.set('Access-Control-Allow-Origin', '*')
        ..headers.set('Access-Control-Allow-Methods', 'GET, POST, OPTIONS')
        ..headers.set('Access-Control-Allow-Headers', '*')
        ..headers.contentType = ContentType.json
        ..write(response.body);

      await request.response.close();
    } catch (e) {
      print('❌ Error: $e\n');

      request.response
        ..statusCode = 500
        ..headers.set('Access-Control-Allow-Origin', '*')
        ..headers.contentType = ContentType.json
        ..write('{"error": "${e.toString()}"}');

      await request.response.close();
    }
  }
}
