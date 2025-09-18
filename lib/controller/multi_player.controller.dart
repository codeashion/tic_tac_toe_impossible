import 'dart:async';

import 'package:flutter/material.dart';

class TicToeTac {
  static List<String> value = List.generate(9, (index) => "");
  static List<Color> cardColor = List.generate(
    9,
    (index) => Colors.blueGrey.shade800,
  );
  static bool xTurn = true; // true means player X's turn
  static int fillBox = 0;
  static int playerOCount = 0;
  static int playerXCount = 0;
  static int drawMatch = 0;

  static Future<void> clearControl() async {
    await Future.delayed(const Duration(milliseconds: 1500), () {
      value = List.generate(9, (index) => "");
      fillBox = 0;
      cardColor = List.generate(9, (index) => Colors.blueGrey.shade800);
    });
  }

  static Future<void> winnerNumber(context) async {
    // The turn was already swapped, so the winner is the opposite of the current turn.
    String winner = xTurn ? "O" : "X";
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Player $winner is the Winner!"),
        backgroundColor: Colors.green,
      ),
    );

    if (winner == "X") {
      playerXCount++;
    } else {
      playerOCount++;
    }
    await clearControl();
  }

  static Future<void> playerSwapping(int index, context) async {
    // Proceed only if the tapped box is empty
    if (value[index] == "") {
      if (xTurn) {
        // Player X's turn
        value[index] = "X";
        cardColor[index] = Colors.teal;
      } else {
        // Player O's turn
        value[index] = "O";
        cardColor[index] = Colors.amber;
      }
      fillBox++;
      xTurn = !xTurn; // Swap turns

      // Check for winner only after at least 5 moves
      if (fillBox >= 5) {
        await winnerState(context);
      }
    }
  }

  static Future<void> winnerState(context) async {
    // Define all winning combinations
    const List<List<int>> winConditions = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8], // Rows
      [0, 3, 6], [1, 4, 7], [2, 5, 8], // Columns
      [0, 4, 8], [2, 4, 6], // Diagonals
    ];

    bool winnerFound = false;
    for (var condition in winConditions) {
      String val1 = value[condition[0]];
      String val2 = value[condition[1]];
      String val3 = value[condition[2]];

      if (val1.isNotEmpty && val1 == val2 && val2 == val3) {
        winnerFound = true;
        break;
      }
    }

    if (winnerFound) {
      await winnerNumber(context);
    } else if (fillBox == 9) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Draw Match! Play Again..."),
          backgroundColor: Colors.orange,
        ),
      );
      drawMatch++;
      await clearControl();
    }
  }
}
