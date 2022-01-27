import 'dart:math';
import 'package:flutter/material.dart';

const UP = 1;
const LEFT = 3;
const RIGHT = 5;
const DOWN = 7;

class MovableToken extends StatefulWidget {
  final Function click;
  final int index;

  const MovableToken({Key? key, required this.click, required this.index})
      : super(key: key);

  @override
  State<MovableToken> createState() => _MovableTokenState();
}

class _MovableTokenState extends State<MovableToken> {
  bool hover = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: MouseRegion(
        child: Container(
          child: Center(
            child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemCount: 9,
                itemBuilder: (context, index) {
                  switch (index) {
                    case UP:
                      return ControlArrow(icon: Icons.keyboard_arrow_up_rounded, hover: hover, callback: () => widget.click(widget.index, -4),);

                    case LEFT:
                      return ControlArrow(icon: Icons.keyboard_arrow_left_rounded, hover: hover, callback: () => widget.click(widget.index, -1),);

                    case RIGHT:
                      return ControlArrow(icon: Icons.keyboard_arrow_right_rounded, hover: hover, callback: () => widget.click(widget.index, 1),);

                    case DOWN:
                      return ControlArrow(icon: Icons.keyboard_arrow_down_rounded, hover: hover, callback: () => widget.click(widget.index, 4),);

                    default:
                      return const SizedBox.shrink();
                  }
                }),
          ),
          decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                    color: Colors.black,
                ),
                borderRadius: BorderRadius.circular(5)
          ),
        ),
        // TODO: rework
        onEnter: (details) => setState(() {
          hover = true;
        }),
        onExit: (details) => setState(() {
          hover = false;
        }),
      ),
      onTap: () => widget.click(),
    );
  }
}

class ControlArrow extends StatefulWidget {
  const ControlArrow({
    Key? key,
    required this.hover, required this.icon, this.callback,
  }) : super(key: key);

  final bool hover;
  final IconData icon;
  final Function? callback;

  @override
  State<ControlArrow> createState() => _ControlArrowState();
}

class _ControlArrowState extends State<ControlArrow> {
  bool individualHover = false;

  @override
  Widget build(BuildContext context) {
    Color col = Colors.white;
    if (!widget.hover) {
      col = Colors.white;
    }
    else if(widget.hover && !individualHover) {
      col = Colors.grey;
    }
    else {
      col = Colors.black;
    }

    return GestureDetector(
      onTap: widget.callback != null ? () => widget.callback!() : () => print("Assign a method here!"),
      child: MouseRegion(
        child: Container(
          child: Icon(
            widget.icon,
            color: col
          ),
        ),
        onEnter: (details) => setState(() {
          individualHover = true;
        }),
        onExit: (details) => setState(() {
          individualHover = false;
        }),
      ),
    );
  }
}
