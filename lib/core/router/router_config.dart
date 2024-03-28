import 'package:app_dac_san/features/dang_nhap/view/trang_dang_nhap.dart';
import 'package:app_dac_san/features/thong_ke/view/trang_thong_ke.dart';
import 'package:app_dac_san/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  initialLocation: "/dangnhap",
  routes: [
    GoRoute(
      path: "/dangnhap",
      name: "TrangDangNhap",
      builder: (context, state) => const TrangDangNhap(),
      redirect: (context, state) {
        if (FirebaseAuth.instance.currentUser != null) {
          if (FirebaseAuth.instance.currentUser!.uid == adminUID) {
            return "/dacsan";
          }
        }
        return null;
      },
    ),
    ShellRoute(
      builder: (context, state, navigationShell) {
        return MyHomePage(page: navigationShell);
      },
      routes: [
        GoRoute(
          path: "/dacsan",
          name: "TrangDacSan",
          builder: (context, state) => TrangDacSan(),
          redirect: (context, state) {
            if (FirebaseAuth.instance.currentUser == null) {
              return "/dangnhap";
            }
            if (FirebaseAuth.instance.currentUser!.uid != adminUID) {
              return "/dangnhap";
            }
            return null;
          },
        ),
        GoRoute(
          path: "/noiban",
          name: "TrangNoiBan",
          builder: (context, state) => TrangNoiBan(),
          redirect: (context, state) {
            if (FirebaseAuth.instance.currentUser == null) {
              return "/dangnhap";
            }
            if (FirebaseAuth.instance.currentUser!.uid != adminUID) {
              return "/dangnhap";
            }
            return null;
          },
        ),
        GoRoute(
          path: "/nguoidung",
          name: "TrangNguoiDung",
          builder: (context, state) => TrangNguoiDung(),
          redirect: (context, state) {
            if (FirebaseAuth.instance.currentUser == null) {
              return "/dangnhap";
            }
            if (FirebaseAuth.instance.currentUser!.uid != adminUID) {
              return "/dangnhap";
            }
            return null;
          },
        ),
        GoRoute(
          path: "/tinhthanh",
          name: "TrangTinhThanh",
          builder: (context, state) => TrangTinhThanh(),
          redirect: (context, state) {
            if (FirebaseAuth.instance.currentUser == null) {
              return "/dangnhap";
            }
            if (FirebaseAuth.instance.currentUser!.uid != adminUID) {
              return "/dangnhap";
            }
            return null;
          },
        ),
        GoRoute(
          path: "/nguyenlieu",
          name: "TrangNguyenLieu",
          builder: (context, state) => TrangNguyenLieu(),
          redirect: (context, state) {
            if (FirebaseAuth.instance.currentUser == null) {
              return "/dangnhap";
            }
            if (FirebaseAuth.instance.currentUser!.uid != adminUID) {
              return "/dangnhap";
            }
            return null;
          },
        ),
        GoRoute(
          path: "/vungmien",
          name: "TrangVungMien",
          builder: (context, state) => TrangVungMien(),
          redirect: (context, state) {
            if (FirebaseAuth.instance.currentUser == null) {
              return "/dangnhap";
            }
            if (FirebaseAuth.instance.currentUser!.uid != adminUID) {
              return "/dangnhap";
            }
            return null;
          },
        ),
        GoRoute(
          path: "/muadacsan",
          name: "TrangMuaDacSan",
          builder: (context, state) => TrangMuaDacSan(),
          redirect: (context, state) {
            if (FirebaseAuth.instance.currentUser == null) {
              return "/dangnhap";
            }
            if (FirebaseAuth.instance.currentUser!.uid != adminUID) {
              return "/dangnhap";
            }
            return null;
          },
        ),
        GoRoute(
          path: "/thongke",
          name: "TrangThongKe",
          builder: (context, state) => const TrangThongKe(),
          redirect: (context, state) {
            if (FirebaseAuth.instance.currentUser == null) {
              return "/dangnhap";
            }
            if (FirebaseAuth.instance.currentUser!.uid != adminUID) {
              return "/dangnhap";
            }
            return null;
          },
        ),
      ],
    )
  ],
);
