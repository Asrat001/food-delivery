import "package:flutter/material.dart";
import "package:food_ordering_app_with_flutter_and_bloc/models/onBoarding/onboarding_Items.dart";
import "package:food_ordering_app_with_flutter_and_bloc/shared/widgets/dotindictor_view.dart";
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late OnBoardingItems _controller;
  late PageController _pageController;
  late bool _isLastPage;

  void initState() {
    _controller = OnBoardingItems();
    _pageController = PageController();
    _isLastPage = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: PageView.builder(
                itemCount: _controller.items.length,
                controller: _pageController,
                onPageChanged: (index) => setState(() {
                      _isLastPage = _controller.items.length - 1 == index;
                    }),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: (Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(_controller.items[index].image),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(_controller.items[index].title,
                            textAlign: TextAlign.center,
                            style: textTheme.titleLarge!
                                .copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          _controller.items[index].description,
                          textAlign: TextAlign.center,
                          style: textTheme.bodyLarge!.copyWith(
                              fontWeight: FontWeight.w400, color: Colors.grey),
                        )
                      ],
                    )),
                  );
                }),
          ),
          DotIndictorView(
              pageController: _pageController,
              controller: _controller,
              textTheme: textTheme,
              isLastPage: _isLastPage,
              )
        ],
      ),
    );
  }
}


