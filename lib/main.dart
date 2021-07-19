import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController _animationControllerVertical;
  late AnimationController _animationControllerFlip;
  late AnimationController _animationControllerHorizontal;
  late Animation<double> _rotateCard;
  late Animation<double> _movimentCardVertical;
  late Animation<double> _movimentCardHorizontal;
  late bool status = false;


  @override
  void initState() {
    super.initState();
    _animationControllerVertical = new AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 1000,
      ),
    );
    _animationControllerFlip = new AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 500,
      ),
    );
    _rotateCard = Tween<double>(begin: 0.0, end: pi / 2).animate(
        CurvedAnimation(
            parent: _animationControllerVertical, curve: Curves.decelerate));
    _movimentCardVertical =
        Tween<double>(begin: 0, end: 100).animate(CurvedAnimation(
            parent: _animationControllerVertical, curve: Curves.decelerate));
    _movimentCardHorizontal =
        Tween<double>(begin: 0, end: 100).animate(CurvedAnimation(
            parent: _animationControllerVertical, curve: Curves.decelerate));

    _animationControllerVertical.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationControllerFlip.forward();
      }
    });
    if (_movimentCardVertical.isCompleted) {
      status = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, contraints) {
        return Container(
          height: contraints.maxHeight,
          width: contraints.maxWidth,
          color: Colors.green.withRed(100),
          child: Stack(
            children: [
              AnimatedBuilder(
                  animation: _animationControllerVertical,
                  builder: (context, child) {
                    return Positioned(
                      top: _movimentCardVertical.value * 3,
                      left: 100 - _movimentCardVertical.value,
                      child: GestureDetector(
                        onTap: (){
                          _animationControllerVertical.forward();
                        },
                        child: Stack(
                          children: [
                            Transform.rotate(
                              angle: _rotateCard.value,
                              alignment: Alignment.center,
                              child: CardDeck(
                                animation: _animationControllerFlip,
                                image: 'assets/preto.jpg',
                                alignmentFactor:-80,),
                            ),Transform.rotate(
                              angle: _rotateCard.value,
                              alignment: Alignment.center,
                              child: CardDeck(
                                animation: _animationControllerFlip,
                                image: 'assets/vermelho.jpg',
                                alignmentFactor:20,),
                            ),Transform.rotate(
                              angle: _rotateCard.value,
                              alignment: Alignment.center,
                              child: CardDeck(
                                animation: _animationControllerFlip,
                                image: 'assets/preto.jpg',
                                alignmentFactor:120,),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ],
          ),
        );
      },
    );
  }
}

class CardDeck extends AnimatedWidget {
  final Animation animation;
  final String image;
  final int alignmentFactor;

  CardDeck(
      {required this.animation, required this.image, required this.alignmentFactor})
      : super(listenable: animation);

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0.0,-(animation.value * alignmentFactor)),
      child: Container(
        child: RotatedBox(
          quarterTurns: 1,
          child: Image.asset(
            animation.value > 0.5 ? image : 'assets/back.jpg',
            fit: BoxFit.cover,
          ),
        ),
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..rotateX(-animation.value * pi),
        height: 80,
        width: 120,
      ),
    );
  }
}
