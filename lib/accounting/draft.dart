import 'package:flutter/material.dart';

class DraftScreen extends StatefulWidget {
  const DraftScreen({super.key});

  @override
  State<DraftScreen> createState() => _DraftScreenState();
}

class _DraftScreenState extends State<DraftScreen> {
  bool showContent = false;

  @override
  void initState() {
    super.initState();
    _showIntroAnimation();
  }

  void _showIntroAnimation() {
    setState(() {
      showContent = false;
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          showContent = true;
        });
      }
    });
  }

  /// Called when back button pressed
  Future<bool> _onWillPop() async {
    // Show animation again
    setState(() {
      showContent = false;
    });

    // wait for animation
    await Future.delayed(const Duration(seconds: 2));

    return true; // now pop screen
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 800),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: ScaleTransition(scale: animation, child: child),
              );
            },
            child: showContent ? _mainContent() : _animatedImage(),
          ),
        ),
      ),
    );
  }

  Widget _animatedImage() {
    return Image.asset(
      'assets/icons/bank1.png',
      key: const ValueKey('image'),
      width: 120,
    );
  }

  Widget _mainContent() {
    return const Text(
      "Draft Screen",
      key: ValueKey('content'),
      style: TextStyle(fontSize: 24),
    );
  }
}
