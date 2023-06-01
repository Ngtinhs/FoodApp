import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ManageFood extends StatefulWidget {
  @override
  _ManageFoodState createState() => _ManageFoodState();
}

enum SortType {
  Newest,
  Oldest,
}

class _ManageFoodState extends State<ManageFood> {
  List<Map<String, dynamic>> foods = [];
  Map<String, dynamic>? selectedFood;
  List<Map<String, dynamic>> categories = [];
  Map<String, dynamic>? selectedCategory;

  bool showModal = false;
  String updatedName = '';
  String updatedImage = '';
  String updatedPrice = '';
  String updatedDetail = '';
  String updatedQuantity = '';
  String newFoodName = '';
  String newFoodImage = '';
  String newFoodPrice = '';
  String newFoodDetail = '';
  String newFoodQuantity = '';
  String selectedImageName = '';
  SortType currentSort = SortType.Newest;

  @override
  void initState() {
    super.initState();
    fetchFoods();
    fetchCategories();
  }

  void fetchFoods({SortType sortType = SortType.Newest}) async {
    try {
      final response = await http
          .get(Uri.parse('http://10.0.2.2:8000/api/product/tatcasanpham'));
      if (response.statusCode == 200) {
        final List<Map<String, dynamic>> fetchedFoods =
            List<Map<String, dynamic>>.from(jsonDecode(response.body));
        setState(() {
          if (sortType == SortType.Newest) {
            foods = fetchedFoods.reversed.toList();
          } else {
            foods = fetchedFoods;
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

  void deleteFood(int foodId) async {
    try {
      final response = await http
          .delete(Uri.parse('http://10.0.2.2:8000/api/product/delete/$foodId'));
      if (response.statusCode == 200) {
        print(jsonDecode(response.body)['message']);
        fetchFoods(sortType: currentSort);
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  void openModal(Map<String, dynamic> food) {
    setState(() {
      selectedFood = food;
      updatedName = food['name'];
      updatedImage = food['image'];
      updatedPrice = food['price'].toString(); // Chuyển đổi sang kiểu String
      updatedDetail = food['detail'];
      updatedQuantity =
          food['quantity'].toString(); // Chuyển đổi sang kiểu String
      showModal = true;
      selectedCategory = categories.firstWhere(
          (category) => category['id'] == food['categoryId'].toString(),
          orElse: () => Map<String, dynamic>());
    });
  }

  void closeModal() {
    setState(() {
      selectedFood = null;
      updatedName = '';
      updatedImage = '';
      updatedPrice = '';
      updatedDetail = '';
      updatedQuantity = '';
      showModal = false;
    });
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

  void updateFood() async {
    if (selectedFood != null) {
      final foodData = {
        'name': updatedName,
        'image': updatedImage,
        'price': updatedPrice,
        'detail': updatedDetail,
        'quantity': updatedQuantity,
        'categoryId': selectedCategory?['id'],
      };

      try {
        final response = await http.put(
          Uri.parse(
              'http://10.0.2.2:8000/api/product/update/${selectedFood?['id']}'),
          body: jsonEncode(foodData),
          headers: {'Content-Type': 'application/json'},
        );

        if (response.statusCode == 200) {
          print(jsonDecode(response.body)['message']);

          final updatedFoods = foods.map<Map<String, dynamic>>((food) {
            if (food['id'] == selectedFood?['id']) {
              return {...food, ...foodData};
            }
            return food;
          }).toList();

          setState(() {
            foods = updatedFoods;
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

  void createFood() async {
    final foodData = {
      'name': updatedName,
      'image': updatedImage,
      'price': updatedPrice,
      'detail': updatedDetail,
      'quantity': updatedQuantity,
      'categoryId': selectedCategory?['id'],
    };

    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('http://10.0.2.2:8000/api/product/create'),
      );

      request.fields['name'] = newFoodName;
      request.fields['price'] = newFoodPrice;
      request.fields['detail'] = newFoodDetail;
      request.fields['quantity'] = newFoodQuantity;

      if (newFoodImage.isNotEmpty) {
        final imageBytes = await File(newFoodImage).readAsBytes();
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
        fetchFoods();
        setState(() {
          newFoodName = '';
          newFoodImage = '';
          newFoodPrice = '';
          newFoodDetail = '';
          newFoodQuantity = '';
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
        newFoodImage = savedImage.path;
      });
    }
  }

  void _showEditDialog(
    BuildContext context,
    Map<String, dynamic> food,
    Map<String, dynamic>? selectedCategory,
  ) {
    setState(() {
      selectedFood = food;
      updatedName = food['name'];
      updatedImage = food['image'];
      updatedPrice = food['price'].toString(); // Chuyển đổi sang kiểu String
      updatedDetail = food['detail'];
      updatedQuantity =
          food['quantity'].toString(); // Chuyển đổi sang kiểu String
      showModal = true;
    });

    final nameController = TextEditingController(text: updatedName);
    final imageController = TextEditingController(text: updatedImage);
    final priceController = TextEditingController(text: updatedPrice);
    final detailController = TextEditingController(text: updatedDetail);
    final quantityController = TextEditingController(text: updatedQuantity);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Food'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<dynamic>(
                      value: selectedCategory,
                      onChanged: (newValue) {
                        setState(() {
                          if (newValue is int) {
                            selectedCategory = categories[newValue];
                          } else {
                            selectedCategory = newValue as Map<String, dynamic>;
                          }
                        });
                      },
                      items: categories.map((category) {
                        return DropdownMenuItem<dynamic>(
                          value: category,
                          child: Text(category['name']),
                        );
                      }).toList(),
                      decoration: InputDecoration(labelText: 'Danh mục'),
                    ),
                    TextField(
                      controller: nameController,
                      onChanged: (value) {
                        setState(() {
                          updatedName = value;
                        });
                      },
                      decoration: InputDecoration(labelText: 'Tên món ăn'),
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
                    TextField(
                      controller: priceController,
                      onChanged: (value) {
                        setState(() {
                          updatedPrice = value;
                        });
                      },
                      decoration: InputDecoration(labelText: 'Giá'),
                    ),
                    TextField(
                      controller: detailController,
                      onChanged: (value) {
                        setState(() {
                          updatedDetail = value;
                        });
                      },
                      decoration: InputDecoration(labelText: 'Mô tả'),
                    ),
                    TextField(
                      controller: quantityController,
                      onChanged: (value) {
                        setState(() {
                          updatedQuantity = value;
                        });
                      },
                      decoration: InputDecoration(labelText: 'Số lượng'),
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
                  updatedPrice = priceController.text;
                  updatedDetail = detailController.text;
                  updatedQuantity = quantityController.text;
                });
                updateFood();
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
        title: Text('Quản lý món ăn'),
        actions: [
          PopupMenuButton<SortType>(
            icon: Icon(Icons.sort),
            onSelected: (SortType result) {
              fetchFoods(sortType: result);
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
        itemCount: foods.length,
        itemBuilder: (context, index) {
          final food = foods[index];
          return Card(
            elevation: 2,
            child: ListTile(
              title: Text(
                food['name'],
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Giá: ${food['price']}',
                    style: TextStyle(fontSize: 14),
                  ),
                  Text(
                    'Mô tả: ${food['detail']}',
                    style: TextStyle(fontSize: 14),
                  ),
                  Text(
                    'Số lượng: ${food['quantity']}',
                    style: TextStyle(fontSize: 14),
                  ),
                  Text(
                    'Danh mục: ${food['category']}',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => deleteFood(food['id']),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () =>
                        _showEditDialog(context, food, selectedCategory),
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
                title: Text('Tạo món ăn'),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            newFoodName = value;
                          });
                        },
                        decoration: InputDecoration(labelText: 'Tên món'),
                      ),
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            newFoodPrice = value;
                          });
                        },
                        decoration: InputDecoration(labelText: 'Giá'),
                      ),
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            newFoodDetail = value;
                          });
                        },
                        decoration: InputDecoration(labelText: 'Mô tả'),
                      ),
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            newFoodQuantity = value;
                          });
                        },
                        decoration: InputDecoration(labelText: 'Số lượng'),
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
                                    Text('Chọn hình ảnh'),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                            newFoodImage.isNotEmpty
                                ? Image.file(
                                    File(newFoodImage),
                                    width: 150,
                                    height: 150,
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      createFood();
                      Navigator.of(context).pop();
                    },
                    child: Text('Tạo'),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        newFoodName = '';
                        newFoodImage = '';
                        newFoodPrice = '';
                        newFoodDetail = '';
                        newFoodQuantity = '';
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
