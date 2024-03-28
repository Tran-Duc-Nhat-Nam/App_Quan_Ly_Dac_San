import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/gui_helper.dart';
import '../bloc/thong_ke_bloc.dart';

class TrangThongKe extends StatefulWidget {
  const TrangThongKe({super.key});

  @override
  State<TrangThongKe> createState() => _TrangThongKeState();
}

class _TrangThongKeState extends State<TrangThongKe> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ThongKeBloc()..add(LoadDataEvent()),
      child: BlocBuilder<ThongKeBloc, ThongKeState>(
        // Widget hiển thị sau khi đọc dữ liệu từ API thành công
        builder: (context, state) {
          if (state is ThongKeInitial) {
            return loadingCircle();
          } else if (state is ThongKeLoaded) {
            if (state.errorMessage != null) {
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                showNotify(context, state.errorMessage!);
              });
            }

            return Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Flexible(
                  flex: 1,
                  child: Column(
                    children: [
                      Flexible(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                const Text("Thống kê đặc sản"),
                                Flexible(
                                  flex: 1,
                                  child: BarChart(
                                    BarChartData(
                                        maxY: state.dsDacSan
                                            .map<double>(
                                                (e) => e.luotXem.toDouble())
                                            .reduce(max),
                                        titlesData: FlTitlesData(
                                          bottomTitles: AxisTitles(
                                              sideTitles: SideTitles(
                                            showTitles: true,
                                            getTitlesWidget: (value, meta) =>
                                                Text(state.dsDacSan
                                                    .firstWhere((element) =>
                                                        element.id == value)
                                                    .ten),
                                          )),
                                        ),
                                        barGroups: state.dsDacSan
                                            .map((dacSan) => BarChartGroupData(
                                                    x: dacSan.id,
                                                    barRods: [
                                                      BarChartRodData(
                                                          toY: dacSan.luotXem
                                                              .toDouble())
                                                    ]))
                                            .toList()),
                                  ),
                                ),
                              ],
                            ),
                          )),
                      Flexible(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                const Text("Thống kê người dùng"),
                                Flexible(
                                  flex: 1,
                                  child: BarChart(
                                    BarChartData(
                                        maxY: state.dsNguoiDung
                                            .map<double>((e) => e
                                                .lichSuXemDacSan.length
                                                .toDouble())
                                            .reduce(max),
                                        titlesData: FlTitlesData(
                                          bottomTitles: AxisTitles(
                                              sideTitles: SideTitles(
                                            showTitles: true,
                                            getTitlesWidget: (value, meta) =>
                                                Text(state
                                                    .dsNguoiDung[
                                                        value.toInt() - 1]
                                                    .ten),
                                          )),
                                        ),
                                        barGroups: state.dsNguoiDung
                                            .map((nd) => BarChartGroupData(
                                                    x: state.dsNguoiDung
                                                            .indexOf(nd) +
                                                        1,
                                                    barRods: [
                                                      BarChartRodData(
                                                          toY: nd
                                                              .lichSuXemDacSan
                                                              .length
                                                              .toDouble())
                                                    ]))
                                            .toList()),
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ],
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Column(
                    children: [
                      Flexible(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                const Text("Thống kê đặc sản"),
                                Flexible(
                                  flex: 1,
                                  child: BarChart(
                                    BarChartData(
                                        maxY: 5,
                                        titlesData: FlTitlesData(
                                          bottomTitles: AxisTitles(
                                              sideTitles: SideTitles(
                                            showTitles: true,
                                            getTitlesWidget: (value, meta) =>
                                                Text(state.dsDacSan
                                                    .firstWhere((element) =>
                                                        element.id == value)
                                                    .ten),
                                          )),
                                        ),
                                        barGroups: state.dsDacSan
                                            .map((dacSan) => BarChartGroupData(
                                                    x: dacSan.id,
                                                    barRods: [
                                                      BarChartRodData(
                                                          toY: dacSan
                                                              .diemDanhGia
                                                              .toDouble())
                                                    ]))
                                            .toList()),
                                  ),
                                ),
                              ],
                            ),
                          )),
                      Flexible(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                const Text("Thống kê nơi bán"),
                                Flexible(
                                  flex: 1,
                                  child: BarChart(
                                    BarChartData(
                                        maxY: 5,
                                        titlesData: FlTitlesData(
                                          bottomTitles: AxisTitles(
                                              sideTitles: SideTitles(
                                            showTitles: true,
                                            getTitlesWidget: (value, meta) =>
                                                Text(state.dsNoiBan
                                                    .firstWhere((element) =>
                                                        element.id == value)
                                                    .ten),
                                          )),
                                        ),
                                        barGroups: state.dsNoiBan
                                            .map((noiBan) => BarChartGroupData(
                                                    x: noiBan.id,
                                                    barRods: [
                                                      BarChartRodData(
                                                          toY: noiBan
                                                              .diemDanhGia
                                                              .toDouble())
                                                    ]))
                                            .toList()),
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return const Placeholder();
          }
        },
      ),
    );
  }
}
