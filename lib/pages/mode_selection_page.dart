import 'package:flutter/material.dart';
import 'package:tic_tac_toe_impossible/pages/multi_player_page.dart';
import 'package:tic_tac_toe_impossible/pages/tic_toe_tac_page.dart';

class ModeSelectionPage extends StatelessWidget {
  const ModeSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade900,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Tic Tac Toe",
                style: TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Dancing Script",
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Select Game Mode",
                style: TextStyle(
                  fontSize: 30,
                  fontFamily: "Dancing Script",
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 80),
              _buildModeButton(context, 'Single Player', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TicToetacPage(),
                  ),
                );
              }),
              const SizedBox(height: 30),
              _buildModeButton(context, 'Multiplayer', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MultiPlayerPage(),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModeButton(
    BuildContext context,
    String label,
    VoidCallback onPressed,
  ) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.7,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.teal,
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 5,
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
