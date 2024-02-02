import 'package:app_dac_san/features/mua_dac_san/view/trang_mua_dac_san.dart';
import 'package:app_dac_san/features/nguyen_lieu/view/trang_nguyen_lieu.dart';
import 'package:app_dac_san/features/tinh_thanh/view/trang_tinh_thanh.dart';
import 'package:app_dac_san/features/trang_noi_ban.dart';
import 'package:app_dac_san/features/vung_mien/view/trang_vung_mien.dart';
import 'package:flutter/material.dart';

import 'features/dac_san/view/trang_dac_san.dart';
import 'features/nguoi_dung/view/trang_nguoi_dung.dart';

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Trang chủ'),
      debugShowCheckedModeBanner: false,
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
  Widget mainPage = TrangDacSan();

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
            width: 80,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      mainPage = TrangDacSan();
                    });
                  },
                  icon: const Icon(
                    Icons.food_bank,
                    color: Colors.white,
                    size: 32,
                  ),
                  tooltip: "Đặc sản",
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      mainPage = TrangNoiBan();
                    });
                  },
                  icon: const Icon(
                    Icons.home,
                    color: Colors.white,
                    size: 32,
                  ),
                  tooltip: "Nơi bán",
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      mainPage = TrangNguoiDung();
                    });
                  },
                  icon: const Icon(
                    Icons.account_box,
                    color: Colors.white,
                    size: 32,
                  ),
                  tooltip: "Người dùng",
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      mainPage = TrangTinhThanh();
                    });
                  },
                  icon: const Icon(
                    Icons.map,
                    color: Colors.white,
                    size: 32,
                  ),
                  tooltip: "Tỉnh thành",
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      mainPage = TrangNguyenLieu();
                    });
                  },
                  icon: const Icon(
                    Icons.science,
                    color: Colors.white,
                    size: 32,
                  ),
                  tooltip: "Nguyên liệu",
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      mainPage = TrangVungMien();
                    });
                  },
                  icon: const Icon(
                    Icons.place,
                    color: Colors.white,
                    size: 32,
                  ),
                  tooltip: "Vùng miền",
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      mainPage = TrangMuaDacSan();
                    });
                  },
                  icon: const Icon(
                    Icons.shopping_bag,
                    color: Colors.white,
                    size: 32,
                  ),
                  tooltip: "Mùa đặc sản",
                ),
              ],
            ),
          ),
          mainPage,
        ],
      ),
    );
  }
}
