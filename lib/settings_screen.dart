import 'package:flutter/material.dart';
import 'package:flutter_learning/profile_screen.dart';
import 'package:get/route_manager.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // replace this settings screen. like navigator replace function
                Get.off(() => const ProfileScreen());
              },
              child: const Text("Go to Profile"),
            ),
            ElevatedButton(
              onPressed: () {
                // it works like navigator.pop functions. it will go to back screen.
                Get.back();
              },
              child: const Text("Back"),
            ),
          ],
        ),
      ),
    );
  }
}
