import 'package:intl/intl.dart';
import 'package:appwrite/appwrite.dart';
import '../../data/models/log.dart';
import '../../data/models/project_info.dart';
import '../../config/environment.dart';

/// A repository responsible for handling network interactions with the Appwrite server.
///
/// It provides a helper method to ping the server.
class AppwriteRepository {
  static const String pingPath = "/ping";
  static final String appwriteProjectId = Environment.appwriteProjectId;
  static final String appwriteProjectName = Environment.appwriteProjectName;
  static final String appwriteDatabaseId = Environment.appwriteDatabaseId;
  static final String appwriteUsersCollectionId =
      Environment.appwriteUsersCollectionId;
  static final String appwritePublicEndpoint =
      Environment.appwritePublicEndpoint;

  final Client _client = Client()
      .setProject(appwriteProjectId)
      .setEndpoint(appwritePublicEndpoint);

  late final Account _account;
  late final Databases _databases;

  AppwriteRepository._internal() {
    _account = Account(_client);
    _databases = Databases(_client);
  }

  static final AppwriteRepository _instance = AppwriteRepository._internal();

  /// Singleton instance getter
  factory AppwriteRepository() => _instance;

  ProjectInfo getProjectInfo() {
    return ProjectInfo(
      endpoint: appwritePublicEndpoint,
      projectId: appwriteProjectId,
      projectName: appwriteProjectName,
    );
  }

  /// Pings the Appwrite server and captures the response.
  ///
  /// @return [Log] containing request and response details.
  Future<Log> ping() async {
    try {
      final response = await _client.ping();

      return Log(
        date: _getCurrentDate(),
        status: 200,
        method: "GET",
        path: pingPath,
        response: {'message': response},
      );
    } on AppwriteException catch (error) {
      return Log(
        date: _getCurrentDate(),
        status: error.code ?? 500,
        method: "GET",
        path: pingPath,
        response: {'error': error.message ?? "Unknown error"},
      );
    }
  }

  /// Registriert einen neuen Benutzer.
  Future<Log> signUp(String email, String password, String name) async {
    try {
      final response = await _account.create(
        userId: 'unique()',
        email: email,
        password: password,
        name: name,
      );
      return Log(
        date: _getCurrentDate(),
        status: 201,
        method: "POST",
        path: "/account",
        response: response.toMap(),
      );
    } on AppwriteException catch (error) {
      return Log(
        date: _getCurrentDate(),
        status: error.code ?? 500,
        method: "POST",
        path: "/account",
        response: {'error': error.message ?? "Unknown error"},
      );
    }
  }

  /// Meldet einen Benutzer an.
  Future<Log> login(String email, String password) async {
    try {
      final response = await _account.createEmailPasswordSession(
        email: email,
        password: password,
      );
      return Log(
        date: _getCurrentDate(),
        status: 200,
        method: "POST",
        path: "/account/sessions",
        response: response.toMap(),
      );
    } on AppwriteException catch (error) {
      return Log(
        date: _getCurrentDate(),
        status: error.code ?? 500,
        method: "POST",
        path: "/account/sessions",
        response: {'error': error.message ?? "Unknown error"},
      );
    }
  }

  /// Erstellt ein neues Dokument.
  Future<Log> createDocument(
      String collectionId, Map<String, dynamic> data) async {
    try {
      final response = await _databases.createDocument(
        databaseId: appwriteDatabaseId,
        collectionId: collectionId,
        documentId: 'unique()',
        data: data,
      );
      return Log(
        date: _getCurrentDate(),
        status: 201,
        method: "POST",
        path:
            "/databases/$appwriteDatabaseId/collections/$collectionId/documents",
        response: {'id': response.$id},
      );
    } on AppwriteException catch (error) {
      return Log(
        date: _getCurrentDate(),
        status: error.code ?? 500,
        method: "POST",
        path:
            "/databases/$appwriteDatabaseId/collections/$collectionId/documents",
        response: {'error': error.message ?? "Unknown error"},
      );
    }
  }

  /// Listet alle Dokumente einer Collection auf.
  Future<Log> listDocuments(String collectionId) async {
    try {
      final response = await _databases.listDocuments(
        databaseId: appwriteDatabaseId,
        collectionId: collectionId,
      );
      return Log(
        date: _getCurrentDate(),
        status: 200,
        method: "GET",
        path:
            "/databases/$appwriteDatabaseId/collections/$collectionId/documents",
        response: response.toMap(),
      );
    } on AppwriteException catch (error) {
      return Log(
        date: _getCurrentDate(),
        status: error.code ?? 500,
        method: "GET",
        path:
            "/databases/$appwriteDatabaseId/collections/$collectionId/documents",
        response: {'error': error.message ?? "Unknown error"},
      );
    }
  }

  /// Aktualisiert ein Dokument.
  Future<Log> updateDocument(
      String collectionId, String documentId, Map<String, dynamic> data) async {
    try {
      final response = await _databases.updateDocument(
        databaseId: appwriteDatabaseId,
        collectionId: collectionId,
        documentId: documentId,
        data: data,
      );
      return Log(
        date: _getCurrentDate(),
        status: 200,
        method: "PATCH",
        path:
            "/databases/$appwriteDatabaseId/collections/$collectionId/documents/$documentId",
        response: response.toMap(),
      );
    } on AppwriteException catch (error) {
      return Log(
        date: _getCurrentDate(),
        status: error.code ?? 500,
        method: "PATCH",
        path:
            "/databases/$appwriteDatabaseId/collections/$collectionId/documents/$documentId",
        response: {'error': error.message ?? "Unknown error"},
      );
    }
  }

  /// Löscht ein Dokument.
  Future<Log> deleteDocument(String collectionId, String documentId) async {
    try {
      await _databases.deleteDocument(
        databaseId: appwriteDatabaseId,
        collectionId: collectionId,
        documentId: documentId,
      );
      return Log(
        date: _getCurrentDate(),
        status: 204,
        method: "DELETE",
        path:
            "/databases/$appwriteDatabaseId/collections/$collectionId/documents/$documentId",
        response: {"message": "Document deleted successfully"},
      );
    } on AppwriteException catch (error) {
      return Log(
        date: _getCurrentDate(),
        status: error.code ?? 500,
        method: "DELETE",
        path:
            "/databases/$appwriteDatabaseId/collections/$collectionId/documents/$documentId",
        response: {'error': error.message ?? "Unknown error"},
      );
    }
  }

  /// Meldet den aktuellen Benutzer ab (löscht die Session).
  Future<Log> logout() async {
    try {
      await _account.deleteSession(sessionId: 'current');
      return Log(
        date: _getCurrentDate(),
        status: 204,
        method: "DELETE",
        path: "/account/sessions/current",
        response: {"message": "Logged out successfully"},
      );
    } on AppwriteException catch (error) {
      return Log(
        date: _getCurrentDate(),
        status: error.code ?? 500,
        method: "DELETE",
        path: "/account/sessions/current",
        response: {'error': error.message ?? "Unknown error"},
      );
    }
  }

  /// Retrieves the current date in the format "MMM dd, HH:mm".
  ///
  /// @return [String] A formatted date.
  String _getCurrentDate() {
    return DateFormat("MMM dd, HH:mm").format(DateTime.now());
  }
}
