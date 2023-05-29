import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ManageCategory extends StatefulWidget {
  @override
  _ManageCategoryState createState() => _ManageCategoryState();
}

enum SortType {
  Newest,
  Oldest,
}

class _ManageCategoryState extends State<ManageCategory> {
  List<Map<String, dynamic>> categories = [];
  Map<String, dynamic>? selectedCategory;
  bool showModal = false;
  String updatedName = '';
  String updatedImage = '';
  String newCategoryName = '';
  String newCategoryImage = '';
  String selectedImageName = '';
  SortType currentSort = SortType.Newest;

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  void fetchCategories({SortType sortType = SortType.Newest}) async {
    try {
      final response =
          await http.get(Uri.parse('http://10.0.2.2:8000/api/categories'));
      if (response.statusCode == 200) {
        final List<Map<String, dynamic>> fetchedCategories =
            List<Map<String, dynamic>>.from(jsonDecode(response.body));
        setState(() {
          if (sortType == SortType.Newest) {
            categories = fetchedCategories.reversed.toList();
          } else {
            categories = fetchedCategories;
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

  void deleteCategory(int categoryId) async {
    try {
      final response = await http.delete(
          Uri.parse('http://10.0.2.2:8000/api/categories/delete/$categoryId'));
      if (response.statusCode == 200) {
        print(jsonDecode(response.body)['message']);
        fetchCategories(sortType: currentSort);
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
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('http://10.0.2.2:8000/api/categories/create'),
      );

      request.fields['name'] = newCategoryName;

      if (newCategoryImage.isNotEmpty) {
        final imageBytes = await File(newCategoryImage).readAsBytes();
        final imageName = '${DateTime.now().millisecondsSinceEpoch}-image.jpg';
        final image = http.MultipartFile.fromBytes(
          'image',
          imageBytes,
          filename: imageName,
        );
        request.files.add(image);
      }

      final response = await request.send();
      final responseData = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        print(jsonDecode(responseData)['message']);
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

  void _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      final imageFile = File(pickedImage.path);
      final imageName = '${DateTime.now().millisecondsSinceEpoch}-image.jpg';
      final newPath = '${imageFile.parent.path}/$imageName';

      final savedImage = await imageFile.copy(newPath);

      setState(() {
        newCategoryImage = savedImage.path;
      });
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
          title: Text('Chỉnh sửa danh mục món ăn'),
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
                      decoration: InputDecoration(labelText: 'Tên danh mục'),
                    ),
                    TextField(
                      controller: imageController,
                      onChanged: (value) {
                        setState(() {
                          updatedImage = value;
                        });
                      },
                      decoration: InputDecoration(labelText: 'Hình ảnh'),
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
        title: Text('Quản lý danh mục món ăn'),
        actions: [
          PopupMenuButton<SortType>(
            icon: Icon(Icons.sort),
            onSelected: (SortType result) {
              fetchCategories(sortType: result);
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
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return Card(
            elevation: 2,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.green,
                child: Icon(Icons.restaurant_menu, size: 20),
                // backgroundImage: NetworkImage(category['image']),
                radius: 20,
              ),
              title: Text(
                category['name'],
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  'Hình ảnh: ${category['image']}',
                  style: TextStyle(fontSize: 12),
                ),
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
                title: Text('Tạo danh mục món ăn'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      onChanged: (value) {
                        setState(() {
                          newCategoryName = value;
                        });
                      },
                      decoration: InputDecoration(labelText: 'Tên danh mục'),
                    ),
                    GestureDetector(
                      onTap: () {
                        _pickImage();
                      },
                      child: Column(
                        children: [
                          Container(
                            color: Colors.grey[200],
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Icon(Icons.file_upload),
                                  SizedBox(width: 8),
                                  Text('Vui vòng chọn ảnh'),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          newCategoryImage.isNotEmpty
                              ? Image(image: FileImage(File(newCategoryImage)))
                              : Container(), // Hiển thị hình ảnh đã chọn nếu có, ngược lại hiển thị một container trống
                        ],
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      createCategory();
                      Navigator.of(context).pop();
                    },
                    child: Text('Tạo'),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        newCategoryName = '';
                        newCategoryImage = '';
                      });
                      Navigator.of(context).pop();
                    },
                    child: Text('Hủy'),
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
