import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_ordering_app_with_flutter_and_bloc/models/profile.dart';
import 'package:food_ordering_app_with_flutter_and_bloc/repositories/authentication_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationRepository _repository;

  AuthenticationBloc(this._repository) : super(AuthenticationInitial()) {
    on<AuthenticationSignInRequested>(_onSignInRequested);
    on<AuthenticationSignOutRequested>(_onSignOutRequested);
    on<AuthenticationInitialize>(_initialize);
    add(AuthenticationInitialize());
  }

  Future<void> _initialize(
      AuthenticationInitialize event, Emitter<AuthenticationState> emit) async {
   emit(AuthenticationLoading());
    try {
      final user = await _repository.getUserData();
      if (user != null) {
        emit(AuthenticationAuthenticated(user));
      } else {
        emit(AuthenticationUnauthenticated());
      }
    } catch (e) {
      emit(AuthenticationError('Initialization failed: $e'));
    }
  }

  Future<void> _onSignInRequested(
    AuthenticationSignInRequested event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(AuthenticationLoading());
    try {
      final user = await _repository.signIn();
      if (user != null) {
        emit(AuthenticationAuthenticated(user));
      } else {
        emit(AuthenticationUnauthenticated());
      }
    } catch (e) {
      emit(AuthenticationError('Sign-in failed: $e'));
    }
  }

  Future<void> _onSignOutRequested(
    AuthenticationSignOutRequested event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(AuthenticationLoading());
    try {
      await _repository.signOut();
      emit(AuthenticationUnauthenticated());
    } catch (e) {
      emit(AuthenticationError('Sign-out failed: $e'));
    }
  }
}
