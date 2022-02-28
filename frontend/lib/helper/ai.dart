import 'dart:math';

import 'package:flutter_puzzle_hack/helper/ws.dart';

// void main() {
//   var field = <int>[0, 1, 1, 0, 0, 0, 2, 2, 2, 0, 1, 2, 0, 0, 0, 1];
//   field.shuffle();
//   printField(field);
//   solutions = solutions.reversed.toList();
//   initSolutionPatterns();

//   var best = findTarget(field, solutions);
//   rank(field, best);

//   var i = 0;
//   while (!finished(field, best) && i < 100) {
//     best = findTarget(field, solutions);

//     var mov = doMove(field);
//     field[mov["index"]!] = 1;
//     field[mov["index"]! + mov["dir"]!] = 0;

//     printField(field);
//     i += 1;
//   }
// }

class Ai extends WS {
  List<List<int>> solutions = [
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

  late List<List<List<int>>> solutionPattern;

  final ai = 1;
  List<List<int>> lastMoveIndeces = [];
  final history = 10;

  Function? initCallback;

  Ai(String uri, {this.initCallback}) : super(uri) {
    initSolutionPatterns();
  }
  
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

  void initSolutionPatterns() {
    List<List<List<int>>> res = [];
    for (var sol in solutions) {
      List<List<int>> solPat = [];
      for (var i = 0; i < sol.length; i++) {
        if (sol[i] == 1) {
          solPat.add(buildPattern(sol, i));
        }
      }
      res.add(solPat);
    }
    solutionPattern = res;
  }

  List<int> buildPattern(field, poi) {
    var pat = List.filled(field.length, -1);
    var currDistance = 0;
    pat[poi] = currDistance;
    while (pat.any((element) => element == -1)) {
      for (var i = 0; i < pat.length; i++) {
        if (pat[i] == currDistance) {
          if (i - 1 >= 0 && i % 4 != 0 && pat[i - 1] == -1) {
            pat[i - 1] = currDistance + 1;
          }
          if (i + 1 < pat.length && (i + 1) % 4 != 0 && pat[i + 1] == -1) {
            pat[i + 1] = currDistance + 1;
          }
          if (i - 4 >= 0 && pat[i - 4] == -1) {
            pat[i - 4] = currDistance + 1;
          }
          if (i + 4 < pat.length && pat[i + 4] == -1) {
            pat[i + 4] = currDistance + 1;
          }
        }
      }
      currDistance += 1;
    }
    return pat;
  }

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

  Map<String, int> doMove(field) {
    var best = findTarget(field, solutions);
    // printField(best);

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
    return {"index": change[1], "dir": change[0] - change[1]};
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
    int idx = -1;
    int bestScore = 10000;
    for (var i = 0; i < possibilities.length; i++) {
      int score = rank(possibilities[i], goal);
      if (score < bestScore) {
        bestScore = score;
        idx = i;
      }
    }

    printField(findTarget(possibilities[idx], solutions));
    return possibilities[idx];
  }

  int rank(List<int> field, List<int> sol) {
    var best = findTarget(field, solutions);
    var solIdx = getSolIdx(best);
    var pattern = solutionPattern[solIdx];
    // print("pattern: $pattern\nsolIdx: $solIdx");

    // dist, idx
    List<Map<int, List<int>>> dist = [];
    for (var x = 0; x < pattern.length; x++) {
      var pat = pattern[x];
      dist.add({});
      // get distance
      for (var i = 0; i < pat.length; i++) {
        if (field[i] == ai) {
          if (!dist[x].containsKey(pat[i])) {
            dist[x][pat[i]] = [i];
          } else {
            dist[x][pat[i]]!.add(i);
          }
        }
      }
    }

    var oldDist = dist.toList();
    // print(oldDist);
    dist.sort(((a, b) => a.keys.reduce(min).compareTo(b.keys.reduce(min))));
    List<int> changes = [];
    for (var x = 0; x < dist.length; x++) {
      for (var y = 0; y < oldDist.length; y++) {
        if (oldDist[y] == dist[x]) {
          changes.add(y);
        }
      }
    }

    // get shortest distances
    Map<int, Map<int, List<int>>> minDists = {};
    for (var i = 0; i < dist.length; i++) {
      if (dist[i].keys.isEmpty) {
        // printField(field);
        print("empty");
      }

      var minDist = dist[i].keys.reduce(min);
      minDists[changes[i]] = {};
      minDists[changes[i]]![minDist] = dist[i][minDist]!;

      var usedValues = <int>[];
      minDists.forEach((key, value) {
        minDists[key]?.forEach((key, value) {
          usedValues.addAll(value);
        });
      });

      usedValues = usedValues.toSet().toList();

      for (var dis in dist[i].keys) {
        for (var usedValue in usedValues) {
          if (dist[i][dis]!.contains(usedValue)) {
            dist[i][dis]!.remove(usedValue);
          }
        }
      }
      dist[i].removeWhere((k, v) => v.isEmpty);
    }

    int score = 0;
    for (var pos in minDists.values) {
      for (var val in pos.keys) {
        score += val * val;
      }
    }

    return score;
  }

  int getSolIdx(List<int> sol) {
    for (var i = 0; i < solutions.length; i++) {
      List<int> tmp = [];
      for (var x = 0; x < sol.length; x++) {
        tmp.add(sol[x] - solutions[i][x]);
      }
      if (tmp.every((element) => element == 0)) {
        return i;
      }
    }
    return -1;
  }

  List<int> findStepDifference(List<int> goal, List<List<int>> possibilities) {
    var it = Iterable<int>.generate(goal.length).toList();
    List<List<int>> differences = [];
    for (var pos in possibilities) {
      var dif = <int>[];
      for (var i = 0; i < goal.length; i++) {
        dif.add(goal[i] > 0 ? (pos[i] > 1 ? pos[i] * -1 : pos[i]) : goal[i]);
      }
      differences.add(dif);
    }

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
