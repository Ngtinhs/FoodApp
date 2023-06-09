import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? mapController; // Điều khiển Google Map
  String? selectedAddress; // Địa chỉ đã chọn
  bool locationPermissionGranted =
      false; // Quyền truy cập vị trí đã được cấp hay chưa
  TextEditingController searchController =
      TextEditingController(); // Controller cho ô tìm kiếm

  @override
  void initState() {
    super.initState();
    checkLocationPermission(); // Kiểm tra quyền truy cập vị trí khi khởi tạo
  }

  void checkLocationPermission() async {
    // Kiểm tra quyền truy cập định vị
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Nếu không bật định vị, hiển thị thông báo
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('Thông báo'),
          content: Text('Vui lòng bật định vị để sử dụng chức năng này.'),
          actions: [
            TextButton(
              child: Text('Đóng'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    } else {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        // Nếu không có quyền truy cập vị trí, yêu cầu quyền
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          // Nếu không được cấp quyền, hiển thị thông báo
          showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: Text('Thông báo'),
              content: Text(
                  'Ứng dụng không được cấp quyền truy cập định vị. Vui lòng cấp quyền để sử dụng chức năng này.'),
              actions: [
                TextButton(
                  child: Text('Đóng'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          );
        } else if (permission == LocationPermission.always ||
            permission == LocationPermission.whileInUse) {
          // Nếu được cấp quyền, cập nhật biến locationPermissionGranted và lấy vị trí hiện tại
          setState(() {
            locationPermissionGranted = true;
          });
          getCurrentLocation();
        }
      } else if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
        // Nếu đã được cấp quyền truy cập vị trí, cập nhật biến locationPermissionGranted và lấy vị trí hiện tại
        setState(() {
          locationPermissionGranted = true;
        });
        getCurrentLocation();
      }
    }
  }

  void getCurrentLocation() async {
    // Lấy vị trí hiện tại
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    moveToLocation(position.latitude, position.longitude);
  }

  void moveToLocation(double latitude, double longitude) {
    // Di chuyển map đến vị trí
    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(latitude, longitude),
          zoom: 14.0,
        ),
      ),
    );
  }

  Future<void> searchAndSelectAddress(String address) async {
    if (address.isNotEmpty) {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        Location location = locations.first;
        moveToLocation(location.latitude, location.longitude);
        setState(() {
          selectedAddress = address;
        });
      } else {
        // Nếu không tìm thấy địa chỉ, hiển thị thông báo
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text('Thông báo'),
            content: Text('Không tìm thấy địa chỉ.'),
            actions: [
              TextButton(
                child: Text('Đóng'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      }
    } else {
      // Nếu không có địa chỉ được nhập, hiển thị thông báo
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('Thông báo'),
          content: Text('Vui lòng nhập địa chỉ.'),
          actions: [
            TextButton(
              child: Text('Đóng'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chọn vị trí'),
      ),
      body: locationPermissionGranted
          ? Stack(
              children: [
                GoogleMap(
                  onMapCreated: (controller) {
                    setState(() {
                      mapController = controller;
                    });
                  },
                  initialCameraPosition: CameraPosition(
                    target: LatLng(10.78722, 106.6537159),
                    zoom: 14.0,
                  ),
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  onTap: (LatLng latLng) async {
                    final address = await _getAddressFromLatLng(latLng);
                    setState(() {
                      selectedAddress = address;
                    });
                  },
                ),
                Positioned(
                  top: 30.0,
                  left: 16.0,
                  right: 16.0,
                  child: Container(
                    color: Colors.white,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: searchController,
                            decoration: InputDecoration(
                              hintText: 'Tìm kiếm vị trí...',
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 8.0,
                                horizontal: 16.0,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            String address = searchController.text.trim();
                            if (address.isNotEmpty) {
                              searchAndSelectAddress(address);
                            }
                          },
                          child: Text('Tìm'),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 16.0,
                  left: 16.0,
                  right: 16.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Vị trí: ${selectedAddress ?? 'Chưa chọn vị trí'}',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      ElevatedButton.icon(
                        onPressed: selectedAddress != null
                            ? () {
                                Navigator.pop(context, selectedAddress);
                              }
                            : null,
                        icon: Icon(Icons.place),
                        label: Text('Chọn địa chỉ'),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  Future<String?> _getAddressFromLatLng(LatLng latLng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latLng.latitude,
        latLng.longitude,
      );
      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;
        String address =
            '${placemark.name}, ${placemark.subAdministrativeArea}, ${placemark.administrativeArea}';
        return address;
      }
    } catch (e) {
      print('Error: $e');
    }
    return null;
  }
}
