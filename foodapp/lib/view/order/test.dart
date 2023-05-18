// class ProductDetail extends StatelessWidget {
//   ProductDetail({Key? key,required this.product}) : super(key: key);
//   Product product;
//   late Pref pref = new Pref();
//   late bool login;
//   late String name;
//   late String image;
//   void checklogin() async{
//     final prefs = await SharedPreferences.getInstance();
//     bool test = prefs.containsKey("id");
//     if (test){
//
//       login=true;
//       name = prefs.getString('name');
//       image = prefs.getString('image');
//
//     }
//     else {
//
//       login=false;
//
//     }
//
//   }
//   TextEditingController search = new TextEditingController();
//   Future<void> logout() async {
//     final prefs = await SharedPreferences.getInstance();
//     prefs.clear();
//
//     name="";
//     login=false;
//     image="";
//
//
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       drawer: Drawer(
//         child: ListView(
//           children: [
//             DrawerHeader(
//                 decoration: BoxDecoration(
//                   color: Colors.blue,
//                 ),
//                 child:
//                 Column(
//                   children: [
//                     Center(child: Text("Xin chào !")),
//                     Text(name),
//                     if(image!="")CircleAvatar(child: Image.network("${Apihelper.image_base}/avatar/${image}")
//                       ,)
//                   ],
//                 )
//             ),
//             ListTile(
//               title: Text("TRANG CHỦ"),
//               onTap: (){
//                 Navigator.push(context, MaterialPageRoute(builder:(context) =>Home()));
//               },
//             ),
//             ListTile(
//               title: Text("GIỎ HÀNG"),
//               onTap: (){
//                 Navigator.push(context, MaterialPageRoute(builder:(context) =>CartList()));
//               },
//             ),ListTile(
//               title: Text("TẤT CẢ ĐƠN HÀNG"),
//
//             ),
//
//             ListTile(
//               title: Text("ĐANG GIAO HÀNG"),
//
//             )
//             ,ListTile(
//               title: Text("THÀNH CÔNG"),
//
//             ),
//             ListTile(
//               title: Text("ĐÃ HỦY"),
//               onTap: (){
//
//               },
//             ),if(login)ListTile(
//               title: Text("ĐĂNG XUẤT"),
//               onTap: (){
//                 logout();
//               },
//             )else
//               ListTile(
//                 title: Text("ĐĂNG Nhập"),
//                 onTap: (){
//                   logout();
//                 },
//               )
//             ,
//           ],
//         ),
//       ),
//       appBar: AppBar(
//         automaticallyImplyLeading:false,
//         title:Row(
//           children: [
//             Padding(
//                 padding: const EdgeInsets.only(top: 8.0),
//                 child:
//                 InkWell(child: Icon(Icons.arrow_back_ios, color: Colors.pinkAccent
//                 ),
//
//                   onTap: (){
//                     Navigator.pop(context);
//                   },
//                 )
//             ),
//             Container(
//                 padding: EdgeInsets.only(top: 5,left: 20),
//                 height: 40,
//                 width: 300,
//                 // margin: EdgeInsets.only(),
//                 child: Stack(
//
//                   alignment: Alignment.centerRight,
//                   children: [
//
//                     TextFormField(
//                       controller: search ,
//                       textInputAction: TextInputAction.search,
//                       //   onTap: (){
//                       //
//                       // },
//                       onEditingComplete: (){
//                         if(search.text!="")
//                           Navigator.push(context, MaterialPageRoute(builder:(context) =>SearchProduct(search.text)));
//                       },
//                       decoration: InputDecoration(
//                         contentPadding: EdgeInsets.only(bottom: 3,left: 13,right: 30),
//                         hintText:"Tìm kiếm",
//                         hintStyle: TextStyle(color: Colors.grey,fontFamily: 'Roboto',fontSize: 13),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(25),
//                           borderSide: BorderSide(),
//                         ),
//                         focusedBorder:OutlineInputBorder(
//                           borderSide: const BorderSide(color: Color.fromRGBO(243, 98, 105, 1), width: 1.0),
//                           borderRadius: BorderRadius.circular(25.0),
//                         ),
//                       ),
//                     ),
//
//                     Padding(
//                       padding: const EdgeInsets.only(right: 10.0),
//                       child: InkWell(
//                         child: Icon(Icons.dangerous_rounded,color: Colors.pinkAccent,),
//                         onTap: (){
//                           search.text ="";
//                         },
//                       ),
//                     ),
//                   ],
//                 )
//             ),
//             Padding(
//               padding: EdgeInsets.only(left: 10,top: 10),
//               child: InkWell(
//                 child: Icon(Icons.shopping_cart,color: Colors.pinkAccent,),
//                 onTap: (){
//                   Navigator.push(context, MaterialPageRoute(builder:(context) =>CartList()));
//                 },
//               ),
//             ),
//           ],
//         ),
//
//         backgroundColor: Colors.white,
//         // leading: IconButton(icon:Icon( Icons.arrow_back_ios,color: Color.fromRGBO(243, 98, 105, 1),),onPressed: (){
//         //   Navigator.pop(context);
//         // },),
//
//       ),
//       body: Container(
//           child:Stack(
//             alignment: Alignment.topCenter,
//             children: [
//               Container(
//                 height: 630,
//                 child: SingleChildScrollView(child:
//                 Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children:[
//                       Center(child: Image.network("${Apihelper.image_base}/product/${product.image}")),
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Text(product.name,style: TextStyle(fontWeight: FontWeight.w700,fontSize: 20,),),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.only(left: 8.0,top: 5),
//                         child: Text(Apihelper.money(product.price),style: TextStyle(fontSize: 24,color: Colors.deepOrangeAccent),),
//
//                       ),
//                       Padding(padding: EdgeInsets.only(left: 8,top: 15,bottom: 10)
//                           ,
//                           child: Row(
//                             children: [
//                               Text("Danh mục: "),
//                               Text(product.category)
//                             ],
//                           )
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.only(left: 8.0,bottom: 15),
//                         child: Text("Chi tiết sản phẩm:",style: TextStyle(fontSize: 22),),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.only(left: 8.0),
//                         child: Text(product.detail),
//                       ),
//                     ]
//
//                 ),
//                 ),
//
//               ),
//               Align(
//                   alignment: Alignment.bottomCenter,
//                   child:Container(
//                     color: Colors.white,
//                     width: MediaQuery.of(context).size.width,
//                     height: 60,
//                     child: FlatButton.icon(
//                       icon: Icon(Icons.add_shopping_cart,color: Colors.white,),
//                       onPressed: () {
//                         CartApi.insert(product.id, context);
//                       },
//                       color: Color.fromRGBO(243, 98, 105, 1),
//                       label: Text(
//                         "Thêm vào giỏ",
//                         style: TextStyle(
//                             color: Colors.white,
//                             fontFamily: 'Raleway',
//                             fontSize: 20.0,
//                             fontWeight: FontWeight.w500
//                         ),
//                       ),
//                     ),
//                   )
//                 // Text(product.category),
//               )
//             ],
//           )
//
//       ),
//     );
//   }
// }