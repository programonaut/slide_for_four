import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_puzzle_hack/widgets/movable_token.dart';
import 'package:flutter_puzzle_hack/widgets/player_token.dart';

import 'grid_button.dart';

class Grid extends StatelessWidget {
  final List<int> numbers;
  final Size size;
  // final Function clickGrid;

  // Grid({required this.size, required this.numbers, required this.clickGrid});
  Grid({required this.size, required this.numbers});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox.square(
        dimension: size.height * 0.5,
        child: GridView.builder(
          //TODO: dynamic
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4, mainAxisSpacing: 5, crossAxisSpacing: 5),
          //TODO: dynamic
          itemCount: numbers.length,
          itemBuilder: (context, index) {
            int currNum = numbers[index];
            return currNum != 0
                ? PlayerToken(
                    click: () => print("Dont click me!"),
                    text: "$currNum",
                    circle: currNum == 1,
                  )
                : MovableToken(
                    // click: clickGrid,
                    index: index,
                  );
          },
        ),
      ),
    );
  }
}
