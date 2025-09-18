import 'package:flutter/material.dart';
import 'package:tic_tac_toe_impossible/controller/multi_player.controller.dart';
import 'package:tic_tac_toe_impossible/controller/single_player.controller.dart';

class TicToetacPage extends StatefulWidget {
  const TicToetacPage({super.key});

  @override
  State<TicToetacPage> createState() => _TicToetacPageState();
}

class _TicToetacPageState extends State<TicToetacPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade900,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Title Section
            const Text(
              "Tic Tac Toe",
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
                fontFamily: "Dancing Script",
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            // Scoreboard Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildScoreColumn("Player O", TicTacToeSingle.playerOCount),
                _buildScoreColumn("Player X", TicTacToeSingle.playerXCount),
                _buildScoreColumn("Draw", TicTacToeSingle.drawMatch),
              ],
            ),
            const SizedBox(height: 35),
            // Game Grid
            GridView.count(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              shrinkWrap: true,
              crossAxisCount: 3,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              children: List.generate(
                9,
                (index) => GestureDetector(
                  onTap: () async {
                    // Prevent tap if it's not the player's turn or the cell is filled
                    if (TicTacToeSingle.xTurn ||
                        TicTacToeSingle.value[index] != "") {
                      return;
                    }

                    // Player makes a move. Check if the game ended.
                    bool gameEndedByPlayer = await TicTacToeSingle.playerSwap(
                      index,
                      context,
                    );
                    setState(() {}); // Update UI for player's move

                    // If the game did NOT end, it's the AI's turn.
                    if (!gameEndedByPlayer) {
                      await TicTacToeSingle.manualAi(context);
                      // This final setState ensures the UI updates after the AI's turn,
                      // including any board clearing from a draw.
                      setState(() {});
                    }
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      color: TicTacToeSingle.cardColor[index],
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Center(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder: (
                          Widget child,
                          Animation<double> animation,
                        ) {
                          return ScaleTransition(
                            scale: animation,
                            child: child,
                          );
                        },
                        child: Text(
                          TicTacToeSingle.value[index],
                          // Use a key to tell the AnimatedSwitcher that the widget has changed
                          key: ValueKey<String>(TicTacToeSingle.value[index]),
                          style: TextStyle(
                            color:
                                TicTacToeSingle.value[index] == 'X'
                                    ? Colors.white
                                    : Colors.black87,
                            fontSize: 65,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            // Control Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildControlButton("Reset", () async {
                  await TicTacToeSingle.clearControl();
                  setState(() {});
                }),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child: Text(
                    (TicTacToeSingle.xTurn) ? "AI's Turn" : "Your Turn",
                    key: ValueKey<bool>(TicTacToeSingle.xTurn),
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Dancing Script",
                      color: Colors.white,
                    ),
                  ),
                ),
                _buildControlButton("Restart", () async {
                  TicTacToeSingle.playerOCount = 0;
                  TicTacToeSingle.playerXCount = 0;
                  TicTacToeSingle.drawMatch = 0;
                  await TicTacToeSingle.clearControl();
                  setState(() {});
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreColumn(String title, int score) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            fontFamily: "Dancing Script",
            color: Colors.white,
          ),
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(opacity: animation, child: child);
          },
          child: Text(
            score.toString(),
            key: ValueKey<int>(score),
            style: const TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              fontFamily: "Dancing Script",
              color: Colors.amber,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildControlButton(String label, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.teal,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
      onPressed: onPressed,
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
