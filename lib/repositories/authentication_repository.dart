import 'package:food_ordering_app_with_flutter_and_bloc/models/profile.dart';

abstract class AuthenticationRepository {
  const AuthenticationRepository();

  Future<Users?> signIn();
  Future<Users?> getUserData();
  Future<void> signOut();
}
