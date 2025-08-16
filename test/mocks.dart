import 'package:mockito/annotations.dart';
import 'package:habit_tracker/services/auth_service.dart';
import 'package:habit_tracker/services/database_service.dart';

// The following annotation will be used by build_runner to generate mocks.
@GenerateMocks([AuthService, DatabaseService])
void main() {} // An empty main function is needed for the build_runner
