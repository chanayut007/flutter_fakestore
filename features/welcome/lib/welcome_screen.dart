import 'package:flutter/material.dart';
import 'package:home/home_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLargeScreen = size.width > 600;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isLargeScreen ? 400 : double.infinity,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: isLargeScreen ? 64 : 32),
                  Text(
                    'FakeStore App',
                    style: TextStyle(
                      fontSize: isLargeScreen ? 40 : 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  SizedBox(height: isLargeScreen ? 24 : 16),
                  Text(
                    'Welcome to FakeStore, your one-stop shop for all your needs. Discover amazing products at unbeatable prices!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: isLargeScreen ? 20 : 16,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: isLargeScreen ? 56 : 40),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomeScreen())),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          vertical: isLargeScreen ? 20 : 16,
                        ),
                        textStyle: TextStyle(
                          fontSize: isLargeScreen ? 22 : 18,
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                      ),
                      child: const Text('Click to be continued'),
                    ),
                  ),
                  SizedBox(height: isLargeScreen ? 64 : 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
