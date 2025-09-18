import 'package:flutter/material.dart';

import '../controller/multi_player.controller.dart';

class MultiPlayerPage extends StatefulWidget {
  const MultiPlayerPage({super.key});

  @override
  State<MultiPlayerPage> createState() => _MultiPlayerPageState();
}

class _MultiPlayerPageState extends State<MultiPlayerPage> {
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
                _buildScoreColumn("Player O", TicToeTac.playerOCount),
                _buildScoreColumn("Player X", TicToeTac.playerXCount),
                _buildScoreColumn("Draw", TicToeTac.drawMatch),
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
                    // Await the game logic to complete before updating the UI
                    await TicToeTac.playerSwapping(index, context);
                    setState(() {});
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      color: TicToeTac.cardColor[index],
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
                        TicToeTac.value[index],
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
              (TicToeTac.xTurn) ? "Player X's Turn" : "Player O's Turn",
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
                _buildControlButton("Reset", () async {
                  await TicToeTac.clearControl();
                  setState(() {});
                }),
                _buildControlButton("Restart", () {
                  TicToeTac.playerOCount = 0;
                  TicToeTac.playerXCount = 0;
                  TicToeTac.drawMatch = 0;
                  TicToeTac.clearControl().then((_) => setState(() {}));
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
