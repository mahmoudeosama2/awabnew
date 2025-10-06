import 'package:flutter/material.dart';

class CounterIcons extends StatelessWidget {
  final int num;
  const CounterIcons({super.key, required this.num});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.black, width: 2),
      ),
      child: ClipOval(
        child: Center(
          child: Text(
            '$num',
            style: TextStyle(
              color: Colors.black,
              fontFamily: "Amiri",
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class CounterIconsJuz extends StatelessWidget {
  final int num;
  const CounterIconsJuz({super.key, required this.num});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      width: 30,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            children: [
              SizedBox(
                width: 50,
                height: 50,
                child: Image.asset("asset/images/black circle_3058748.png"),
              ),
              Container(
                alignment: Alignment.center,
                width: double.infinity,
                height: double.infinity,
                child: Text(
                  "$num",
                  style: const TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
