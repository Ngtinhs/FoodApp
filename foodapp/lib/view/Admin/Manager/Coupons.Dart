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
  List<Map<String, dynamic>> users = [];
  Map<String, dynamic>? selectedUser;
  bool showModal = false;
  String updatedName = '';
  String updatedEmail = '';
  String updatedPhone = '';
  String updatedAddress = '';
  SortType currentSort = SortType.Newest;

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  void fetchUsers({SortType sortType = SortType.Newest}) async {
    try {
      final response =
          await http.get(Uri.parse('http://10.0.2.2:8000/api/users'));
      if (response.statusCode == 200) {
        final List<Map<String, dynamic>> fetchedUsers =
            List<Map<String, dynamic>>.from(jsonDecode(response.body));

        setState(() {
          if (sortType == SortType.Newest) {
            users = fetchedUsers.reversed.toList();
          } else {
            users = fetchedUsers;
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

  void deleteUser(int userId) async {
    try {
      final response = await http
          .delete(Uri.parse('http://10.0.2.2:8000/api/users/$userId'));
      if (response.statusCode == 200) {
        print(jsonDecode(response.body)['message']);

        fetchUsers(sortType: currentSort);
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  void openModal(Map<String, dynamic> user) {
    setState(() {
      selectedUser = user;
      updatedName = user['name'];
      updatedEmail = user['email'];
      updatedPhone = user['phone'];
      updatedAddress = user['address'];
      showModal = true;
    });
  }

  void closeModal() {
    setState(() {
      selectedUser = null;
      updatedName = '';
      updatedEmail = '';
      updatedPhone = '';
      updatedAddress = '';
      showModal = false;
    });
  }

  void updateUser() async {
    if (selectedUser != null) {
      final userData = {
        'name': updatedName,
        'email': updatedEmail,
        'phone': updatedPhone,
        'address': updatedAddress,
      };

      try {
        final response = await http.put(
          Uri.parse('http://10.0.2.2:8000/api/users/${selectedUser?['id']}'),
          body: jsonEncode(userData),
          headers: {'Content-Type': 'application/json'},
        );
        if (response.statusCode == 200) {
          print(jsonDecode(response.body)['message']);

          final updatedUsers = users.map<Map<String, dynamic>>((user) {
            if (user['id'] == selectedUser?['id']) {
              return {...user, ...userData};
            }
            return user;
          }).toList();

          setState(() {
            users = updatedUsers;
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

  void _showEditDialog(BuildContext context, Map<String, dynamic> user) {
    // Sử dụng dữ liệu của người dùng được chọn
    setState(() {
      selectedUser = user;
      updatedName = user['name'];
      updatedEmail = user['email'];
      updatedPhone = user['phone'];
      updatedAddress = user['address'];
      showModal = true;
    });

    final nameController = TextEditingController(text: updatedName);
    final emailController = TextEditingController(text: updatedEmail);
    final phoneController = TextEditingController(text: updatedPhone);
    final addressController = TextEditingController(text: updatedAddress);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Chỉnh sửa người dùng'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      onChanged: (value) {
                        setState(() {
                          updatedName = value;
                        });
                      },
                      decoration: InputDecoration(labelText: 'Tên'),
                    ),
                    TextField(
                      controller: emailController,
                      onChanged: (value) {
                        setState(() {
                          updatedEmail = value;
                        });
                      },
                      decoration: InputDecoration(labelText: 'Email'),
                    ),
                    TextField(
                      controller: phoneController,
                      onChanged: (value) {
                        setState(() {
                          updatedPhone = value;
                        });
                      },
                      decoration: InputDecoration(labelText: 'Số điện thoại'),
                    ),
                    TextField(
                      controller: addressController,
                      onChanged: (value) {
                        setState(() {
                          updatedAddress = value;
                        });
                      },
                      decoration: InputDecoration(labelText: 'Địa chỉ'),
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
                  updatedName = nameController.text;
                  updatedEmail = emailController.text;
                  updatedPhone = phoneController.text;
                  updatedAddress = addressController.text;
                });
                updateUser();
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
        title: Text('Quản lý người dùng'),
        actions: [
          PopupMenuButton<SortType>(
            icon: Icon(Icons.sort),
            onSelected: (SortType result) {
              fetchUsers(sortType: result);
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
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return Card(
            elevation: 2,
            child: ListTile(
              title: Text(
                user['name'],
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 4),
                  Text(
                    'Email: ${user['email']}',
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Số điện thoại: ${user['phone']}',
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Địa chỉ: ${user['address']}',
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
                    onPressed: () => deleteUser(user['id']),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => _showEditDialog(context, user),
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
