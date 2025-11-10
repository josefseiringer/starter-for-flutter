import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static final String endpoint = dotenv.get('APPWRITE_PUBLIC_ENDPOINT', fallback: '');
  static final String projectId = dotenv.get('APPWRITE_PROJECT_ID', fallback: '');
  static final String projectName = dotenv.get('APPWRITE_PROJECT_NAME', fallback: '');
  static final String databaseId = dotenv.get('APPWRITE_DATABASE_ID', fallback: '');
  static final String usersCollectionId = dotenv.get('APPWRITE_USERS_COLLECTION_ID', fallback: '');
  
  static final String appwritePublicEndpoint = endpoint;
  static final String appwriteProjectId = projectId;
  static final String appwriteProjectName = projectName;
  static final String appwriteDatabaseId = databaseId;
  static final String appwriteUsersCollectionId = usersCollectionId;

}