import 'package:flutter/material.dart';
import 'package:flutter_learning/home_screen.dart';
import 'package:get/route_manager.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Profile'),
            ElevatedButton(
              onPressed: () {
                // all screen remove and go to home
                // push_and_remove_until
                Get.offAll(() => const HomeScreen());
              },
              child: const Text("Go to Home"),
            ),
            ElevatedButton(
              onPressed: () {
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
