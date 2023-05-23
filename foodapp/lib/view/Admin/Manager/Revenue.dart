import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:charts_flutter/flutter.dart' as charts;

class Revenue extends StatefulWidget {
  const Revenue({Key? key}) : super(key: key);

  @override
  _RevenueState createState() => _RevenueState();
}

class _RevenueState extends State<Revenue> {
  late int totalRevenue;
  bool isLoading = true;
  List<charts.Series<dynamic, String>> chartData = [];
  List<dynamic> revenueData = [];
  List<dynamic> filteredData = [];
  DateTime? filterStartDate;
  DateTime? filterEndDate;

  Future<int> _fetchTotalRevenue() async {
    final response =
        await http.get(Uri.parse('http://10.0.2.2:8000/api/cart/revenue'));
    if (response.statusCode == 200) {
      final jsonResult = jsonDecode(response.body);
      final revenue = int.parse(jsonResult['totalRevenue']);
      return revenue;
    } else {
      throw Exception('Failed to load total revenue');
    }
  }

  Future<void> _fetchRevenueData() async {
    final response =
        await http.get(Uri.parse('http://10.0.2.2:8000/api/cart/doanhthungay'));
    if (response.statusCode == 200) {
      final jsonResult = jsonDecode(response.body);
      setState(() {
        revenueData = jsonResult;
      });
    } else {
      throw Exception('Failed to load revenue data');
    }
  }

  void filterChartData() {
    setState(() {
      filteredData = revenueData.where((revenueItem) {
        final date = DateTime.parse(revenueItem.keys.first);
        return filterStartDate != null && filterEndDate != null
            ? date.isAfter(
                    filterStartDate!.subtract(const Duration(days: 1))) &&
                date.isBefore(filterEndDate!.add(const Duration(days: 1)))
            : false;
      }).toList();

      final chartDataValues =
          filteredData.map((revenueItem) => revenueItem.values.first).toList();

      chartData = [
        charts.Series<dynamic, String>(
          id: 'Tổng doanh thu',
          domainFn: (dynamic item, _) => item.keys.first,
          measureFn: (dynamic item, _) => item.values.first,
          data: filteredData,
          fillColorFn: (_, __) => charts.ColorUtil.fromDartColor(Colors.blue),
          colorFn: (_, __) => charts.ColorUtil.fromDartColor(Colors.blue),
        ),
      ];
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchTotalRevenue().then((revenue) {
      setState(() {
        totalRevenue = revenue;
        isLoading = false;
      });
    });
    _fetchRevenueData();
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: filterStartDate ?? DateTime.now(),
      firstDate: DateTime(2010),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        filterStartDate = pickedDate;
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: filterEndDate ?? DateTime.now(),
      firstDate: DateTime(2010),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        filterEndDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quản lý doanh thu"),
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Tổng doanh thu:',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              isLoading
                  ? const CircularProgressIndicator()
                  : Text(
                      '$totalRevenue',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
              const SizedBox(height: 20),
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () => _selectStartDate(context),
                    child: Text(
                      filterStartDate != null
                          ? 'Ngày bắt đầu: ${filterStartDate!.toString().split(' ')[0]}'
                          : 'Chọn ngày bắt đầu',
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => _selectEndDate(context),
                    child: Text(
                      filterEndDate != null
                          ? 'Ngày kết thúc: ${filterEndDate!.toString().split(' ')[0]}'
                          : 'Chọn ngày kết thúc',
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      filterChartData();
                    },
                    child: const Text('Lọc'),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: filteredData.isNotEmpty
                    ? charts.BarChart(
                        chartData,
                        animate: true,
                      )
                    : filteredData.isEmpty &&
                            (filterStartDate != null || filterEndDate != null)
                        ? const Text(
                            'Không có dữ liệu trong khoảng thời gian đã chọn.')
                        : const SizedBox(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
