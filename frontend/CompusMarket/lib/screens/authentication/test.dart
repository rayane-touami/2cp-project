import 'package:flutter/material.dart';

class Test extends StatelessWidget {
  const Test({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          // green top left
          Positioned(
            top: -250,
            left: -250,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.lightBlueAccent.withOpacity(0.25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.lightBlueAccent.withOpacity(0.6),
                    blurRadius: 300,
                    spreadRadius: 180,
                  ),
                ],
              ),
            ),
          ),

          // blue top right
          Positioned(
            top: -250,
            right: -250,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.lightBlueAccent.withOpacity(0.25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.lightBlueAccent.withOpacity(0.5),
                    blurRadius: 300,
                    spreadRadius: 200,
                  ),
                ],
              ),
            ),
          ),

          // pink bottom center
          Positioned(
            bottom: -220,
            left: 100,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.lightBlueAccent.withOpacity(0.18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.lightBlueAccent.withOpacity(0.4),
                    blurRadius: 200,
                    spreadRadius: 150,
                  ),
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }
}