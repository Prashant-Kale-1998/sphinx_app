import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller = Completer();

  LatLng? _latLng;


  CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

   CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  Future<void> getCurrentLocation() async{

    Location location = Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();

    _latLng = LatLng(_locationData.latitude!, _locationData.longitude!);

    _kGooglePlex = CameraPosition(
        target: _latLng!,
      zoom: 14.4746
    );

    _kLake = CameraPosition(
        bearing: 192.8334901395799,
        target: _latLng!,
        tilt: 59.440717697143555,
        zoom: 19.151926040649414);

    setState(() {});
  }

  @override
  void initState() {
    getCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body:_latLng!=null? GoogleMap(
          mapType: MapType.normal,
          markers: <Marker>{
            _setMarker()
          },
          rotateGesturesEnabled: true,
          compassEnabled: true,
          myLocationButtonEnabled: true,
          myLocationEnabled: true,
          initialCameraPosition: _kGooglePlex,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ):Center(child: CircularProgressIndicator(),),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _goToTheLocation,
          label: const Text('To the location!'),
          icon: const Icon(Icons.directions_boat),
        ),
      ),
    );
  }

  _setMarker(){
    return Marker(markerId: MarkerId("marker_1"),icon: BitmapDescriptor.defaultMarker,position: _latLng!,);
  }

  Future<void> _goToTheLocation() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}