import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:core/entities.dart';

class CartRepository {
  final FirebaseFirestore _firestore;
  final String userId;

  CartRepository({FirebaseFirestore? firestore, required this.userId})
      : _firestore = firestore ?? FirebaseFirestore.instance;



Future<(List<CartItem>, double)> getCart() async {
  List<CartItem> cart=[];
  try {
    final cartSnapshot = await _firestore.collection('carts').doc(userId).get();
    if (cartSnapshot.exists) {
      final cartData = cartSnapshot.data() as Map<String, dynamic>;
      final List<CartItem> cartItems = (cartData['items'] as List).map((item) {
        // Parse extras
        List<MenuItemOption> extras = (item['extra'] as List?)?.map((e) => MenuItemOption.fromJson(e)).toList() ?? [];
        
        return CartItem(
          id: item['id'],
          name: item['name'],
          price: item['price'].toDouble(),
          quantity: item['quantity'],
          image: item['image'],
          extra: extras,
        );
      }).toList();

      // Calculate total price
      double totalPrice = cartItems.fold(0, (sum, item) {
        double itemTotal = item.price * item.quantity;
        double extrasTotal = item.extra.fold(0, (extraSum, extra) => extraSum + extra.additionalCost);
        return sum + itemTotal + extrasTotal;
      });

      return (cartItems, totalPrice);
    }
    return (cart,0.0);
  } catch (e) {
    
    return (cart, 0.0);
  }
  
}


  Future<void> updateCart(List<CartItem> items) async {
     final cartData = {
      'items': items.map((item) => {
        'id': item.id,
        'name': item.name,
        'price': item.price,
        'quantity': item.quantity,
        'image': item.image,
        'extra': item.extra.map((option) => option.toJson()).toList(),
      }).toList(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
    await _firestore.collection('carts').doc(userId).set(cartData,SetOptions(merge: true));
    
  }
}
