
import 'package:flutter/material.dart';
import 'package:parrotpos/style/style.dart';

class OnboardingItem extends StatelessWidget {
  final String title;
  final String subtitle;

  final String imageUrl;

  // ignore: use_key_in_widget_constructors
  const OnboardingItem(
      {required this.title, required this.subtitle, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
        colors: [
          Colors.white,
          Color(0xffEFF4FC),
          Colors.white,
        ],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      )),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            title,
            textAlign: TextAlign.center,
            style: kBlackTitleStyle20,
          ),
          const SizedBox(
            height: 15,
          ),
          SizedBox(
            height: size.height * 0.3,
            width: MediaQuery.of(context).size.width * 0.6,
            child: Image.asset(
              imageUrl,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: kBlackMediumStyle,
          ),
        ],
      ),
    );
  }
}
