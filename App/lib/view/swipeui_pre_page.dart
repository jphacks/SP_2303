import 'package:flutter/material.dart';
import 'package:gohan_map/view/swipeui_page.dart';

class SwipeUIPrePage extends StatefulWidget {
  const SwipeUIPrePage({super.key});

  @override
  State<SwipeUIPrePage> createState() => SwipeUIPrePageState();
}

class SwipeUIPrePageState extends State<SwipeUIPrePage> {
  void reload() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                child: const Text('SwipeUI'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SwipeUIPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
