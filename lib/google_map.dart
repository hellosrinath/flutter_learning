import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMaps extends StatefulWidget {
  const GoogleMaps({super.key});

  @override
  State<GoogleMaps> createState() => _GoogleMapsState();
}

class _GoogleMapsState extends State<GoogleMaps> {
  LatLng myLatLong = const LatLng(22.39094717909865, 91.85616162280324);
  String address = 'Lucknow';
  List<LatLng> latLongList = [
    LatLng(22.393861920202298, 91.85711156576872),
    LatLng(22.392557158179052, 91.85560047626495),
    LatLng(22.39314428710485, 91.85861393809319)
  ];

  List<List<LatLng>> holesList = [];

  setMarker(LatLng value) async {
    myLatLong = value;
    address = "${value.latitude},${value.longitude}";
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    holesList.add(latLongList);
  }

  late GoogleMapController _googleMapController;

  Future<void> initializedMap() async {
    debugPrint(
        "visible region: ${await _googleMapController.getVisibleRegion()}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        onMapCreated: (GoogleMapController googleMapController) {
          _googleMapController = googleMapController;
          initializedMap();
        },
        myLocationButtonEnabled: true,
        myLocationEnabled: true,
        initialCameraPosition: CameraPosition(
          target: myLatLong,
          zoom: 17,
          tilt: 45,
          bearing: 45,
        ),
        markers: {
          Marker(
            infoWindow: InfoWindow(title: address),
            markerId: const MarkerId('1'),
            position: myLatLong,
            /*draggable: true,
            onDragEnd: (value) {
              setMarker(value);
            },*/
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueYellow),
          ),
          Marker(
            infoWindow: InfoWindow(title: address),
            markerId: const MarkerId('11'),
            position: const LatLng(22.3902203976883, 91.85520887374878),
            /*draggable: true,
            onDragEnd: (value) {
              setMarker(value);
            },*/
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          ),
          Marker(
            infoWindow: InfoWindow(title: address),
            markerId: const MarkerId('12'),
            position: const LatLng(22.389981697470944, 91.85433883219957),
            /*draggable: true,
            onDragEnd: (value) {
              setMarker(value);
            },*/
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          ),
          Marker(
            infoWindow: InfoWindow(title: address),
            markerId: const MarkerId('13'),
            position: const LatLng(22.388828490650255, 91.85372829437256),
            /*draggable: true,
            onDragEnd: (value) {
              setMarker(value);
            },*/
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueAzure),
          ),
        },
        circles: {
          Circle(
            circleId: const CircleId("dfsd"),
            center: const LatLng(22.3902203976883, 91.85520887374878),
            radius: 100,
            strokeColor: Colors.red,
            strokeWidth: 2,
            fillColor: Colors.red.withOpacity(0.15),
          ),
          Circle(
              circleId: const CircleId("dfsddsfds"),
              center: const LatLng(22.388828490650255, 91.85372829437256),
              radius: 100,
              strokeColor: Colors.green,
              strokeWidth: 2,
              fillColor: Colors.green.withOpacity(0.15),
              onTap: () {
                debugPrint("Tap Circle");
              },
              consumeTapEvents: true)
        },
        onTap: (value) {
          debugPrint("location: $value");
          setMarker(value);
        },
        polylines: {
          const Polyline(
            polylineId: PolylineId("sdfsdff"),
            points: [
              LatLng(22.386796405363178, 91.85167271643877),
              LatLng(22.398135402845174, 91.86393644660711),
            ],
          ),
        },
        polygons: {
          Polygon(
            polygonId: const PolygonId("sdfsdf"),
            points: const [
              LatLng(22.393861920202298, 91.85711156576872),
              LatLng(22.393730173582902, 91.8560678511858),
              LatLng(22.392557158179052, 91.85560047626495),
              LatLng(22.392015286199946, 91.8570988252759),
              LatLng(22.39314428710485, 91.85861393809319),
            ],
            strokeColor: Colors.green,
            strokeWidth: 2,
            fillColor: Colors.green.withOpacity(0.15),
            holes: holesList,
          ),
        },
      ),
    );
  }
}
