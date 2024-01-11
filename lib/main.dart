import 'package:app_dac_san/page/trang_dac_san.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App giới thiệu đặc sản Việt Nam',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Trang chủ'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Widget mainPage = const TrangDacSan();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Row(
        children: [
          Container(
            decoration: const BoxDecoration(color: Colors.lightBlueAccent),
            width: 100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      mainPage = const TrangDacSan();
                    });
                  },
                  icon: const Icon(
                    Icons.food_bank,
                    color: Colors.white,
                    size: 48,
                  ),
                  tooltip: "Đặc sản",
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.home,
                    color: Colors.white,
                    size: 48,
                  ),
                  tooltip: "Đặc sản",
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.account_box,
                    color: Colors.white,
                    size: 48,
                  ),
                  tooltip: "Đặc sản",
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.map,
                    color: Colors.white,
                    size: 48,
                  ),
                  tooltip: "Đặc sản",
                ),
              ],
            ),
          ),
          mainPage,
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
