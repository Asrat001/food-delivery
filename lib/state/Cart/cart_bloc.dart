import 'package:bloc/bloc.dart';
import 'package:core/entities.dart';
import 'package:equatable/equatable.dart';
import 'package:food_ordering_app_with_flutter_and_bloc/repositories/cart_repository.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository _cartRepository;
  static double totalPrice = 0;

  CartBloc(this._cartRepository) : super(CartInitial()) {
    on<LoadCart>(_onLoadCart);
    on<AddToCart>(_onAddToCart);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<UpdateQuantity>(_onUpdateQuantity);
  }

  Future<void> _onLoadCart(LoadCart event, Emitter<CartState> emit) async {
    emit(CartLoading());
    try {
      final items = await _cartRepository.getCart();
      totalPrice = items.$2;
      emit(CartLoaded(items.$1));
    } catch (e) {
      emit(CartError('Failed to load cart: $e'));
    }
  }

  double getTotal() {
    return totalPrice;
  }

  Future<void> _onAddToCart(AddToCart event, Emitter<CartState> emit) async {
    final currentState = state;
    if (currentState is CartLoaded) {
      try {
        final updatedItems = List<CartItem>.from(currentState.items);

        final existingItemIndex =
            updatedItems.indexWhere((item) => item.id == event.item.id);

        if (existingItemIndex != -1) {
          updatedItems[existingItemIndex] =
              updatedItems[existingItemIndex].copyWith(
            quantity: updatedItems[existingItemIndex].quantity + 1,
          );
        } else {
          updatedItems.add(event.item);
        }

        await _cartRepository.updateCart(updatedItems);
        emit(CartLoaded(updatedItems));
      } catch (e) {
        emit(CartError('Failed to add item to cart: $e'));
      }
    }
  }

  Future<void> _onRemoveFromCart(
      RemoveFromCart event, Emitter<CartState> emit) async {
    final currentState = state;
    if (currentState is CartLoaded) {
      try {
        final updatedItems = currentState.items
            .where((item) => item.id != event.itemId)
            .toList();
        await _cartRepository.updateCart(updatedItems);
        emit(CartLoaded(updatedItems));
      } catch (e) {
        emit(CartError('Failed to remove item from cart: $e'));
      }
    }
  }

  Future<void> _onUpdateQuantity(
      UpdateQuantity event, Emitter<CartState> emit) async {
    final currentState = state;
    if (currentState is CartLoaded) {
      try {
        final updatedItems = currentState.items
            .map((item) {
              if (item.id == event.itemId) {
                return item.copyWith(quantity: event.newQuantity);
              }
              return item;
            })
            .where((item) => item.quantity > 0)
            .toList();

        await _cartRepository.updateCart(updatedItems);
        emit(CartLoaded(updatedItems));
      } catch (e) {
        emit(CartError('Failed to update item quantity: $e'));
      }
    }
  }
}
