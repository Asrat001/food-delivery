import 'package:core/entities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_ordering_app_with_flutter_and_bloc/shared/widgets/network_Image_withloading.dart';
import 'package:food_ordering_app_with_flutter_and_bloc/shared/widgets/section_title.dart';
import 'package:food_ordering_app_with_flutter_and_bloc/state/Cart/cart_bloc.dart';

Future<dynamic> openMenuItemModal(BuildContext context, MenuItem menuItem) {
    
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    List<MenuItemOption> selectedItems = [];
   
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 10,
                right: 10,
                top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NetworkImageWithLoading(
                  imageUrl: menuItem.imageUrl!,
                  height: 125,
                  width: double.infinity,
                ),
                const SizedBox(
                  height: 5,
                ),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                menuItem.name,
                                style: textTheme.headlineLarge,
                              ),
                              Text(
                                menuItem.description ?? "no description",
                                style: textTheme.labelSmall,
                                overflow: TextOverflow.clip,
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text('\$${menuItem.price} ')
                      ],
                    )
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Divider(
                  color: colorScheme.secondary,
                  height: 1,
                ),
                const SizedBox(
                  height: 5,
                ),
                menuItem.options != null
                    ? Column(
                        children: [
                          const SectionTitle(title: "Customization"),
                          ListView.builder(
                              scrollDirection: Axis.vertical,
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: menuItem.options!.length,
                              itemBuilder: (context, index) {
                                final extra = menuItem.options![index];
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(extra.name),
                                        Text(extra.additionalCost.toString()),
                                      ],
                                    ),
                                    StatefulBuilder(
                                      builder: (BuildContext context,
                                          StateSetter setState) {
                                        return Checkbox(
                                          value: selectedItems.contains(
                                              menuItem.options![index]),
                                          onChanged: (bool? value) {
                                            setState(() {
                                              if (value == true) {
                                                selectedItems.add(
                                                    menuItem.options![index]);
                                              } else {
                                                selectedItems.remove(
                                                    menuItem.options![index]);
                                              }
                                            });
                                          },
                                        );
                                      },
                                    )
                                  ],
                                );
                              }),
                        ],
                      )
                    : const SizedBox(),
                const SizedBox(
                  height: 5,
                ),
                menuItem.options != null
                    ? Divider(
                        color: colorScheme.secondary,
                        height: 1,
                      )
                    : const SizedBox(),
                const SectionTitle(title: "special instruction"),
                TextFormField(
                  onTap: () {},
                  decoration: const InputDecoration(
                    hintText: 'Add notes',
                    prefixIcon: Icon(Icons.note_add_outlined),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          final cartItem = CartItem(
                              id: menuItem.id,
                              name: menuItem.name,
                              price: menuItem.price,
                              image: menuItem.imageUrl!,
                              extra: selectedItems,
                              quantity: 1);
                          context.read<CartBloc>().add(AddToCart(cartItem));
                          Navigator.pop(context);
                             if (context.read<CartBloc>().state is CartLoaded) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Added to cart')),
                        );
                      }
                        },
                        style: ElevatedButton.styleFrom(
                            elevation: 0,
                            side: BorderSide.none,
                            backgroundColor: Colors.black),
                        child: Text(
                          "Add to Cart",
                          style: textTheme.labelLarge!
                              .copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }