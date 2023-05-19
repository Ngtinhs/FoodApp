import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ManageUsers extends StatefulWidget {
  @override
  _ManageUsersState createState() => _ManageUsersState();
}

class _ManageUsersState extends State<ManageUsers> {
  List<Map<String, dynamic>> users = [];
  late Map<String, dynamic>? selectedUser;
  bool showModal = false;
  String updatedName = '';
  String updatedEmail = '';
  String updatedPhone = '';
  String updatedAddress = '';

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  void fetchUsers() async {
    try {
      final response =
          await http.get(Uri.parse('http://localhost:8000/api/users'));
      if (response.statusCode == 200) {
        setState(() {
          users = List<Map<String, dynamic>>.from(jsonDecode(response.body));
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
          .delete(Uri.parse('http://localhost:8000/api/users/$userId'));
      if (response.statusCode == 200) {
        print(jsonDecode(response.body)['message']);

        fetchUsers();
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
    final userData = {
      'name': updatedName,
      'email': updatedEmail,
      'phone': updatedPhone,
      'address': updatedAddress,
    };

    try {
      final response = await http.put(
        Uri.parse('http://localhost:8000/api/users/${selectedUser?['id']}'),
        body: userData,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Users'),
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return ListTile(
            title: Text(user['name']),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Email: ${user['email']}'),
                Text('Phone: ${user['phone']}'),
                Text('Address: ${user['address']}'),
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
                  onPressed: () => openModal(user),
                ),
              ],
            ),
          );
        },
      ),
      // Modal dialog
      // ...
    );
  }
}
