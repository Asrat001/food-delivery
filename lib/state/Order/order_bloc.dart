import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:core/entities.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderBloc() : super(OrderInitial()) {
    on<OrderEvent>((event, emit) {});
    on<AddLocationEvent>(_onLocationUpdate);
    on<AddNoteEvent>(_onNoteUpdate);
    on<AddTotalPriceEvent>(_onUpdatePrice);
    on<OrderSubmittedEvent>(_submitOrder);
  }
}

void _onLocationUpdate(AddLocationEvent event, Emitter<OrderState> emit) {
  emit(OrderLocationUpdated(location: event.location));
}

void _onNoteUpdate(AddNoteEvent event, Emitter<OrderState> emit) {
  emit(OrderNoteUpdated(note: event.note));
}

void _onUpdatePrice(AddTotalPriceEvent event, Emitter<OrderState> emit) {
  emit(OrderTotalUpdated(total: event.totalPrice));
}

Future<void> _submitOrder(
    OrderSubmittedEvent event, Emitter<OrderState> emit) async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  emit(OrderSubmitting());
  try {
    final orderRef = firestore.collection('orders').doc();
    await orderRef.set({
      'location': event.order.location,
      'items': event.order.items.map((item) => item.toJson()).toList(),
      'totalPrice': event.order.totalPrice.toString(),
      'additionalNotes': event.order.additionalNotes,
    });

    emit(OrderSubmittedSuccess(orderId: orderRef.id));
  } catch (e) {
    emit(OrderSubmittedFailure(message: 'Error submitting order $e'));
  }
}
