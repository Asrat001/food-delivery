part of 'order_bloc.dart';

abstract class OrderState extends Equatable {
  @override
  List<Object?> get props => [];
}

class OrderInitial extends OrderState {}

class OrderLocationUpdated extends OrderState {
  final String location;

  OrderLocationUpdated({required this.location});

  @override
  List<Object?> get props => [location];
}

class OrderNoteUpdated extends OrderState {
  final String note;
  OrderNoteUpdated({required this.note});
  @override
  List<Object?> get props => [note];
}

class OrderTotalUpdated extends OrderState {
  final double total;
  OrderTotalUpdated({required this.total});
  @override
  List<Object?> get props => [total];
}

class OrderSubmitting extends OrderState {
  @override
  List<Object?> get props => [];
}

class OrderSubmittedSuccess extends OrderState {
  final String orderId;

  OrderSubmittedSuccess({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}

class OrderSubmittedFailure extends OrderState {
  final String message;

  OrderSubmittedFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
