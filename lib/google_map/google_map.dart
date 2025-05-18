import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapConfigure extends StatefulWidget {
  const GoogleMapConfigure({super.key});

  @override
  State<GoogleMapConfigure> createState() => _GoogleMapConfigureState();
}

class _GoogleMapConfigureState extends State<GoogleMapConfigure> {


  @override
  void initState() {
    super.initState();

  }

  late final GoogleMapController _googleMapController;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 400,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(24.278633, 89.015872),
                zoom: 17,
              ),
              mapType: MapType.normal,
              myLocationEnabled: true,
              // myLocationButtonEnabled: true,
              // mapToolbarEnabled: true,
              zoomControlsEnabled: false,
              onMapCreated: (GoogleMapController controller){
                _googleMapController = controller;
                // _googleMapController.moveCamera(CameraUpdate.newLatLng(LatLng(24.293341, 89.020164)));
              },




            ),
          ),

          ElevatedButton(onPressed: (){
            _googleMapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
                zoom: 17,
                target: LatLng(24.293341, 89.020164))));
          }, child: Text('Update Camera Position'))
        ],
      ),
    );
  }
}

