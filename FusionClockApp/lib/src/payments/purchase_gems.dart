import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class PurchaseView extends StatefulWidget {
  @override
  _PurchaseViewState createState() => _PurchaseViewState();
}

class _PurchaseViewState extends State<PurchaseView> {
  List<Widget> _fallingGems = [];

  @override
  void initState() {
    super.initState();
    _startFalling();
  }

  Timer? _timer;

  void _startFalling() {
    _timer = Timer.periodic(Duration(milliseconds: 500), (Timer timer) {
      setState(() {
        _fallingGems.add(
          FallingGem(
            key: UniqueKey(),
          ),
        );
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Purchase View'),
    ),
    body: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: FractionalOffset.topLeft,
          end: FractionalOffset.bottomRight,
          colors: [
            Color.fromARGB(255, 56, 9, 60),
            Color.fromARGB(255, 121, 24, 139),
            Colors.pink,
            Color.fromARGB(255, 219, 186, 127),
          ],
          stops: [
            0.0,
            0.2,
            0.8,
            1.0,
          ],
        ),
      ),
      child: Stack(
        children: [
          AnimatedContainer(
            duration: Duration(seconds: 5),
            color: Colors.transparent,
          ),
          ..._fallingGems,
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                PurchaseItem(
                  gemCount: 60,
                  price: '\$3.49',
                  discountPercentage: 0,
                  imagePath: 'assets/gems.png', // Replace 'assets/gems.png' with your image path
                ),
                PurchaseItem(
                  gemCount: 200,
                  price: '\$6.49',
                  discountPercentage: 20,
                  imagePath: 'assets/gems.png', // Replace 'assets/gems.png' with your image path
                ),
                PurchaseItem(
                  gemCount: 800,
                  price: '\$13.99',
                  discountPercentage: 40,
                  imagePath: 'assets/gems.png', // Replace 'assets/gems.png' with your image path
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
  }
}

class FallingGem extends StatefulWidget {
  const FallingGem({Key? key}) : super(key: key);

  @override
  _FallingGemState createState() => _FallingGemState();
}

class _FallingGemState extends State<FallingGem> {
  late double _top;
  late double _rotation;

  @override
  void initState() {
    super.initState();
    _top = -100;
    _rotation = Random().nextDouble() * 2 * pi;
    _startFalling();
  }

  Timer? _timer;

  void _startFalling() {
    _timer = Timer.periodic(Duration(milliseconds: 50), (Timer timer) {
      setState(() {
        _top += 15; // Adjust the speed of falling here
        _rotation += 0.01;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: Duration(milliseconds: 10000),
      top: _top,
      left: Random().nextDouble() * MediaQuery.of(context).size.width,
      child: Transform.rotate(
        angle: _rotation,
        child: Icon(
          Icons.diamond,
          color: Colors.white,
          size: 60.0,
        ),
      ),
    );
  }
}

class PurchaseItem extends StatelessWidget {
  final int gemCount;
  final String price;
  final int discountPercentage;
  final String imagePath;

  const PurchaseItem({
    Key? key,
    required this.gemCount,
    required this.price,
    required this.discountPercentage,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blueGrey[100],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              Image.asset(
                imagePath,
                height: 150,
                width: 150,
              ),
              Container(
                transform: Matrix4.rotationZ(0.8),
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Text(
                  '${discountPercentage.toString()}% OFF',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            gemCount.toString(),
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Price: $price',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
