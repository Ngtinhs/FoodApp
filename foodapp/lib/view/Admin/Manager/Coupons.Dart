import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ManageCoupon extends StatefulWidget {
  @override
  _ManageCouponState createState() => _ManageCouponState();
}

enum SortType {
  Newest,
  Oldest,
}

class _ManageCouponState extends State<ManageCoupon> {
  List<Map<String, dynamic>> coupons = [];
  Map<String, dynamic>? selectedCoupon;
  bool showModal = false;
  String updatedCode = '';
  String updatedCount = '';
  String updatedPromotion = '';
  String updatedDescription = '';
  SortType currentSort = SortType.Newest;

  @override
  void initState() {
    super.initState();
    fetchCoupons();
  }

  void fetchCoupons({SortType sortType = SortType.Newest}) async {
    try {
      final response =
          await http.get(Uri.parse('http://10.0.2.2:8000/api/coupon'));
      if (response.statusCode == 200) {
        final List<Map<String, dynamic>> fetchedCoupons =
            List<Map<String, dynamic>>.from(jsonDecode(response.body));

        setState(() {
          if (sortType == SortType.Newest) {
            coupons = fetchedCoupons.reversed.toList();
          } else {
            coupons = fetchedCoupons;
          }
          currentSort = sortType;
        });
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  void deleteCoupon(int couponId) async {
    try {
      final response = await http
          .delete(Uri.parse('http://10.0.2.2:8000/api/coupon/delete/$couponId'));
      if (response.statusCode == 200) {
        print(jsonDecode(response.body)['message']);

        fetchCoupons(sortType: currentSort);
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  void openModal(Map<String, dynamic> coupon) {
    setState(() {
      selectedCoupon = coupon;
      updatedCode = coupon['code'];
      updatedCount = coupon['count'].toString();
      updatedPromotion = coupon['promotion'].toString();
      updatedDescription = coupon['description'];
      showModal = true;
    });
  }

  void closeModal() {
    setState(() {
      selectedCoupon = null;
      updatedCode = '';
      updatedCount = '';
      updatedPromotion = '';
      updatedDescription = '';
      showModal = false;
    });
  }

  void updateCoupon() async {
    if (selectedCoupon != null) {
      final couponData = {
        'code': updatedCode,
        'count': updatedCount,
        'promotion': updatedPromotion,
        'description': updatedDescription,
      };

      try {
        final response = await http.put(
          Uri.parse('http://10.0.2.2:8000/api/coupon/update/${selectedCoupon?['id']}'),
          body: jsonEncode(couponData),
          headers: {'Content-Type': 'application/json'},
        );
        if (response.statusCode == 200) {
          print(jsonDecode(response.body)['message']);

          final updatedCoupons = coupons.map<Map<String, dynamic>>((coupon) {
            if (coupon['id'] == selectedCoupon?['id']) {
              return {...coupon, ...couponData};
            }
            return coupon;
          }).toList();

          setState(() {
            coupons = updatedCoupons;
            closeModal();
          });
        } else {
          print('Request failed with status: ${response.statusCode}');
        }
      } catch (error) {
        print('Error: $error');
      }
    }
  }

  void _showEditDialog(BuildContext context, Map<String, dynamic> coupon) {
    // Sử dụng dữ liệu của mã khuyến mãi được chọn
    setState(() {
      selectedCoupon = coupon;
      updatedCode = coupon['code'];
      updatedCount = coupon['count'].toString();
      updatedPromotion = coupon['promotion'].toString();
      updatedDescription = coupon['description'];
      showModal = true;
    });

    final codeController = TextEditingController(text: updatedCode);
    final countController = TextEditingController(text: updatedCount);
    final promotionController = TextEditingController(text: updatedPromotion);
    final descriptionController =
        TextEditingController(text: updatedDescription);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Chỉnh sửa mã khuyến mãi'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: codeController,
                      onChanged: (value) {
                        setState(() {
                          updatedCode = value;
                        });
                      },
                      decoration: InputDecoration(labelText: 'Mã'),
                    ),
                    TextField(
                      controller: countController,
                      onChanged: (value) {
                        setState(() {
                          updatedCount = value;
                        });
                      },
                      decoration: InputDecoration(labelText: 'Số lượng'),
                    ),
                    TextField(
                      controller: promotionController,
                      onChanged: (value) {
                        setState(() {
                          updatedPromotion = value;
                        });
                      },
                      decoration: InputDecoration(labelText: 'Khuyến mãi'),
                    ),
                    TextField(
                      controller: descriptionController,
                      onChanged: (value) {
                        setState(() {
                          updatedDescription = value;
                        });
                      },
                      decoration: InputDecoration(labelText: 'Mô tả'),
                    ),
                  ],
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Sử dụng giá trị từ các controllers
                setState(() {
                  updatedCode = codeController.text;
                  updatedCount = countController.text;
                  updatedPromotion = promotionController.text;
                  updatedDescription = descriptionController.text;
                });
                updateCoupon();
                Navigator.of(context).pop();
              },
              child: Text('Cập nhật'),
            ),
            TextButton(
              onPressed: () {
                closeModal();
                Navigator.of(context).pop();
              },
              child: Text('Hủy'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quản lý mã khuyến mãi'),
        actions: [
          PopupMenuButton<SortType>(
            icon: Icon(Icons.sort),
            onSelected: (SortType result) {
              fetchCoupons(sortType: result);
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<SortType>>[
              const PopupMenuItem<SortType>(
                value: SortType.Newest,
                child: Text('Mới nhất'),
              ),
              const PopupMenuItem<SortType>(
                value: SortType.Oldest,
                child: Text('Cũ nhất'),
              ),
            ],
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: coupons.length,
        itemBuilder: (context, index) {
          final coupon = coupons[index];
          return Card(
            elevation: 2,
            child: ListTile(
              title: Text(
                coupon['code'],
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 4),
                  Text(
                    'Số lượng: ${coupon['count']}',
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Khuyến mãi: ${coupon['promotion']}',
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Mô tả: ${coupon['description']}',
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(height: 8),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => deleteCoupon(coupon['id']),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => _showEditDialog(context, coupon),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
