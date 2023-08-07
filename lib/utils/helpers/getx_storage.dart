import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../network/app_config.dart';

class GetStorageController extends GetxController {
  final storage = GetStorage();

  void saveTokenData({required String value}) {
    storage.write("token", value);
  }

  Future<String> getTokenData() async {
    final token = await storage.read("token") ?? "";
    return token;
  }

  void removeTokeData() {
    storage.remove("token");
  }

  void saveSupervisorId({required String value}) {
    storage.write(StorageKeys.supervisorId, value);
  }

  Future<String> getSupervisorId() async {
    final supervisorId = await storage.read(StorageKeys.supervisorId) ?? "";
    return supervisorId;
  }

  void saveCompanyId({required String value}) {
    storage.write(StorageKeys.companyId, value);
  }

  Future<String> getCompanyId() async {
    final companyId = await storage.read(StorageKeys.companyId) ?? "";
    return companyId;
  }

  void saveKioskId({required String value}) {
    storage.write(StorageKeys.kioskId, value);
  }

  Future<String> getKioskId() async {
    final kioskId = await storage.read(StorageKeys.kioskId) ?? "";
    return kioskId;
  }

  void saveKioskAddress({required String value}) {
    storage.write(StorageKeys.kioskAddress, value);
  }

  Future<String> getKioskAddress() async {
    final kioskAddress = await storage.read(StorageKeys.kioskAddress) ?? "";
    return kioskAddress;
  }

  void saveKioskName({required String value}) {
    storage.write(StorageKeys.kioskName, value);
  }

  Future<String> getKioskName() async {
    final kioskAddress = await storage.read(StorageKeys.kioskName) ?? "";
    return kioskAddress;
  }

  void savePhone({required String value}) {
    storage.write(StorageKeys.phoneNumber, value);
  }

  Future<String> getPhone() async {
    final phoneNumber = await storage.read(StorageKeys.phoneNumber) ?? "";
    return phoneNumber;
  }

  Future<SupervisorInfo> getSupervisorInfo() async {
    final phoneNumber =
        await storage.read(StorageKeys.supervisorInfo) ?? SupervisorInfo();
    return phoneNumber;
  }

  void removeSupervisorInfo() {
    storage.write(StorageKeys.supervisorId, "");
    storage.write(StorageKeys.companyId, "");
    storage.write(StorageKeys.kioskId, "");
    storage.write(StorageKeys.kioskAddress, "");
    storage.write(StorageKeys.kioskName, "");
    storage.write(StorageKeys.phoneNumber, "");
    storage.write(StorageKeys.supervisorInfo, SupervisorInfo());
  }

  void saveSupervisorInfo({
    required String supervisorId,
    required String companyId,
    required String kioskId,
    required String kioskAddress,
    required String kioskName,
    required String phoneNumber,
  }) {
    storage.write(StorageKeys.supervisorId, supervisorId);
    storage.write(StorageKeys.companyId, companyId);
    storage.write(StorageKeys.kioskId, kioskId);
    storage.write(StorageKeys.kioskAddress, kioskAddress);
    storage.write(StorageKeys.phoneNumber, phoneNumber);
    storage.write(StorageKeys.kioskName, kioskName);
    storage.write(
      StorageKeys.supervisorInfo,
      SupervisorInfo(
        supervisorId: supervisorId,
        cid: companyId,
        kioskId: kioskId,
        kioskAddress: kioskAddress,
        kioskName: kioskName,
        phoneNumber: phoneNumber,
      ),
    );
  }

  void saveDeviceToken({required String value}) {
    storage.write("deviceToken", value);
  }

  Future<String> getDeviceToken() async {
    final deviceToken = await storage.read("deviceToken") ??
        "fAjT6KxtTE-hc_txlFPEXu:APA91bG3xT3yRFa0inWCr-frK30bLrea7Jw7BwaKrV_qwd1y-Wy4qY8nPy9AGHXo3BEE9dhlVclNxk3IbE5WL7hTpMfP2moxvZBIMMj7cpiuPKGLgvHadLya4dVKztpzET06LtRgQ4h5";
    return deviceToken;
  }

  void saveNodeUrl({required String url}) {
    storage.write("nodeUrl", url);
  }

  Future<String> getNodeUrl() async {
    return await storage.read("nodeUrl") ?? AppConfig.nodeUrl;
  }
}

class SupervisorInfo {
  String? kioskId;
  String? supervisorId;
  String? cid;
  String? kioskAddress;
  String? kioskName;
  String? phoneNumber;

  SupervisorInfo({
    this.kioskId = "",
    this.supervisorId = "",
    this.cid = "",
    this.kioskName = "",
    this.kioskAddress = "",
    this.phoneNumber = "",
  });
}

class StorageKeys {
  static const String supervisorId = 'supervisorId';
  static const String companyId = 'companyId';
  static const String kioskId = 'kioskId';
  static const String kioskAddress = 'kioskAddress';
  static const String kioskName = 'kioskName';
  static const String phoneNumber = 'phoneNumber';
  static const String supervisorInfo = 'supervisorInfo';
  static const String deviceToken = 'deviceToken';
  static const String nodeUrl = 'nodeUrl';
}
