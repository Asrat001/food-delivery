part of 'home_screen.dart';

class _HomeAppBar extends StatefulWidget implements PreferredSizeWidget {
  const _HomeAppBar();
  @override
  Size get preferredSize => const Size.fromHeight(128.0);
  @override
  State<_HomeAppBar> createState() => _HomeAppBarState();
}

class _HomeAppBarState extends State<_HomeAppBar> {
  late Position? _currentPosition;
  late String? locationAddress = "no Address";

  @override
  void initState() {
    getCurrentLocation();
    super.initState();
  }

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
              'Delivery  location',
              style: textTheme.bodyLarge,
            ),
            Row(
              children: [
                Text(
                  ' ${locationAddress!}',
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

  Future<void> getCurrentLocation() async {
    final status = await Permission.location.request();
    if (status.isGranted) {
      try {
        final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
          forceAndroidLocationManager: true,
        );
        if (mounted) {
      
          setState(() {
            _currentPosition = position;
          });
          getAddressFromLatLng(
            _currentPosition?.latitude,
            _currentPosition?.longitude,
          );
        }
      } catch (e) {
        print('Error getting location: $e');
      }
    } else if (status.isDenied) {
      print('Location permission denied');
    }
  }

  Future<void> getAddressFromLatLng(double? lat, double? lng) async {
    if (lat == null || lng == null) return;
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        final place = placemarks[0];
        final address = "${place.street}, ${place.subLocality}";
        if (mounted) {
          setState(() {
            locationAddress = address;
          });
              context.read<OrderBloc>().add(AddLocationEvent(location: address
              ));
        }
      } else {
        if (mounted) {
          setState(() {
            locationAddress = "No address found";
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          locationAddress = "No address found";
        });
      }
    }
  }

  @override
  void dispose() {
    // Clean up any resources if needed
    super.dispose();
  }
}
