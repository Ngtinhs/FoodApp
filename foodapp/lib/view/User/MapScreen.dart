import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? mapController;
  String? selectedAddress;
  bool locationPermissionGranted = false;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    checkLocationPermission();
  }

  void checkLocationPermission() async {
    // Kiểm tra quyền truy cập định vị
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
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
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
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
          setState(() {
            locationPermissionGranted = true;
          });
          getCurrentLocation();
        }
      } else if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
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
                  onTap: (LatLng latLng) {
                    searchAndSelectAddress('');
                  },
                ),
                Positioned(
                  top: 16.0,
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
}
