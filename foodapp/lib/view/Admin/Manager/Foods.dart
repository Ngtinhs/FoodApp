import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ManageFood extends StatefulWidget {
  @override
  _ManageFoodState createState() => _ManageFoodState();
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

  @override
  void initState() {
    super.initState();
    fetchFoods();
    fetchCategories();
  }

  void fetchFoods() async {
    try {
      final response = await http
          .get(Uri.parse('http://10.0.2.2:8000/api/product/tatcasanpham'));
      if (response.statusCode == 200) {
        setState(() {
          foods = List<Map<String, dynamic>>.from(jsonDecode(response.body));
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
        fetchFoods();
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
                          selectedCategory = newValue;
                        });
                      },
                      items: categories.map((category) {
                        return DropdownMenuItem<dynamic>(
                          value: category['id'],
                          child: Text(category['name']),
                        );
                      }).toList(),
                      decoration: InputDecoration(labelText: 'Category'),
                    ),
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
                    TextField(
                      controller: priceController,
                      onChanged: (value) {
                        setState(() {
                          updatedPrice = value;
                        });
                      },
                      decoration: InputDecoration(labelText: 'Price'),
                    ),
                    TextField(
                      controller: detailController,
                      onChanged: (value) {
                        setState(() {
                          updatedDetail = value;
                        });
                      },
                      decoration: InputDecoration(labelText: 'Detail'),
                    ),
                    TextField(
                      controller: quantityController,
                      onChanged: (value) {
                        setState(() {
                          updatedQuantity = value;
                        });
                      },
                      decoration: InputDecoration(labelText: 'Quantity'),
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
        title: Text('Manage Foods'),
      ),
      body: ListView.builder(
        itemCount: foods.length,
        itemBuilder: (context, index) {
          final food = foods[index];
          return ListTile(
            title: Text(food['name']),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Price: ${food['price']}'),
                Text('Detail: ${food['detail']}'),
                Text('Quantity: ${food['quantity']}'),
                Text('Category: ${food['category']}'),
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
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Create Food'),
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
                        decoration: InputDecoration(labelText: 'Name'),
                      ),
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            newFoodPrice = value;
                          });
                        },
                        decoration: InputDecoration(labelText: 'Price'),
                      ),
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            newFoodDetail = value;
                          });
                        },
                        decoration: InputDecoration(labelText: 'Detail'),
                      ),
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            newFoodQuantity = value;
                          });
                        },
                        decoration: InputDecoration(labelText: 'Quantity'),
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
                                    Text('Choose Image'),
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
                    child: Text('Create'),
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
