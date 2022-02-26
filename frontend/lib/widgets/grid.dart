import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_puzzle_hack/widgets/movable_token.dart';
import 'package:flutter_puzzle_hack/widgets/player_token.dart';

import 'grid_button.dart';

class Grid extends StatelessWidget {
  final List<int> numbers;
  final Size size;
  final List<bool> changes;

  // Grid({required this.size, required this.numbers, required this.clickGrid});
  Grid({required this.size, required this.numbers, required this.changes});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox.square(
        dimension: size.height * 0.5,
        child: Container(
          decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/field-outline.png"),
          ),
        ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              //TODO: dynamic
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4
              //, mainAxisSpacing: 5, crossAxisSpacing: 5
              ),
              //TODO: dynamic
              itemCount: numbers.length,
              itemBuilder: (context, index) {
                int currNum = numbers[index];
                return currNum != 0
                    ? PlayerToken(
                        index: index,
                        circle: currNum == 1,
                        changed: changes[index],
                      )
                    : MovableToken(
                        // click: clickGrid,
                        index: index,
                      );
              },
            ),
          ),
        ),
      ),
    );
  }
}
