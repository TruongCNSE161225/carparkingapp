import 'package:carparkingapp/src/modals/verhicle_modal.dart';
import 'package:carparkingapp/src/pages/bike/bike_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

class BikePage extends GetView<BikeController> {
  const BikePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Quản lý phương tiện',
          style: TextStyle(color: Color(0xFF064789)),
        ),
        actions: [
          IconButton(
              onPressed: () {
                controller.addUpdateBike(context, true);
              },
              icon: Icon(
                Icons.add,
                color: const Color(0xFF064789),
                size: 40.sp,
              ))
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          controller.init();
        },
        child: Obx(
          () => ListView.separated(
            itemCount: controller.vehicles.value.length,
            separatorBuilder: (context, index) {
              return SizedBox(
                height: 20.h,
              );
            },
            itemBuilder: (context, index) {
              return container(context, controller.vehicles.value[index]);
            },
          ),
        ),
      ),
    );
  }

  Widget container(BuildContext context, VehicleModal vehicleModal) {
    return Slidable(
      endActionPane: ActionPane(motion: const DrawerMotion(), children: [
        SlidableAction(
          onPressed: (context) {
            controller.deleteVehicle(vehicleModal.id ?? "");
          },
          backgroundColor: const Color(0xFFFE4A49),
          foregroundColor: Colors.white,
          icon: Icons.delete,
        ),
        SlidableAction(
            onPressed: (context) {
              controller.addUpdateBike(context, false,
                  vehicleModal: vehicleModal);
            },
            icon: Icons.edit),
      ]),
      child: InkWell(
        onTap: () {
          controller.onClick(vehicleModal);
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 200.h,
            decoration: BoxDecoration(
                color: const Color(0xFF064789),
                borderRadius: BorderRadius.circular(24.r)),
            child: Padding(
              padding: EdgeInsets.all(16.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      vehicleModal.licensePlate ?? 'Chưa cập nhật',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25.sp,
                          color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: title('Tên xe'),
                      ),
                      SizedBox(
                        width: 20.w,
                      ),
                      Expanded(
                        child: title("Màu xe"),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: SizedBox(
                          child: content(
                              vehicleModal.name ?? 'Chưa cập nhật'),
                        ),
                      ),
                      SizedBox(
                        width: 20.w,
                      ),
                      Expanded(
                          child: content(
                              vehicleModal.color ?? 'Chưa cập nhật'))
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Text content(String text) {
    return Text(
      text,
      style: TextStyle(
          fontWeight: FontWeight.bold, fontSize: 20.r, color: Colors.white),
    );
  }

  Text title(String text) {
    return Text(
      '$text:',
      style: TextStyle(
          fontWeight: FontWeight.normal, fontSize: 20.r, color: Colors.grey),
    );
  }
}
