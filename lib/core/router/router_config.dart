import 'package:app_dac_san/features/thong_ke/view/trang_thong_ke.dart';
import 'package:app_dac_san/main.dart';
import 'package:go_router/go_router.dart';

import '../../features/dac_san/view/trang_dac_san.dart';
import '../../features/mua_dac_san/view/trang_mua_dac_san.dart';
import '../../features/nguoi_dung/view/trang_nguoi_dung.dart';
import '../../features/nguyen_lieu/view/trang_nguyen_lieu.dart';
import '../../features/noi_ban/view/trang_noi_ban.dart';
import '../../features/tinh_thanh/view/trang_tinh_thanh.dart';
import '../../features/vung_mien/view/trang_vung_mien.dart';

final router = GoRouter(
  initialExtra: null,
  initialLocation: "/dacsan",
  routes: [
    ShellRoute(
      builder: (context, state, navigationShell) {
        return MyHomePage(page: navigationShell);
      },
      routes: [
        GoRoute(
          path: "/dacsan",
          name: "TrangDacSan",
          builder: (context, state) => TrangDacSan(),
        ),
        GoRoute(
          path: "/noiban",
          name: "TrangNoiBan",
          builder: (context, state) => TrangNoiBan(),
        ),
        GoRoute(
          path: "/nguoidung",
          name: "TrangNguoiDung",
          builder: (context, state) => TrangNguoiDung(),
        ),
        GoRoute(
          path: "/tinhthanh",
          name: "TrangTinhThanh",
          builder: (context, state) => TrangTinhThanh(),
        ),
        GoRoute(
          path: "/nguyenlieu",
          name: "TrangNguyenLieu",
          builder: (context, state) => TrangNguyenLieu(),
        ),
        GoRoute(
          path: "/vungmien",
          name: "TrangVungMien",
          builder: (context, state) => TrangVungMien(),
        ),
        GoRoute(
          path: "/muadacsan",
          name: "TrangMuaDacSan",
          builder: (context, state) => TrangMuaDacSan(),
        ),
        GoRoute(
          path: "/thongke",
          name: "TrangThongKe",
          builder: (context, state) => const TrangThongKe(),
        ),
      ],
    )
  ],
);
