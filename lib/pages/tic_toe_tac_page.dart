import 'package:flutter/material.dart';
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
                    if (!TicTacToeSingle.xTurn) {
                      TicTacToeSingle.playerSwap(index, context);
                      setState(() {});
                    }
                    if (TicTacToeSingle.xTurn) {
                      await TicTacToeSingle.manualAi(context);
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
                      child: Text(
                        TicTacToeSingle.value[index],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 65,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            // Control Buttons
            Text(
              (TicTacToeSingle.xTurn) ? "Player O's Turn" : "Player X's Turn",
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                fontFamily: "Dancing Script",
                color: Colors.white,
              ),
            ),
            SizedBox(height: 35),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildControlButton("Reset", () {
                  TicTacToeSingle.clearControl();
                  setState(() {});
                }),
                _buildControlButton("Restart", () {
                  TicTacToeSingle.playerOCount = 0;
                  TicTacToeSingle.playerXCount = 0;
                  TicTacToeSingle.drawMatch = 0;
                  TicTacToeSingle.clearControl();
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
        Text(
          score.toString(),
          style: const TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            fontFamily: "Dancing Script",
            color: Colors.amber,
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
