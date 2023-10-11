import 'dart:convert';
import 'package:carparkingapp/src/modals/user_modal.dart';
import 'package:carparkingapp/src/modals/verhicle_modal.dart';
import 'package:carparkingapp/src/widgets/inputText.dart';
import 'package:carparkingapp/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class BikeController extends GetxController {
  final _formKey = GlobalKey<FormState>();
  late Rx<List<VehicleModal>> vehicles = Rx([]);
  TextEditingController licensePlateController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController colorController = TextEditingController();
  TextEditingController brandController = TextEditingController();
  void init() {
    fetchApiBike();
  }

  void onClick(VehicleModal vehicleModal) {
    Get.dialog(AlertDialog(
      title: Text(
        'Mã QR cho xe: ${vehicleModal.licensePlate}',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Đưa mã này cho bản vệ quét',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 20.h,
            ),
            SizedBox(
              width: MediaQuery.of(Get.context!).size.width,
              height: MediaQuery.of(Get.context!).size.height / 3,
              child: QrImageView(
                data: 'Xe: 00A0-000.00',
                version: QrVersions.auto,
              ),
            )
          ],
        ),
      ),
      actions: <Widget>[
        ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Get.back(),
            child: const Text(
              'Cancel',
              style: TextStyle(fontWeight: FontWeight.w600),
            ))
      ],
    ));
  }

  void addUpdateBike(context, bool isAdd, {VehicleModal? vehicleModal}) {
    if (!isAdd) {
      licensePlateController.text = vehicleModal!.licensePlate!;
      nameController.text = vehicleModal.name!;
      colorController.text = vehicleModal.color!;
    }
    if (isAdd) {
      licensePlateController.text = "";
      nameController.text = "";
      colorController.text = "";
    }
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(32.r))),
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    width: 120.w,
                    height: 3.h,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(25.r)),
                  ),
                  InputText(
                      text: 'Biển số xe', controller: licensePlateController),
                  InputText(text: 'Tên xe', controller: nameController),
                  InputText(text: 'Màu xe', controller: colorController),
                  GestureDetector(
                    onTap: () {
                      isAdd ? addVehicle() : updateVehicle(vehicleModal!);
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(15.r),
                      decoration: BoxDecoration(
                        color: const Color(0xFF064789),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          isAdd ? "Thêm phương tiện" : "Cập nhật phương tiện",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> addVehicle() async {
    var prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    VehicleModal dataVehicle = VehicleModal(
      name: nameController.text,
      licensePlate: licensePlateController.text,
      color: colorController.text,
      images: [],
      vehicleTypeId: 1,
    );
    final response = await http.post(
      Uri.parse("${Constants.baseUrl}vehicle/create"),
      headers: Constants.header(token!),
      body: jsonEncode(dataVehicle),
    );
    if (response.statusCode == 200) {
      fetchApiBike();
    } else {}
  }

  Future<void> updateVehicle(VehicleModal vehicleModal) async {
    var prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    VehicleModal dataVehicle = VehicleModal(
      id: vehicleModal.id,
      name:
          nameController.text.isEmpty ? vehicleModal.name : nameController.text,
      licensePlate: licensePlateController.text.isEmpty
          ? vehicleModal.licensePlate
          : licensePlateController.text,
      color: colorController.text.isEmpty
          ? vehicleModal.color
          : colorController.text,
      userId: vehicleModal.userId,
      images: [],
      vehicleTypeId: 1,
    );
    final response = await http.put(
      Uri.parse("${Constants.baseUrl}vehicle/update"),
      headers: Constants.header(token!),
      body: jsonEncode(dataVehicle),
    );
    if (response.statusCode == 200) {
      Get.back();
      fetchApiBike();
    } else {
      Get.back();
    }
  }

  Future<void> deleteVehicle(String id) async {
    var prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    final response = await http.delete(
      Uri.parse("${Constants.baseUrl}vehicle/$id/delete"),
      headers: Constants.header(token!),
    );
    if (response.statusCode == 200) {
      fetchApiBike();
    } else {}
  }

  Future<void> fetchApiBike() async {
    var prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    final response = await http.get(
      Uri.parse("${Constants.baseUrl}vehicle/list"),
      headers: Constants.header(token!),
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> result = jsonDecode(utf8.decode(response.bodyBytes));
      List<dynamic> data = result['data'];
      List<VehicleModal> resultList = [];
      for (var p in data) {
        VehicleModal vehicle = VehicleModal.fromJson(p);
        resultList.add(vehicle);
      }
      vehicles(resultList);
      update();
    } else {}
  }
}
