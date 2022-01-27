import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_puzzle_hack/widgets/board.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Puzzle Attack',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Board(),
    );
  }
}

// class Board extends StatelessWidget {
//   final numbers = [ 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15 ];
//   Board({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Container(
//         width: 600,
//         height: 600,
//         color: Colors.red,
//         child: GridView.builder(
//           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4,),
//           itemCount: numbers.length,
//           itemBuilder: (context, index) {
//             // return GridButton(
//             //   click: () => clickGrid(index),
//             //   text: "${numbers[index]}",
//             // );
//             return Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Container(
//                   color: Colors.blue,
//                 ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
