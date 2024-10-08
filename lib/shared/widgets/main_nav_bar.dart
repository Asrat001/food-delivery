import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_ordering_app_with_flutter_and_bloc/state/Navigation/navigation_cubit.dart';
import 'package:go_router/go_router.dart';

class MainNavBar extends StatelessWidget {
  const MainNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return BlocBuilder<NavigationCubit, int>(
      builder: (context, state) {
        return NavigationBar(
          backgroundColor: colorScheme.onPrimary,
          indicatorColor: colorScheme.primary,
          selectedIndex: context.read<NavigationCubit>().state,
          onDestinationSelected: (int index) =>
              {context.read<NavigationCubit>().setTab(index)},
          destinations: const [
            NavigationDestination(
              selectedIcon: Icon(Icons.home_filled),
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.search),
              label: 'Browse',
            ),
            NavigationDestination(
              icon: Icon(Icons.shopping_basket),
              label: 'Cart',
            ),
            NavigationDestination(
              icon: Icon(Icons.person),
              label: 'Account',
            ),
          ],
        );
      },
    );
  }
}
