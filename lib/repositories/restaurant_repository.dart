import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:core/entities.dart';

class RestaurantRepository {
  const RestaurantRepository();
  static FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Restaurant?> fetchRestaurant({required String restaurantId}) async {
    DocumentSnapshot docSnapshot =
        await _firestore.collection('restaurants').doc(restaurantId).get();
    try {
      final data = docSnapshot.data() as Map<String, dynamic>;
      return Restaurant.fromJson(data);
    } catch (err) {
      throw Exception('Failed to fetch the restaurant: $err');
    }
  }

  Future<List<Restaurant>> fetchRestaurants() async {
    final querySnapshot = await _firestore.collection('restaurants').get();  
    try {
      final restaurants = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Restaurant.fromJson(data);
      }).toList();
      return restaurants;
    } catch (err) {
      throw Exception('Failed to fetch the restaurants: $err');
    }
  }

  Future<List<Restaurant>> fetchPopularRestaurants() async {
    return fetchRestaurants();
  }

  Future<List<Restaurant>> fetchFeaturedRestaurants() async {
    return fetchRestaurants();
  }
}

