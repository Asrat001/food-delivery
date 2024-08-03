import 'package:food_ordering_app_with_flutter_and_bloc/models/onBoarding/onBording_Models.dart';

class OnBoardingItems {
  List<OnBoardingInfo> items = [
    OnBoardingInfo(
        title: "Fast Delivery",
        description:
            "Welcome to a World of Limitless Choices - Your Perfect Product Awaits!",
        image: 'assets/images/onBord1.gif'),
    OnBoardingInfo(
        title: "Deliver at your door step",
        description:
            "From Our Doorstep to Yours - Swift, Secure, and Contactless Delivery!",
        image: 'assets/images/onBord2.gif'),
    OnBoardingInfo(
        title: "Select Payment Method",
        description:
            "For Seamless Transactions, Choose Your Payment Path - Your Convenience, Our Priority!",
        image:'assets/images/onBord3.gif')
  ];
}
