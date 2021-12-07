import 'package:flutter/material.dart';

class DauthLoader extends StatelessWidget {
  const DauthLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        height: size.height,
        width: size.width,
        decoration: const BoxDecoration(color: Colors.black87),
        child: const Center(
            child: SizedBox(
                width: 115,
                height: 115,
                child: CircularProgressIndicator(
                  strokeWidth: 10,
                  color: Colors.green,
                  backgroundColor: Colors.white10,
                ))));
  }
}
