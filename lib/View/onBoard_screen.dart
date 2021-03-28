import 'package:cz2006/controller/auth_servcie.dart';
import 'package:cz2006/controller/rootPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_onboard/flutter_onboard.dart';
import 'package:provider/provider.dart';
class OnBoardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomUI();
  }
}


class CustomUI extends StatelessWidget {
  final PageController _pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return Provider<OnBoardState>(
      create: (_) => OnBoardState(),
      child: Scaffold(
        body: OnBoard(
          pageController: _pageController,
          onSkip: () {
             Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (BuildContext context) => new RootPage(auth: new AuthenticationServices())));
          },
          onDone: () {
            print('done tapped');
          },
          onBoardData: onBoardData,
          titleStyles: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.15,
          ),
          descriptionStyles: TextStyle(
            fontSize: 16,
            color: Colors.brown.shade300,
          ),
          pageIndicatorStyle: PageIndicatorStyle(
            width: 100,
            inactiveColor: Colors.deepOrangeAccent,
            activeColor: Colors.deepOrange,
            inactiveSize: Size(8, 8),
            activeSize: Size(12, 12),
          ),
          nextButton: Consumer<OnBoardState>(
            builder: (BuildContext context, OnBoardState state, Widget child) {
              return InkWell(
                onTap: () => _onNextTap(context,state),
                child: Container(
                  width: 230,
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: LinearGradient(
                      colors: [Colors.greenAccent, Colors.greenAccent[100]],
                    ),
                  ),
                  child: Text(
                    state.isLastPage ? "Done" : "Next",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _onNextTap(BuildContext context,OnBoardState onBoardState) {
    if (!onBoardState.isLastPage) {
      _pageController.animateToPage(
        onBoardState.page + 1,
        duration: Duration(milliseconds: 250),
        curve: Curves.easeInOutSine,
      );
    } else {
      Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (BuildContext context) => new RootPage(auth: new AuthenticationServices())));
    }
  }
}

final List<OnBoardModel> onBoardData = [
  OnBoardModel(
    title: "Stay alert to mosquitoes",
    description: "Open the map, view and avoid NEA-identified dengue clusters. Be careful!",
    imgUrl: "images/intro1.png",
  ),
  OnBoardModel(
    title: "Contribute to the battle",
    description:
        "Share what you see with the community, fight dengue together with fellow Singaporeans.",
    imgUrl: 'images/intro2.png',
  ),
  OnBoardModel(
    title: "Attractive prizes await",
    description:
        "Post quality content and earn coins. Redeem various attractive prizes with what you earn.",
    imgUrl: 'images/intro3.png',
  ),
];