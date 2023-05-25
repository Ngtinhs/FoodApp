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

  @override
  void initState() {
    super.initState();
    checkLocationPermission();
  }

  void checkLocationPermission() async {
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
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    moveToLocation(position.latitude, position.longitude);
  }

  void moveToLocation(double latitude, double longitude) {
    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(latitude, longitude),
          zoom: 14.0,
        ),
      ),
    );
  }

  Future<void> searchAndSelectAddress(LatLng latLng) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
      latLng.latitude,
      latLng.longitude,
    );

    if (placemarks.isNotEmpty) {
      Placemark placemark = placemarks.first;
      String address =
          '${placemark.street}, ${placemark.subLocality}, ${placemark.subAdministrativeArea}';

      setState(() {
        selectedAddress = address;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chọn vị trí'),
      ),
      body: locationPermissionGranted
          ? GoogleMap(
              onMapCreated: (controller) {
                setState(() {
                  mapController = controller;
                });
              },
              initialCameraPosition: CameraPosition(
                target: LatLng(10.78722, 106.6537159),
                zoom: 14.0,
              ),
              onTap: (LatLng latLng) {
                searchAndSelectAddress(latLng);
              },
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (selectedAddress != null) {
            Navigator.pop(context, selectedAddress);
          }
        },
        label: Text('Chọn địa chỉ'),
        icon: Icon(Icons.place),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
