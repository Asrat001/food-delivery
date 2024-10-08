part of 'order_bloc.dart';

abstract class OrderEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddLocationEvent extends OrderEvent {
  final String location;

  AddLocationEvent({required this.location});

  @override
  List<Object?> get props => [location];
}

class AddNoteEvent extends OrderEvent {
  final String note;
  AddNoteEvent({required this.note});
  @override
  List<Object?> get props => [note];
}

class OrderSubmittedEvent extends OrderEvent {
  final OrderItem order;

  OrderSubmittedEvent({required this.order});

  @override
  List<Object?> get props => [order];
}

class AddTotalPriceEvent extends OrderEvent {
  final double totalPrice;
  AddTotalPriceEvent({required this.totalPrice});
  @override
  List<Object?> get props => [totalPrice];
}
