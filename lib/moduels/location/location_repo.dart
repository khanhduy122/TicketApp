import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ticket_app/components/dialogs/dialog_request.dart';
import 'package:ticket_app/components/logger.dart';
import 'package:ticket_app/moduels/location/location_exception.dart';

class LocationRepo {
  Future<Position> determinePosition(BuildContext context) async {
    try {
      if (Platform.isAndroid) {
        if (await Permission.location.request().isGranted) {
          return await Geolocator.getCurrentPosition();
        } else {
          Future.error(DeniedPermissionPositionException());
        }
      } else {
        if (await Permission.location.request().isGranted) {
          return await Geolocator.getCurrentPosition();
        }
        // ignore: use_build_context_synchronously
        await DialogRequest.show(
          context: context,
          message:
              "MovieTicket cần quyền để truy cập vào vị trí, vui lòng cấp quyền này",
          titlePositive: "OpenSetting",
          titleNegative: "No",
          onTapNegative: () {
            Navigator.pop(context);
          },
          onTapPositive: () async {
            await openAppSettings();
          },
        );
      }
      return await Geolocator.getCurrentPosition();
    } catch (e) {
      debugLog(e.toString());
      rethrow;
    }
  }
}
