// ignore_for_file: file_names, library_private_types_in_public_api, must_be_immutable, unused_field

import 'dart:async';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../Constants/Library.dart';

class ColdCalling extends StatefulWidget {
  LocationData? locationData;
   ColdCalling({super.key,this.locationData});

  @override
  _ColdCallingState createState() => _ColdCallingState();
}

class _ColdCallingState extends State<ColdCalling> {
  final Completer<GoogleMapController> _controller =
  Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(26.9124, 75.7873),
    zoom: 14.4746,
  );

  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  final Completer<GoogleMapController> _controller1 =
  Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex1 = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static const CameraPosition _kLake1 = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWidget(title: "Cold Calling",),
      body: Center(
        child: TextWidget("No data found.",fontSize: 20,fontWeight: FontWeight.w500,),
      )

      // GoogleMap(
      //   mapType: MapType.normal,
      //   initialCameraPosition: _kGooglePlex,
      //   onMapCreated: (GoogleMapController controller) {
      //     _controller.complete(controller);
      //   },
      // ),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: _goToTheLake,
      //   label: const Text('To the lake!'),
      //   icon: const Icon(Icons.directions_boat),
      // ),
    );


  }
  // FutureOr<void> _goToTheLake() async {
  //   final GoogleMapController controller = await _controller.future;
  //   await controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  // }


}
