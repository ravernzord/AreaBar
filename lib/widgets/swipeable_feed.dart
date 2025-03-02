import 'package:flutter/material.dart';

class SwipeableFeed extends StatelessWidget {
  // Adding `const` to the list initialization
  final List<String> feedItems = const [
    'Item 1: Soccer News',
    'Item 2: Politics',
    'Item 3: Stock Market',
  ];

  const SwipeableFeed({super.key});

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      scrollDirection: Axis.vertical,
      itemCount: feedItems.length,
      itemBuilder: (context, index) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              feedItems[index],
              style: const TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
    );
  }
}
