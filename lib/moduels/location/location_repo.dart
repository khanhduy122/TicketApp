
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:ticket_app/models/data_app_provider.dart';

class LocationRepo {
  Future<Position?> determinePosition(BuildContext context) async {
    Location location = Location();

    context.read<DataAppProvider>().serviceEnable = await location.serviceEnabled();
    if (!context.read<DataAppProvider>().serviceEnable) {
      context.read<DataAppProvider>().serviceEnable = await location.requestService();
      if (!context.read<DataAppProvider>().serviceEnable) {
        return null;
      }
    }

    context.read<DataAppProvider>().locationPermisstion = await location.hasPermission();
    if (context.read<DataAppProvider>().locationPermisstion == PermissionStatus.denied) {
      context.read<DataAppProvider>().locationPermisstion = await location.requestPermission();
      if (context.read<DataAppProvider>().locationPermisstion != PermissionStatus.granted) {
        return null;
      }
    }

    return Geolocator.getCurrentPosition();
  }
}
