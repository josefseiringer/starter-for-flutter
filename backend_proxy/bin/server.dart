import 'dart:async';
import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';
import 'package:http/http.dart' as http;
import 'package:dotenv/dotenv.dart';

void main(List<String> args) async {
  // Load environment variables
  final env = DotEnv()..load();
  final ptvApiKey = env['PTV_API_KEY'] ?? '';

  if (ptvApiKey.isEmpty) {
    print('❌ ERROR: PTV_API_KEY not found in .env file');
    exit(1);
  }

  final port = int.tryParse(env['PORT'] ?? '8080') ?? 8080;
  final host = env['HOST'] ?? '0.0.0.0';

  // Router configuration
  final router = Router();

  // Health check endpoint
  router.get('/health', (Request request) {
    return Response.ok(
        '{"status": "healthy", "service": "PTV Geocoding Proxy"}',
        headers: {'Content-Type': 'application/json'});
  });

  // Geocoding endpoint: /api/geocode?lat=48.22&lng=13.91
  router.get('/api/geocode', (Request request) async {
    try {
      final lat = request.url.queryParameters['lat'];
      final lng = request.url.queryParameters['lng'];
      final language = request.url.queryParameters['language'] ?? 'de';

      if (lat == null || lng == null) {
        return Response.badRequest(
          body: '{"error": "Missing required parameters: lat, lng"}',
          headers: _corsHeaders(),
        );
      }

      // Forward request to PTV API
      final ptvUrl = Uri.parse(
          'https://api.myptv.com/geocoding/v1/locations/by-position/$lat/$lng?language=$language&apiKey=$ptvApiKey');

      print('➡️  Geocode request: lat=$lat, lng=$lng');

      final response = await http.get(
        ptvUrl,
        headers: {'Accept': 'application/json'},
      ).timeout(
        const Duration(seconds: 15),
        onTimeout: () => throw TimeoutException('PTV API timeout'),
      );

      print('✅ PTV Response: ${response.statusCode}');

      return Response(
        response.statusCode,
        body: response.body,
        headers: {
          ..._corsHeaders(),
          'Content-Type': 'application/json; charset=utf-8',
        },
      );
    } catch (e) {
      print('❌ Error: $e');
      return Response.internalServerError(
        body: '{"error": "${e.toString()}"}',
        headers: _corsHeaders(),
      );
    }
  });

  // CORS preflight
  router.options('/<path|.*>', (Request request) {
    return Response.ok('', headers: _corsHeaders());
  });

  // Middleware pipeline
  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(_corsMiddleware())
      .addHandler(router.call);

  // Start server
  final server = await shelf_io.serve(handler, host, port);
  print('🚀 PTV Proxy Server running');
  print('📡 Host: ${server.address.host}');
  print('🔌 Port: ${server.port}');
  print('🌐 URL: http://${server.address.host}:${server.port}');
  print('💚 Health: http://${server.address.host}:${server.port}/health');
  print(
      '🗺️  Geocode: http://${server.address.host}:${server.port}/api/geocode?lat=48.22&lng=13.91');
  print('\n🛑 Press Ctrl+C to stop\n');
}

Map<String, String> _corsHeaders() {
  return {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
    'Access-Control-Allow-Headers':
        'Origin, Content-Type, Accept, Authorization',
    'Access-Control-Max-Age': '86400',
  };
}

Middleware _corsMiddleware() {
  return (Handler handler) {
    return (Request request) async {
      if (request.method == 'OPTIONS') {
        return Response.ok('', headers: _corsHeaders());
      }
      final response = await handler(request);
      return response.change(headers: _corsHeaders());
    };
  };
}
