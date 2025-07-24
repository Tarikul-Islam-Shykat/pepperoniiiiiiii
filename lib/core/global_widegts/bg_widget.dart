import 'package:flutter/material.dart';

class BgWidget extends StatelessWidget {
  final String bgImagePath;
  final Widget child;

  const BgWidget({
    super.key,
    required this.bgImagePath,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            alignment: Alignment.topCenter,
            image: NetworkImage(bgImagePath),
            fit: BoxFit.cover,
          ),
        ),
        child: child,
      ),
    );
  }
}
