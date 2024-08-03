import "package:flutter/material.dart";
import "package:food_ordering_app_with_flutter_and_bloc/models/onBoarding/onboarding_Items.dart";
import "package:food_ordering_app_with_flutter_and_bloc/screens/Auth/login_screen.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:smooth_page_indicator/smooth_page_indicator.dart";

class DotIndictorView extends StatelessWidget {
  const DotIndictorView(
      {super.key,
      required PageController pageController,
      required OnBoardingItems controller,
      required this.textTheme,
      required this.isLastPage})
      : _pageController = pageController,
        _controller = controller;

  final PageController _pageController;
  final OnBoardingItems _controller;
  final TextTheme textTheme;
  final bool isLastPage;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: isLastPage
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () async {
                      final pref = await SharedPreferences.getInstance();
                      pref.setBool("onboarding", true);
                     
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>const LoginScreen()));
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.black),
                    child: Text("get Started",
                        style: textTheme.labelLarge!
                            .copyWith(color: Colors.white))),
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SmoothPageIndicator(
                  controller: _pageController,
                  count: _controller.items.length,
                  effect: const WormEffect(activeDotColor: Colors.black),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                        onPressed: () => _pageController
                            .jumpToPage(_controller.items.length - 1),
                        child: const Text("Skip")),
                    ElevatedButton(
                        onPressed: () => _pageController.nextPage(
                            duration: const Duration(milliseconds: 600),
                            curve: Curves.easeIn),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black),
                        child: Text(
                          "Next",
                          style: textTheme.labelLarge!
                              .copyWith(color: Colors.white),
                        ))
                  ],
                ),
              ],
            ),
    );
  }
}
