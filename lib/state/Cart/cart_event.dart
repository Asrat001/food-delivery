part of 'cart_bloc.dart';


abstract class CartEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadCart extends CartEvent {}

class AddToCart extends CartEvent {
  final CartItem item;
  AddToCart(this.item);

  @override
  List<Object?> get props => [item];
}

class RemoveFromCart extends CartEvent {
  final String itemId;
  RemoveFromCart(this.itemId);

  @override
  List<Object?> get props => [itemId];
}

class UpdateQuantity extends CartEvent {
  final String itemId;
  final int newQuantity;
  UpdateQuantity(this.itemId, this.newQuantity);

  @override
  List<Object?> get props => [itemId, newQuantity];
}

