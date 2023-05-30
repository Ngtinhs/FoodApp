import 'package:flutter/material.dart';
import 'package:foodapp/api/UserApi.dart';

class ManageUsers extends StatefulWidget {
  @override
  _ManageUsersState createState() => _ManageUsersState();
}

enum SortType {
  Newest,
  Oldest,
}

class _ManageUsersState extends State<ManageUsers> {
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
    final fetchedUsers = await UserApi.fetchUsers();

    setState(() {
      if (sortType == SortType.Newest) {
        users = fetchedUsers.reversed.toList();
      } else {
        users = fetchedUsers;
      }
      currentSort = sortType;
    });
  }

  void deleteUser(int userId) async {
    final success = await UserApi.deleteUser(userId);

    if (success) {
      fetchUsers(sortType: currentSort);
    }
  }

  void updateUser() async {
    if (selectedUser != null) {
      final userData = {
        'name': updatedName,
        'email': updatedEmail,
        'phone': updatedPhone,
        'address': updatedAddress,
      };

      final success = await UserApi.updateUser(selectedUser?['id'], userData);

      if (success) {
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
      }
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
