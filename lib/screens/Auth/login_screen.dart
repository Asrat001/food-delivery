import "package:flutter/material.dart";
import 'package:food_ordering_app_with_flutter_and_bloc/screens/home/home_screen.dart';
import 'package:food_ordering_app_with_flutter_and_bloc/state/Auth/auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          if (state is AuthenticationError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
          if (state is AuthenticationAuthenticated) {
            if (ModalRoute.of(context)?.settings.name != '/home') {
              Navigator.of(context).pushReplacementNamed('/home');
            }
          }
        },
        builder: (context, state) {
          if (state is AuthenticationLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AuthenticationAuthenticated) {
            return const HomeScreen();
          } else {
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/images/login.png"),
                  const SizedBox(
                    height: 15,
                  ),
                  RichText(
                      text: TextSpan(
                          text: "Delivery",
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                  fontWeight: FontWeight.bold, fontSize: 28),
                          children: [
                        TextSpan(
                          text: "ReImagined",
                          style: Theme.of(context).textTheme.bodySmall,
                        )
                      ])),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Expanded(
                          flex: 1,
                          child: ElevatedButton(
                              onPressed: () {
                                context
                                    .read<AuthenticationBloc>()
                                    .add(AuthenticationSignInRequested());
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/images/google_logo.png",
                                    width: 28,
                                    height: 28,
                                  ),
                                  Text(
                                    "Login",
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge!
                                        .copyWith(color: Colors.white),
                                  )
                                ],
                              ))),
                    ],
                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
