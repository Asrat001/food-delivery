import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_ordering_app_with_flutter_and_bloc/models/profile.dart';
import 'package:food_ordering_app_with_flutter_and_bloc/services/firestore_service.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'authentication_repository.dart';

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  const AuthenticationRepositoryImpl() : super();
  static GoogleSignIn _googleSignIn = GoogleSignIn();
  static FirestoreService _firestoreService = FirestoreService();
  static FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Future<Users?> signIn() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        final UserCredential userCredential =
            await auth.signInWithCredential(credential);
        final user_d = Users(
            name: userCredential.user?.displayName,
            avatar: userCredential.user?.photoURL,
            email: userCredential.user?.email);
        await _firestoreService.saveUser(user_d);
        return user_d;
      } else {
        return null;
      }
    } catch (e) {
      throw Exception('Error signing in: $e');
    }
  }

  Future<Users?> getUserData() async {
    try {
      if (auth.currentUser != null) {
        final user_d = Users(
            name: auth.currentUser?.displayName,
            avatar: auth.currentUser?.photoURL,
            email: auth.currentUser?.email);
        return user_d;
      } else {
        return null;
      }
    } catch (e) {
      throw Exception('Error signing in: $e');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      auth.signOut();
    } catch (e) {
      throw Exception('Error signing out: $e');
    }
  }
}
