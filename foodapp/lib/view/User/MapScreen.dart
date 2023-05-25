import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? mapController;

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
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Gán vị trí là ...
          String selectedAddress = '16 Chử Đồng Tử, Phường 7, Quận Tân Bình';

          Navigator.pop(context, selectedAddress);
        },
        label: Text('Chọn địa chỉ'),
        icon: Icon(Icons.place),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
