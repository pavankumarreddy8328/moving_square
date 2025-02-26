import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Padding(
        padding: EdgeInsets.all(32.0),
        child: SquareAnimation(),
      ),
    );
  }
}

class SquareAnimation extends StatefulWidget {
  const SquareAnimation({super.key});

  @override
  State<SquareAnimation> createState() {
    return _SquareAnimationState();
  }
}

class _SquareAnimationState extends State<SquareAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _screenWidth = 0;
  static const _squareSize = 50.0;
  double _targetPosition = 0;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _controller.addListener(() {
      setState(() {});
    });

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        setState(() => _isAnimating = false);
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateScreenWidth();
    });
  }

  void _updateScreenWidth() {
    setState(() {
      _screenWidth = MediaQuery.of(context).size.width;
      _targetPosition = (_screenWidth - _squareSize) / 2; // Start in center
      _animation = Tween<double>(begin: _targetPosition, end: _targetPosition)
          .animate(_controller);
    });
  }

  void _moveSquare(bool moveRight) {
    if (_isAnimating) return;

    setState(() {
      _isAnimating = true;
      double newPosition = moveRight ? (_screenWidth - _squareSize) : 0;
      _animation = Tween<double>(begin: _targetPosition, end: newPosition)
          .animate(_controller);
      _controller.forward(from: 0);
      _targetPosition = newPosition;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Animated Square")),
      body: LayoutBuilder(
        builder: (context, constraints) {
          _screenWidth =
              constraints.maxWidth; // Update screen width dynamically
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: _screenWidth,
                height: _squareSize,
                child: Stack(
                  children: [
                    AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        return Positioned(
                          left: _animation.value,
                          child: Container(
                            width: _squareSize,
                            height: _squareSize,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              border: Border.all(),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: (_isAnimating ||
                            _targetPosition == _screenWidth - _squareSize)
                        ? null
                        : () => _moveSquare(true),
                    child: const Text("Right"),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: (_isAnimating || _targetPosition == 0)
                        ? null
                        : () => _moveSquare(false),
                    child: const Text("Left"),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
