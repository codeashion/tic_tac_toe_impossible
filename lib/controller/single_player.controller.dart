import 'dart:math';
import 'dart:async';

import 'package:flutter/material.dart';

class TicTacToeSingle {
  static List value = List.generate(9, (index) => "");
  static List<Color> cardColor = List.generate(9, (index) => Colors.grey);
  static bool xTurn = false; // false: Player X's turn, true: AI O's turn
  static int fillBox = 0;
  static int playerOCount = 0;
  static int playerXCount = 0;
  static int drawMatch = 0;

  static Future<bool> playerSwap(int index, context) async {
    if (!xTurn && value[index] == "") {
      value[index] = "X";
      cardColor[index] = Colors.yellow.shade300;
      fillBox++;
      xTurn = !xTurn;
      return await winnerState(context); // Await and return the result
    }
    return false; // No move was made
  }

  static Future<void> clearControl() {
    return Future.delayed(const Duration(milliseconds: 300), () {
      value = List.generate(9, (index) => "");
      fillBox = 0;
      cardColor = List.generate(9, (index) => Colors.grey);
      xTurn = false; // Player X (human) always starts
    });
  }

  static Future<bool> winnerState(context) async {
    const List<List<int>> winConditions = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8], // Rows
      [0, 3, 6], [1, 4, 7], [2, 5, 8], // Columns
      [0, 4, 8], [2, 4, 6], // Diagonals
    ];

    for (var condition in winConditions) {
      String val1 = value[condition[0]];
      String val2 = value[condition[1]];
      String val3 = value[condition[2]];

      if (val1.isNotEmpty && val1 == val2 && val2 == val3) {
        await winnerNumber(context);
        return true; // Game has ended
      }
    }

    if (fillBox == 9) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Draw Match! Play Again...")),
      );
      drawMatch++;
      await clearControl();
      return true; // Game has ended
    }
    return false; // Game has not ended
  }

  static Future<void> winnerNumber(context) async {
    // The turn was just swapped, so the winner is the opposite of the current turn.
    String winner = xTurn ? "X" : "O";
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Player $winner is the Winner!")));

    if (winner == "X") {
      playerXCount++;
    } else {
      playerOCount++;
    }
    await clearControl();
  }

  static Future<void> manualAi(context) async {
    // Prevent AI from moving if the board is full or it's not the AI's turn
    if (fillBox >= 9 || !xTurn) return;

    await Future.delayed(const Duration(milliseconds: 1000), () async {
      int bestMove = _findBestMove();
      if (bestMove != -1) {
        value[bestMove] = "O";
        cardColor[bestMove] = Colors.red.shade300;
        fillBox++;
        xTurn = !xTurn;
        // Await the winner check. This will also handle clearing the board on draw/win.
        await winnerState(context);
      }
    });
  }

  static int _findBestMove() {
    int bestScore = -1000;
    int move = -1;

    for (int i = 0; i < 9; i++) {
      if (value[i] == "") {
        value[i] = "O"; // AI's move
        int score = _minimax(0, false);
        value[i] = ""; // Undo move
        if (score > bestScore) {
          bestScore = score;
          move = i;
        }
      }
    }
    return move;
  }

  static int _minimax(int depth, bool isMaximizing) {
    int score = _evaluateBoard();

    if (score == 10 || score == -10) return score;

    // Check for draw based on board state, not fillBox
    bool isMovesLeft = value.any((element) => element == "");
    if (!isMovesLeft) return 0;

    if (isMaximizing) {
      int best = -1000;
      for (int i = 0; i < 9; i++) {
        if (value[i] == "") {
          value[i] = "O";
          best = max(best, _minimax(depth + 1, !isMaximizing));
          value[i] = "";
        }
      }
      return best;
    } else {
      int best = 1000;
      for (int i = 0; i < 9; i++) {
        if (value[i] == "") {
          value[i] = "X";
          best = min(best, _minimax(depth + 1, !isMaximizing));
          value[i] = "";
        }
      }
      return best;
    }
  }

  static int _evaluateBoard() {
    // Check rows, columns, and diagonals for a winner
    const List<List<int>> winConditions = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    for (var condition in winConditions) {
      if (value[condition[0]] == value[condition[1]] &&
          value[condition[1]] == value[condition[2]] &&
          value[condition[0]] != "") {
        if (value[condition[0]] == "O") return 10; // AI wins
        if (value[condition[0]] == "X") return -10; // Player wins
      }
    }
    return 0; // No winner
  }
}
