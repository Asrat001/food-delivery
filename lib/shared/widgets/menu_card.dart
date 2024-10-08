import 'package:core/entities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_ordering_app_with_flutter_and_bloc/shared/widgets/menu_modal.dart';
import 'package:food_ordering_app_with_flutter_and_bloc/shared/widgets/network_Image_withloading.dart';
import 'package:food_ordering_app_with_flutter_and_bloc/state/Cart/cart_bloc.dart';

class MenuItemCard extends StatefulWidget {
  const MenuItemCard(
      {super.key, required this.menuItem, this.hasModal = false});

  final MenuItem menuItem;
  final bool hasModal;

  @override
  State<MenuItemCard> createState() => _MenuItemCardState();
}

class _MenuItemCardState extends State<MenuItemCard> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: widget.hasModal
          ? () => openMenuItemModal(context, widget.menuItem)
          : () => {},
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Material(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.menuItem.name,
                      style: textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text('\$${widget.menuItem.price.toString()}'),
                    Text(
                      widget.menuItem.description ?? '',
                      style: textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8.0),
            Stack(
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: NetworkImageWithLoading(
                      imageUrl: widget.menuItem.imageUrl!,
                      width: 95,
                      height: 95,
                    )),
                Positioned(
                  bottom: 0.0,
                  right: 0.0,
                  child: IconButton.filled(
                    onPressed: () {
                      final cartItem = CartItem(
                          id: widget.menuItem.id,
                          name: widget.menuItem.name,
                          price: widget.menuItem.price,
                          image: widget.menuItem.imageUrl!,
                          quantity: 1,
                          extra: []);
                      context.read<CartBloc>().add(AddToCart(cartItem));
                      if (context.read<CartBloc>().state is CartError) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Error Happened")),
                        );
                      } else if (context.read<CartBloc>().state
                          is CartLoaded) {
                            
                          }
                    },
                    icon: const Icon(Icons.add),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
