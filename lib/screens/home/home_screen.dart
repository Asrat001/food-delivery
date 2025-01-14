import 'package:core/value_objects.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_ordering_app_with_flutter_and_bloc/screens/Account/account_screen.dart';
import 'package:food_ordering_app_with_flutter_and_bloc/screens/Cart/cart_screen.dart';
import 'package:food_ordering_app_with_flutter_and_bloc/state/Navigation/navigation_cubit.dart';
import 'package:food_ordering_app_with_flutter_and_bloc/state/Order/order_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:food_ordering_app_with_flutter_and_bloc/utils/utils.dart';
import '../../shared/widgets/custom_action_chip.dart';
import '../../shared/widgets/main_nav_bar.dart';
import '../../shared/widgets/rating_modal.dart';
import '../../shared/widgets/restaurant_preview_card.dart';
import '../../shared/widgets/section_title.dart';
import '../../state/home/home_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
part '_home_app_bar.dart';
part '_home_featured_restaurants.dart';
part '_home_food_categories.dart';
part '_home_popular_restaurants.dart';
part '_home_restaurant_filters.dart';
part '_home_shops_nearby.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomeView();
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});
  static int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit,int>(
      builder: (context, tab) {
        return Scaffold(
          appBar: tab==0 ?const _HomeAppBar():null,
          bottomNavigationBar: const MainNavBar(),
          body: IndexedStack(
            index: tab,
            children: const [
              HomeViewScreen(),
              Center(child: Text("Coming Soon")),
              CartScreen(),
              AccountScreen()
            ],
          ),
        );
      },
    );
  }
}

class HomeViewScreen extends StatelessWidget {
  const HomeViewScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state.status == HomeStatus.initial ||
            state.status == HomeStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.status == HomeStatus.loaded) {
          return const SingleChildScrollView(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(height: 16.0),
                _RestaurantFilters(),
                _FeaturedRestaurants(),
                _PopularRestaurants(),
              ],
            ),
          );
        } else {
          return const Center(child: Text('Something went wrong!'));
        }
      },
    );
  }
}
