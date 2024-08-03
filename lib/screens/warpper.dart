import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_ordering_app_with_flutter_and_bloc/screens/Auth/login_screen.dart';
import 'package:food_ordering_app_with_flutter_and_bloc/state/Auth/auth_bloc.dart';

class AuthenticationWrapper extends StatefulWidget {
  @override
  State<AuthenticationWrapper> createState() => _AuthenticationWrapperState();
}

class _AuthenticationWrapperState extends State<AuthenticationWrapper> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is AuthenticationAuthenticated) {
          if (ModalRoute.of(context)?.settings.name != '/home') {
            Navigator.of(context).pushReplacementNamed('/home');
          }
        }
      },
      child: const LoginScreen()
  
    );
  }
}
