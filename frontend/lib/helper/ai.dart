import 'ws.dart';

class Ai extends WS {
  final List<List<int>> solutions = [
    [1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1],
    [1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0],
    [0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0],
    [0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0],
    [0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1],
    [1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1],
    [0, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 0],
  ];

  final ai = 1;
  List<List<int>> lastMoveIndeces = [];
  final history = 10;
  Function? initCallback;

  Ai(String uri, {this.initCallback}) : super(uri);

  bool contains(listOfLists, list) {
    bool inside = false;
    for (var l in listOfLists) {
      var eq = true;
      for (var i = 0; i < l.length; i++) {
        if (l[i] != list[i]) {
          eq = false;
        }
      }
      if (eq) {
        inside = true;
      }
    }
    return inside;
  }

  // void main() {
  //   var field = <int>[0, 2, 2, 0, 2, 1, 0, 2, 1, 0, 0, 0, 1, 0, 0, 1];
  //   field.shuffle();

  //   print(doMove(field)["dir"]);
  // }

  @override
  updateState(params) {
    super.updateState(params);
    if (params["player"] == ai) {
      var act = doMove(field);
      Future.delayed(
        Duration(seconds: 1),
        () => sendJSON('turn', {
          "player": player,
          "index": act["index"],
          "direction": act["dir"],
        }),
      );
    }
  }

  @override
  setInit(params) {
    initCallback!(params);
    super.setInit(params);
  }

  Map<String, int> doMove(field) {
    var best = findTarget(field, solutions);
    printField(best);

    var possibilites = getPossibilites(field);
    if (possibilites.isEmpty) {
      possibilites = getPossibilites(field, force: true);
    }

    var pre = getMoveIndices(field);
    field = findStep(best, possibilites);

    if (lastMoveIndeces.length >= history) {
      lastMoveIndeces.removeAt(0);
    }

    var after = getMoveIndices(field);
    lastMoveIndeces.add(after);

    var change = [
      ...pre.where((element) => !after.contains(element)),
      ...after.where((element) => !pre.contains(element))
    ];
    return {"index": change[0], "dir": change[1] - change[0]};
  }

  bool finished(List<int> field, List<int> goal) {
    var it = Iterable<int>.generate(field.length).toList();

    var curr = it.map((i) => field[i] * goal[i]);
    var score = curr.reduce((value, element) => value += element);

    return score == 4;
  }

  List<int> findTarget(List<int> field, List<List<int>> possibilities) {
    var it = Iterable<int>.generate(field.length).toList();
    List<List<int>> differences = [];
    for (var pos in possibilities) {
      var dif = <int>[];
      for (var i = 0; i < field.length; i++) {
        dif.add(
            pos[i] > 0 ? (field[i] > 1 ? field[i] * -1 : field[i]) : pos[i]);
      }
      differences.add(dif);
    }
    List<int> bestDifference = differences[0];
    int score = 0;
    differences.asMap().forEach((i, dif) {
      int currScore = dif.reduce((value, element) => value += element);
      if (currScore >= score) {
        score = currScore;
        bestDifference = possibilities[i];
      }
    });

    return bestDifference;
  }

  List<List<int>> getPossibilites(List<int> field, {bool force = false}) {
    List<List<int>> possibilites = [];

    for (var i = 0; i < field.length; i++) {
      if (field[i] == ai) {
        // left
        if (i - 1 >= 0 && i % 4 > 0 && field[i - 1] == 0) {
          var f = field.toList();
          f[i - 1] = f[i];
          f[i] = 0;
          var mi = getMoveIndices(f);
          // print("left: $mi , $lastMoveIndeces, ${contains(lastMoveIndeces, mi)}");
          if (!contains(lastMoveIndeces, mi) || force) {
            possibilites.add(f);
          }
        }
        // right
        if (i + 1 < field.length && i % 4 < 3 && field[i + 1] == 0) {
          var f = field.toList();
          f[i + 1] = f[i];
          f[i] = 0;
          var mi = getMoveIndices(f);
          // print("right: $mi , $lastMoveIndeces, ${contains(lastMoveIndeces, mi)}");
          if (!contains(lastMoveIndeces, mi) || force) {
            possibilites.add(f);
          }
        }
        // up
        if (i - 4 >= 0 && field[i - 4] == 0) {
          var f = field.toList();
          f[i - 4] = f[i];
          f[i] = 0;
          var mi = getMoveIndices(f);
          // print("up $mi , $lastMoveIndeces, ${contains(lastMoveIndeces, mi)}");
          if (!contains(lastMoveIndeces, mi) || force) {
            possibilites.add(f);
          }
        }
        // down
        if (i + 4 < field.length && field[i + 4] == 0) {
          var f = field.toList();
          f[i + 4] = f[i];
          f[i] = 0;
          var mi = getMoveIndices(f);
          // print("down: $mi , $lastMoveIndeces, ${contains(lastMoveIndeces, mi)}");
          if (!contains(lastMoveIndeces, mi) || force) {
            possibilites.add(f);
          }
        }
      }
    }

    return possibilites;
  }

  List<int> findStep(List<int> goal, List<List<int>> possibilities) {
    var it = Iterable<int>.generate(goal.length).toList();
    List<List<int>> differences = possibilities
        .map((pos) =>
            it.map((i) => goal[i] * (pos[i] > 1 ? -pos[i] : pos[i])).toList())
        .toList();
    List<int> bestDifference = differences[0];

    int score = 0;

    differences.asMap().forEach((i, dif) {
      int currScore = dif.reduce((value, element) => value += element);
      // print("$dif, $currScore");
      if (currScore >= score) {
        score = currScore;
        bestDifference = possibilities[i];
      }
    });

    return bestDifference;
  }

  List<int> getMoveIndices(List<int> field) {
    var it = Iterable<int>.generate(field.length).toList();
    return it
        .map((i) => field[i] == ai ? i : -1)
        .where((element) => element != -1)
        .toList();
  }

  void printField(field) {
    print("field:");
    for (var i = 0; i < 16; i += 4) {
      print("${field[i]}|${field[i + 1]}|${field[i + 2]}|${field[i + 3]}");
    }
    print("");
  }
}
