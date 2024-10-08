
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:food_ordering_app_with_flutter_and_bloc/screens/checkOut/check_out_screen.dart";
import "package:food_ordering_app_with_flutter_and_bloc/shared/widgets/network_Image_withloading.dart";
import "package:food_ordering_app_with_flutter_and_bloc/state/Cart/cart_bloc.dart";

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});
  static double totalPrice = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        actions: [
          BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              if (state is CartLoaded) {
                return Stack(
                  children: [
                    IconButton.filled(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.badge,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                    Positioned(
                        right: 9,
                        top: 4,
                        child: Text(state.items.length.toString(),
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge!
                                .copyWith(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold)))
                  ],
                );
              } else {
                return const SizedBox();
              }
            },
          )
        ],
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CartLoaded) {
            totalPrice = state.items.fold(0, (sum, item) {
              double itemTotal = item.price * item.quantity;
              double extrasTotal = item.extra.fold(
                  0, (extraSum, extra) => extraSum + extra.additionalCost);
              return sum + itemTotal + extrasTotal;
            });

            if (state.items.isEmpty) {
              return const Center(
                child: Text("No item in the Cart"),
              );
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.items.length,
                      itemBuilder: (context, index) {
                        final item = state.items[index];
                        double extraPrice = item.extra.fold(
                            0, (sum, eitem) => sum + eitem.additionalCost);
                        double totalItemPrice =
                            (item.price * item.quantity) + extraPrice;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              NetworkImageWithLoading(
                                imageUrl: item.image,
                                width: 60,
                                height: 60,
                              ),
                              Expanded(
                                child: ListTile(
                                  title: Text(item.name),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      item.extra.isNotEmpty
                                          ? const Text("with extras")
                                          : const Text("No extras"),
                                      Text(
                                          'total: \Br${totalItemPrice.toStringAsFixed(2)}'),
                                    ],
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.remove),
                                        onPressed: () => context
                                            .read<CartBloc>()
                                            .add(
                                              UpdateQuantity(
                                                  item.id, item.quantity - 1),
                                            ),
                                      ),
                                      Text(item.quantity.toString()),
                                      IconButton(
                                        icon: const Icon(Icons.add),
                                        onPressed: () => context
                                            .read<CartBloc>()
                                            .add(
                                              UpdateQuantity(
                                                  item.id, item.quantity + 1),
                                            ),
                                      ),
                                    ],
                                  ),
                                  onLongPress: () => context
                                      .read<CartBloc>()
                                      .add(RemoveFromCart(item.id)),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  state.items.isNotEmpty
                      ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                      const Divider(color: Colors.black,height: 3,endIndent: 10,indent: 20,),    
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Text(
                                ' Order Total '),
                                 Text(
                                '  ${totalPrice.toStringAsFixed(2)} Br',textAlign: TextAlign.start),
                          ],
                        ),
                       const  Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                             Text("Delivery Fee:"),
                             Text("60 Br",textAlign: TextAlign.start),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                           const Text(
                                'Total: '),
                                 Text(
                                '${(totalPrice + 60).toStringAsFixed(2)} Br',textAlign: TextAlign.start,),
                          ],
                        ),
                        const Divider(color: Colors.black,height: 3,endIndent: 10,indent: 20,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                    onPressed: () => {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      CheckOutScreen(
                                                        cartItem: state.items,
                                                        total: totalPrice+60,
                                                      )))
                                        },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.black),
                                    child: Text(
                                      "Place Order",
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge!
                                          .copyWith(color: Colors.white),
                                    )),
                              ],
                            ),
                          ],
                        ),
                      )
                      : const SizedBox()
                ],
              );
            }
          } else if (state is CartError) {
            return Center(
                child: Text(
              state.message,
            ));
          }
          return const Center(child: Text('Something went wrong'));
        },
      ),
    );
  }
}
