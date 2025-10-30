import 'package:flutter/material.dart';

class WelcomeSnackbar extends StatelessWidget {
  const WelcomeSnackbar({super.key});

  @override
  Widget build(BuildContext context) {
    return SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Bem-Vindo <username>',
            style: TextStyle(fontSize: 15, color: Colors.white),
          ),
          IconButton(
            onPressed: ScaffoldMessenger.of(context).hideCurrentSnackBar,
            icon: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.secondaryContainer,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.close, color: Colors.white, size: 40),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.secondary,
    );
  }
}
