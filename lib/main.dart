import 'package:app_dac_san/core/router/router_config.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

bool isDark = false;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Trang web quản lý dữ liệu đặc sản Việt Nam',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
          brightness: Brightness.light),
      darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blue, brightness: Brightness.dark),
          useMaterial3: true,
          brightness: Brightness.dark),
      // home: MyHomePage(changeTheme: changeTheme),
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.page, required this.changeTheme});

  final Widget page;
  final void Function() changeTheme;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Widget mainPage = TrangDacSan();
  int position = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Trang quản lý dữ liệu"),
        actions: [
          IconButton(
              onPressed: widget.changeTheme, icon: const Icon(Icons.dark_mode))
        ],
      ),
      body: Row(
        children: [
          Container(
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.inversePrimary),
            width: 90,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                sideBarItem("/dacsan", 1, "Đặc sản", Icons.food_bank_outlined,
                    Icons.food_bank),
                sideBarItem(
                    "/noiban", 2, "Nơi bán", Icons.home_outlined, Icons.home),
                sideBarItem("/nguoidung", 3, "Người dùng",
                    Icons.account_box_outlined, Icons.account_box),
                sideBarItem("/tinhthanh", 4, "Tỉnh thành", Icons.map_outlined,
                    Icons.map),
                sideBarItem("/nguyenlieu", 5, "Nguyên liệu",
                    Icons.science_outlined, Icons.science),
                sideBarItem("/vungmien", 6, "Vùng miền", Icons.place_outlined,
                    Icons.place),
                sideBarItem("/muadacsan", 7, "Mùa", Icons.ac_unit_outlined,
                    Icons.ac_unit),
              ],
            ),
          ),
          Flexible(flex: 1, child: widget.page),
        ],
      ),
    );
  }

  Column sideBarItem(String url, int index, String name, IconData icon,
      IconData selectedIcon) {
    return Column(
      children: [
        IconButton(
          onPressed: () {
            setState(() {
              position = index;
              context.go(url);
            });
          },
          isSelected: GoRouter.of(context)
                  .routeInformationProvider
                  .value
                  .uri
                  .toString() ==
              url,
          icon: Icon(
            icon,
            color: Theme.of(context).colorScheme.inverseSurface,
            size: 32,
          ),
          selectedIcon: Icon(
            selectedIcon,
            color: Theme.of(context).colorScheme.primary,
            size: 32,
          ),
        ),
        Text(
          name,
          style: TextStyle(
              color: position == index
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.inverseSurface,
              fontWeight: FontWeight.w800),
        )
      ],
    );
  }
}
