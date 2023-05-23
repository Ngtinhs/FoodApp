import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ManageCategory extends StatefulWidget {
  @override
  _ManageCategoryState createState() => _ManageCategoryState();
}

class _ManageCategoryState extends State<ManageCategory> {
  List<Map<String, dynamic>> categories = [];
  Map<String, dynamic>? selectedCategory;
  bool showModal = false;
  String updatedName = '';
  String updatedImage = '';
  String newCategoryName = '';
  String newCategoryImage = '';

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  void fetchCategories() async {
    try {
      final response =
          await http.get(Uri.parse('http://10.0.2.2:8000/api/categories'));
      if (response.statusCode == 200) {
        setState(() {
          categories =
              List<Map<String, dynamic>>.from(jsonDecode(response.body));
        });
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  void deleteCategory(int categoryId) async {
    try {
      final response = await http.delete(
          Uri.parse('http://10.0.2.2:8000/api/categories/delete/$categoryId'));
      if (response.statusCode == 200) {
        print(jsonDecode(response.body)['message']);
        fetchCategories();
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  void openModal(Map<String, dynamic> category) {
    setState(() {
      selectedCategory = category;
      updatedName = category['name'];
      updatedImage = category['image'];
      showModal = true;
    });
  }

  void closeModal() {
    setState(() {
      selectedCategory = null;
      updatedName = '';
      updatedImage = '';
      showModal = false;
    });
  }

  void updateCategory() async {
    if (selectedCategory != null) {
      final categoryData = {
        'name': updatedName,
        'image': updatedImage,
      };

      try {
        final response = await http.put(
          Uri.parse(
              'http://10.0.2.2:8000/api/categories/update/${selectedCategory?['id']}'),
          body: jsonEncode(categoryData),
          headers: {'Content-Type': 'application/json'},
        );
        if (response.statusCode == 200) {
          print(jsonDecode(response.body)['message']);

          final updatedCategories =
              categories.map<Map<String, dynamic>>((category) {
            if (category['id'] == selectedCategory?['id']) {
              return {...category, ...categoryData};
            }
            return category;
          }).toList();

          setState(() {
            categories = updatedCategories;
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

  void createCategory() async {
    final categoryData = {
      'name': newCategoryName,
      'image': newCategoryImage,
    };

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8000/api/categories/create'),
        body: jsonEncode(categoryData),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        print(jsonDecode(response.body)['message']);
        fetchCategories();
        setState(() {
          newCategoryName = '';
          newCategoryImage = '';
        });
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  void _showEditDialog(BuildContext context, Map<String, dynamic> category) {
    setState(() {
      selectedCategory = category;
      updatedName = category['name'];
      updatedImage = category['image'];
      showModal = true;
    });

    final nameController = TextEditingController(text: updatedName);
    final imageController = TextEditingController(text: updatedImage);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Category'),
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
                      decoration: InputDecoration(labelText: 'Name'),
                    ),
                    TextField(
                      controller: imageController,
                      onChanged: (value) {
                        setState(() {
                          updatedImage = value;
                        });
                      },
                      decoration: InputDecoration(labelText: 'Image URL'),
                    ),
                  ],
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  updatedName = nameController.text;
                  updatedImage = imageController.text;
                });
                updateCategory();
                Navigator.of(context).pop();
              },
              child: Text('Update'),
            ),
            TextButton(
              onPressed: () {
                closeModal();
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
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
        title: Text('Manage Categories'),
      ),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return ListTile(
            title: Text(category['name']),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Image URL: ${category['image']}'),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => deleteCategory(category['id']),
                ),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => _showEditDialog(context, category),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Create Category'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      onChanged: (value) {
                        setState(() {
                          newCategoryName = value;
                        });
                      },
                      decoration: InputDecoration(labelText: 'Name'),
                    ),
                    TextField(
                      onChanged: (value) {
                        setState(() {
                          newCategoryImage = value;
                        });
                      },
                      decoration: InputDecoration(labelText: 'Image URL'),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      createCategory();
                      Navigator.of(context).pop();
                    },
                    child: Text('Create'),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        newCategoryName = '';
                        newCategoryImage = '';
                      });
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancel'),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
