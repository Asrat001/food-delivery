
import 'package:flutter_bloc/flutter_bloc.dart';

// enum NavigationTab { home, cart, profile }

class NavigationCubit extends Cubit<int> {
  NavigationCubit() : super(0);

  void setTab(int tab) => emit(tab);
}