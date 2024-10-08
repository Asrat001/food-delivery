// ignore_for_file: must_be_immutable

import 'package:core/entities.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_ordering_app_with_flutter_and_bloc/state/Order/order_bloc.dart';

class CheckOutScreen extends StatelessWidget {
  final List<CartItem> cartItem;
  final double total;
  CheckOutScreen({super.key, required this.cartItem, required this.total});
  static String? name = FirebaseAuth.instance.currentUser?.displayName;
  late String location="loading..";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Check out"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(child: Text("Name")),
                Expanded(
                    child: Text(
                  "${name}",
                  textAlign: TextAlign.end,
                ))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(child: Text("Location")),
                Expanded(
                    child: Text(
                  "${location}",
                  textAlign: TextAlign.end,
                ))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(child: Text("Phone Number")),
                Expanded(
                    child: Text(
                  "+251916562124",
                  textAlign: TextAlign.end,
                ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
