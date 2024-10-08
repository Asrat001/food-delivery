
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:food_ordering_app_with_flutter_and_bloc/state/Auth/auth_bloc.dart";

class AccountScreen extends StatelessWidget {
   
  const AccountScreen({super.key,});
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          if (state is AuthenticationUnauthenticated) {
            if (ModalRoute.of(context)?.settings.name != '/login') {
              Navigator.of(context).pushReplacementNamed('/login');
            }
          }
        },
        builder: (context, state) {
          return Center(
            child: ElevatedButton(
              onPressed: () {
                context
                    .read<AuthenticationBloc>()
                    .add(AuthenticationSignOutRequested());
              },
              child: Text("logout"),
            ),
          );
        },
      ),
    );
  }
}
