part of 'auth_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class AuthenticationSignInRequested extends AuthenticationEvent {}

class AuthenticationSignOutRequested extends AuthenticationEvent {}
class AuthenticationInitialize extends AuthenticationEvent {}