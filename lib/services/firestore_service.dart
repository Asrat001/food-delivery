import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_ordering_app_with_flutter_and_bloc/models/profile.dart';


class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveUser(Users user) async {
    try {
      await _firestore.collection('User').doc(user.email).set({
        'name': user.name,
        'email': user.email,
        'avatar': user.avatar,
      });
    } catch (e) {
      throw Exception('Error saving user to Firestore: $e');
    }
  }
}
