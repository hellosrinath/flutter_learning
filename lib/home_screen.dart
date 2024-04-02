import 'package:flutter/material.dart';
import 'package:flutter_learning/profile_screen.dart';
import 'package:flutter_learning/settings_screen.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // using reactive programming
  // int _counter = 0;
  RxInt _counter = 0.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /*Text(
              '$_counter',
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),*/
            // using Obx for rebuild this portion
            Obx(
              () => Text(
                '$_counter',
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // navigation home screen to profile screen using get x
                // it works like navigator.push
                Get.to(() => const ProfileScreen());
              },
              child: const Text("Go to Profile"),
            ),
            ElevatedButton(
              onPressed: () {
                // navigate home screen to settings screen (it is alternative of navigator.push)
                Get.to(() => const SettingScreen());
              },
              child: const Text("Go to Settings"),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _counter++;
          // no need to use setState because it's use get_x obs
          // setState(() {});
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
