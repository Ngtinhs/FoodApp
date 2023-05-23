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
  bool showModal = false;
  String updatedName = '';
  String updatedImage = '';
  String newFoodName = '';
  String newFoodImage = '';
  String newFoodDetail = '';
  String newFoodPrice = '';
  String newFoodQuantity = '';
  String newFoodCategoryId = '';

  @override
  void initState() {
    super.initState();
    fetchFoods();
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
      showModal = true;
    });
  }

  void closeModal() {
    setState(() {
      selectedFood = null;
      updatedName = '';
      updatedImage = '';
      showModal = false;
    });
  }

  void updateFood() async {
    if (selectedFood != null) {
      final foodData = {
        'name': updatedName,
        'image': updatedImage,
        'detail': newFoodDetail,
        'price': newFoodPrice,
        'quantity': newFoodQuantity,
        'category_id': newFoodCategoryId,
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
      'name': newFoodName,
      'image': newFoodImage,
      'detail': newFoodDetail,
      'price': newFoodPrice,
      'quantity': newFoodQuantity,
      'category_id': newFoodCategoryId,
    };

    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('http://10.0.2.2:8000/api/product/create'),
      );

      request.fields['name'] = newFoodName;
      request.fields['detail'] = newFoodDetail;
      request.fields['price'] = newFoodPrice;
      request.fields['quantity'] = newFoodQuantity;
      request.fields['category_id'] = newFoodCategoryId;

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
          newFoodDetail = '';
          newFoodPrice = '';
          newFoodQuantity = '';
          newFoodCategoryId = '';
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

  void _showEditDialog(BuildContext context, Map<String, dynamic> food) {
    setState(() {
      selectedFood = food;
      updatedName = food['name'];
      updatedImage = food['image'];
      showModal = true;
    });

    final nameController = TextEditingController(text: updatedName);
    final imageController = TextEditingController(text: updatedImage);
    final detailController = TextEditingController(text: newFoodDetail);
    final priceController = TextEditingController(text: newFoodPrice);
    final quantityController = TextEditingController(text: newFoodQuantity);
    final categoryIdController = TextEditingController(text: newFoodCategoryId);

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
                      controller: detailController,
                      onChanged: (value) {
                        setState(() {
                          newFoodDetail = value;
                        });
                      },
                      decoration: InputDecoration(labelText: 'Detail'),
                    ),
                    TextField(
                      controller: priceController,
                      onChanged: (value) {
                        setState(() {
                          newFoodPrice = value;
                        });
                      },
                      decoration: InputDecoration(labelText: 'Price'),
                    ),
                    TextField(
                      controller: quantityController,
                      onChanged: (value) {
                        setState(() {
                          newFoodQuantity = value;
                        });
                      },
                      decoration: InputDecoration(labelText: 'Quantity'),
                    ),
                    TextField(
                      controller: categoryIdController,
                      onChanged: (value) {
                        setState(() {
                          newFoodCategoryId = value;
                        });
                      },
                      decoration: InputDecoration(labelText: 'Category ID'),
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
                  newFoodDetail = detailController.text;
                  newFoodPrice = priceController.text;
                  newFoodQuantity = quantityController.text;
                  newFoodCategoryId = categoryIdController.text;
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
                Text('Image URL: ${food['image']}'),
                Text('Detail: ${food['detail']}'),
                Text('Price: ${food['price']}'),
                Text('Quantity: ${food['quantity']}'),
                Text('Category ID: ${food['category_id']}'),
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
                  onPressed: () => _showEditDialog(context, food),
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
                            newFoodDetail = value;
                          });
                        },
                        decoration: InputDecoration(labelText: 'Detail'),
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
                            newFoodQuantity = value;
                          });
                        },
                        decoration: InputDecoration(labelText: 'Quantity'),
                      ),
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            newFoodCategoryId = value;
                          });
                        },
                        decoration: InputDecoration(labelText: 'Category ID'),
                      ),
                      GestureDetector(
                        onTap: () {
                          _pickImage();
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 16),
                          child: Text(
                            'Select Image',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      if (newFoodImage.isNotEmpty)
                        Container(
                          margin: EdgeInsets.only(top: 16),
                          child: Image.file(File(newFoodImage)),
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
                        newFoodDetail = '';
                        newFoodPrice = '';
                        newFoodQuantity = '';
                        newFoodCategoryId = '';
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
