part of 'home_screen.dart';

class _HomeAppBar extends StatefulWidget implements PreferredSizeWidget {
  const _HomeAppBar();
  @override
  Size get preferredSize => const Size.fromHeight(128.0);
  @override
  State<_HomeAppBar> createState() => _HomeAppBarState();
}

class _HomeAppBarState extends State<_HomeAppBar> {
  late Position _currentPosition;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return AppBar(
      systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.white30, statusBarBrightness: Brightness.dark),
      toolbarHeight: 80.0,
      title: TextButton(
        onPressed: () => {
          Utils.showDialogBox(context, "Where is your delivery Address",
              () => {getCurrentLocation()})
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Deliver now',
              style: textTheme.bodyLarge,
            ),
            Row(
              children: [
                Text(
                  'Your location',
                  style: textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(
                  Icons.expand_more,
                  color: colorScheme.onBackground,
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        Switch(
          value: true,
          onChanged: (value) {},
          thumbIcon: const MaterialStatePropertyAll(
              // true ?
              Icon(Icons.delivery_dining)
              //  : Icon(Icons.shopping_cart),
              ),
        ),
        const SizedBox(width: 8.0),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(48.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0).copyWith(
            bottom: 4.0,
          ),
          child: TextFormField(
            onTap: () {},
            decoration: const InputDecoration(
              hintText: 'Search for restaurants, dishes...',
              prefixIcon: Icon(Icons.search),
            ),
          ),
        ),
      ),
    );
  }

  getCurrentLocation() {
    print("hey");
    Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best,
            forceAndroidLocationManager: true)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });
    }).catchError((e) {
      print(e);
    });
  }
}
