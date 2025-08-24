import 'package:flutter/material.dart';
import 'package:flutter_feature_all_in_one/view_source_code.dart';
import 'fluid_card.dart';
import 'fluid_carousel.dart';

// NOTE: Agr apko ye onboarding screen use krni hain to ap nechy text ko change kr skty hain
class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FluidCarousel(
            children: <Widget>[
              FluidCard(
                color: 'Red',
                altColor: Color(0xFF4259B2),
                title: "Start Your Day \nwith Peaceful Mornings",
                subtitle:
                    "Wake up refreshed with calming nature-inspired sounds designed to ease you into the day.",
              ),
              FluidCard(
                color: 'Yellow',
                altColor: Color(0xFF904E93),
                title: "Refresh Your Mind \nwith Guided Breathing",
                subtitle:
                    "Reduce stress and boost focus with science-backed breathing techniques at your fingertips.",
              ),
              FluidCard(
                color: 'Blue',
                altColor: Color(0xFFFFB138),
                title: "Sleep Soundly \nwith Soothing Stories",
                subtitle:
                    "Drift into deep sleep with a collection of relaxing bedtime stories and mindfulness exercises.",
              ),
            ],
          ),
          Positioned(
            right: 20,
            top: 60,
            child: ElevatedButton(
              style: ButtonStyle(
                padding: WidgetStateProperty.all(
                  EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                ),
              ),
              onPressed: () {
                String filePath = 'lib/features/intro_screen/intro_scren.dart';
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SourceCodeView(filePath: filePath),
                  ),
                );
              },
              child: Text('Source Code', style: TextStyle(fontSize: 10)),
            ),
          ),
        ],
      ),
    );
  }
}
