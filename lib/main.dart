import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:core/entities.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_ordering_app_with_flutter_and_bloc/repositories/cart_repository.dart';
import 'package:food_ordering_app_with_flutter_and_bloc/screens/Account/account_screen.dart';
import 'package:food_ordering_app_with_flutter_and_bloc/screens/Auth/login_screen.dart';
import 'package:food_ordering_app_with_flutter_and_bloc/screens/checkOut/check_out_screen.dart';
import 'package:food_ordering_app_with_flutter_and_bloc/screens/home/home_screen.dart';
import 'package:food_ordering_app_with_flutter_and_bloc/screens/on_boarding/onboarding_screen.dart';
import 'package:food_ordering_app_with_flutter_and_bloc/state/Auth/auth_bloc.dart';
import 'package:food_ordering_app_with_flutter_and_bloc/state/Cart/cart_bloc.dart';
import 'package:food_ordering_app_with_flutter_and_bloc/state/Navigation/navigation_cubit.dart';
import 'package:food_ordering_app_with_flutter_and_bloc/state/Order/order_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'repositories/food_category_repository.dart';
import 'repositories/restaurant_repository.dart';
import 'shared/theme/app_theme.dart';
import 'state/home/home_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import './repositories/authentication_repository_impl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyAmATwyjEgJDkqf5kR5vLudrtIib4q3g5c",
          appId: "1:527871665604:android:f266a07b7372c3893ef091",
          projectId: "deliveryakilo",
          storageBucket: "deliveryakilo.appspot.com",
          messagingSenderId: ""));

  FirebaseFirestore db = FirebaseFirestore.instance;
  db.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );
  const foodCategoryRepository = FoodCategoryRepository();
  const restaurantRepository = RestaurantRepository();
  const authenticationRepository = AuthenticationRepositoryImpl();
  final prefs = await SharedPreferences.getInstance();
  final onboarding = prefs.getBool("onboarding") ?? false;
  runApp(
    AppScreen(
      foodCategoryRepository: foodCategoryRepository,
      restaurantRepository: restaurantRepository,
      onboarding: onboarding,
      authenticationRepositoryImpl: authenticationRepository,
    ),
  );
}

class AppScreen extends StatelessWidget {
  const AppScreen(
      {super.key,
      required this.foodCategoryRepository,
      required this.restaurantRepository,
      required this.onboarding,
      required this.authenticationRepositoryImpl});

  final FoodCategoryRepository foodCategoryRepository;
  final RestaurantRepository restaurantRepository;
  final bool onboarding;
  final AuthenticationRepositoryImpl authenticationRepositoryImpl;

  @override
  Widget build(BuildContext context) {
  
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: foodCategoryRepository),
        RepositoryProvider.value(value: restaurantRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          // Global scope
          BlocProvider(
            create: (context) =>
                AuthenticationBloc(const AuthenticationRepositoryImpl()),
          ),
          BlocProvider(
            create: (context) => HomeBloc(
              foodCategoryRepository: foodCategoryRepository,
              restaurantRepository: restaurantRepository,
            )..add(LoadHomeEvent()),
            lazy: true,
          ),
          BlocProvider<CartBloc>(
            create: (context) => CartBloc(
              CartRepository(userId: FirebaseAuth.instance.currentUser!.uid),
            )..add(LoadCart()),
            lazy: true,
          ),
          BlocProvider<NavigationCubit>(
            create: (context) => NavigationCubit(),
          ),
          BlocProvider<OrderBloc>(
            create: (context) => OrderBloc(),
          )
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: AppTheme().themeData,
          home: onboarding ? const LoginScreen() : const OnboardingScreen(),
          routes: {
            '/home': (context) => const HomeScreen(),
            '/login': (context) => const LoginScreen(),
            "/account": (context) => const AccountScreen(),
          
          },
        ),
      ),
    );
  }
}
