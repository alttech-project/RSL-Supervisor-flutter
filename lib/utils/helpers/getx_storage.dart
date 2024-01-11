import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rsl_supervisor/utils/helpers/basic_utils.dart';

import '../../network/app_config.dart';

class GetStorageController extends GetxController {
  final storage = GetStorage();

  void saveTokenData({required String value}) {
    storage.write(StorageKeys.accessToken, value);
  }

  Future<String> getTokenData() async {
    final token = await storage.read(StorageKeys.accessToken) ?? "";
    return token;
  }

  void saveShiftStatus({required bool value}) {
    storage.write(StorageKeys.shiftStatus, value);
  }

  Future<bool> getShiftStatus() async {
    final shiftStatus = await storage.read(StorageKeys.shiftStatus) ?? true;
    return shiftStatus;
  }

  void removeTokeData() {
    storage.write(StorageKeys.accessToken, "");
  }

  Future<SupervisorInfo> getSupervisorInfo() async {
    final supervisorInfoStr = await storage.read(StorageKeys.supervisorInfo) ??
        _supervisorInfoToJson(SupervisorInfo());
    printLogs("getSupervisorInfo $supervisorInfoStr");

    return _supervisorInfoFromJson(supervisorInfoStr);
  }

  void removeSupervisorInfo() {
    storage.write(
        StorageKeys.supervisorInfo, _supervisorInfoToJson(SupervisorInfo()));
  }

  void saveSupervisorInfo({required SupervisorInfo supervisorInfo}) {
    printLogs("saveSupervisorInfo : ${_supervisorInfoToJson(supervisorInfo)}");
    storage.write(
      StorageKeys.supervisorInfo,
      _supervisorInfoToJson(supervisorInfo),
    );
  }

  void saveDeviceToken({required String value}) {
    storage.write("deviceToken", value);
  }

  Future<String> getDeviceToken() async {
    final deviceToken = await storage.read("deviceToken") ?? "";
    return deviceToken;
  }

  void saveNodeUrl({required String url}) {
    storage.write("nodeUrl", url);
  }

  Future<String> getNodeUrl() async {
    return await storage.read("nodeUrl") ?? AppConfig.nodeUrl;
  }

  void saveBookingsUrl({required String url}) {
    storage.write("bookingsUrl", url);
  }

  Future<String> getBookingsUrl() async {
    return await storage.read("bookingsUrl") ?? AppConfig.newBookingUrl;
  }

  void saveCorporateId({required String url}) {
    storage.write("corporateId", url);
  }

  Future<String> getCorporateId() async {
    return await storage.read("corporateId") ?? "";
  }

  void saveLocationType({required String type}) {
    storage.write("LocationType", type);
  }

  Future<String> getLocationType() async {
    return await storage.read("LocationType") ??
        LocationType.GENERAL.toString();
  }

  void saveQuickTripEnableType({required int type}) {
    storage.write("QuickTripEnableType", type);
  }

  Future<int> getQuickTripEnableType() async {
    return await storage.read("QuickTripEnableType") ?? 0;
  }

  void saveRiderReferralUrl({required int url}) {
    storage.write("riderReferralUrl", url);
  }

  Future<int> getRiderReferralUrl() async {
    return await storage.read("riderReferralUrl");
  }

  void saveMonitorNodeUrl({required String url}) {
    storage.write("monitorNodeUrl", url);
  }

  Future<String> getMonitorNodeUrl() async {
    return await storage.read("monitorNodeUrl");
  }

  void saveVideoDate({required String date}) {
    storage.write("videoDate", date);
  }

  Future<String> getVideoDate() async {
    return await storage.read("videoDate");
  }

  void saveImageDate({required String date}) {
    storage.write("imageDate", date);
  }

  Future<String> getImageDate() async {
    return await storage.read("imageDate");
  }

  void saveEditFare({required int type}) {
    storage.write("enable_edit_fare", type);
  }

  Future<int> getEditFare() async {
    return await storage.read("enable_edit_fare");
  }
}

class SupervisorInfo {
  String? kioskId;
  String? supervisorId;
  String? supervisorName;
  String? supervisorUniqueId;
  String? cid;
  String? kioskAddress;
  String? kioskName;
  String? phoneNumber;

  SupervisorInfo({
    this.kioskId = "",
    this.supervisorId = "",
    this.supervisorName = "",
    this.supervisorUniqueId = "",
    this.cid = "",
    this.kioskName = "",
    this.kioskAddress = "",
    this.phoneNumber = "",
  });

  SupervisorInfo.fromJson(Map<String, dynamic> json) {
    kioskId = json['kioskId'] ?? "";
    supervisorId = json['supervisorId'] ?? "";
    supervisorName = json['supervisorName'] ?? "";
    supervisorUniqueId = json['supervisorUniqueId'] ?? "";
    cid = json['cid'] ?? "";
    kioskName = json['kioskName'] ?? "";
    kioskAddress = json['kioskAddress'] ?? "";
    phoneNumber = json['phoneNumber'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['kioskId'] = kioskId;
    data['supervisorId'] = supervisorId;
    data['supervisorName'] = supervisorName;
    data['supervisorUniqueId'] = supervisorUniqueId;
    data['cid'] = cid;
    data['kioskName'] = kioskName;
    data['kioskAddress'] = kioskAddress;
    data['phoneNumber'] = phoneNumber;
    return data;
  }
}

SupervisorInfo _supervisorInfoFromJson(String str) {
  final jsonData = json.decode(str);
  return SupervisorInfo.fromJson(jsonData);
}

String _supervisorInfoToJson(SupervisorInfo data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class StorageKeys {
  static const String accessToken = 'accessToken';
  static const String supervisorInfo = 'supervisorInfo';
  static const String deviceToken = 'deviceToken';
  static const String nodeUrl = 'nodeUrl';
  static const String shiftStatus = 'shiftStatus';
}
