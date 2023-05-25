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

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
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
      body: GoogleMap(
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
