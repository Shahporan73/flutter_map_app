// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FlutterMapsScreen extends StatefulWidget {
  const FlutterMapsScreen({super.key});

  @override
  State<FlutterMapsScreen> createState() => _FlutterMapsScreenState();
}

class _FlutterMapsScreenState extends State<FlutterMapsScreen> {
  LatLng _currentLocation = const LatLng(23.758657, 90.428862);
  Completer<GoogleMapController> _controller = Completer();
  String output='';

  List<Marker> _markers = [];
  final List<Marker> _list = const [
    Marker(
      markerId: MarkerId("1"),
      visible: true,
      position: LatLng(23.777176, 90.399452),
      infoWindow: InfoWindow(
        title: "Pizza Burg",
      ),
    ),
    Marker(
      markerId: MarkerId("2"),
      visible: true,
      position: LatLng(23.759975, 90.430085),
      infoWindow: InfoWindow(
        title: "Al Hera Mosque",
      ),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _markers.addAll(_list);
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        height: height,
        width: width,
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: _currentLocation,
            zoom: 14.4746,
          ),
          compassEnabled: true,
          mapType: MapType.normal,
          myLocationButtonEnabled: true,
          myLocationEnabled: true,
          onMapCreated: (controller) {
            _controller.complete(controller);
          },
          markers: Set<Marker>.of(_markers),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () async {

          getUserCurrentLocation();

        },
        child: Icon(
          Icons.my_location,
          color: Colors.white,
        ),
      ),
    );
  }

  void getUserCurrentLocation() async {

    await Geolocator.checkPermission();
    await Geolocator.requestPermission();

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    GoogleMapController controller = await _controller.future;

    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 24,
        ),
      ),
    );


    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    var address = placemarks.first;
    print(address);


    Marker placeMarker = Marker(
      markerId: MarkerId("current_location"),
      position: LatLng(position.latitude, position.longitude),
      infoWindow: InfoWindow(
        title: "Address: "+ address.street.toString()+", "+address.subLocality.toString()+", "+address.locality.toString()+", "+address.country.toString(),
      ),
    );

    setState(() {
      // Clear the previous current location marker if needed
      _markers.removeWhere((marker) => marker.markerId == MarkerId("current_location"));
      // Add the new marker to the list
      _markers.add(placeMarker);
    });

  }

}
