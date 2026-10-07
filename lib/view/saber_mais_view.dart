import 'package:flutter/material.dart';

class SaberMaisView extends StatefulWidget {
  const SaberMaisView({super.key});

  @override
  State<SaberMaisView> createState() => _SaberMaisViewState();
}

class _SaberMaisViewState extends State<SaberMaisView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Text(''),
            ],
          ),
        ),
      ),
    );
  }
}