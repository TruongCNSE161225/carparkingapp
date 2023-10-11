import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class InputText extends StatelessWidget {
  late TextEditingController controller;
  late String text;
  late bool enabled;
  InputText({
    Key? key,
    required this.controller,
    required this.text,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: TextFormField(
        enabled: enabled,
        controller: controller,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Vui lòng điền $text';
          }
          return null;
        },
        decoration: InputDecoration(
          suffixIcon: IconButton(
              icon: const Icon(Icons.cancel),
              onPressed: () {
                controller.clear();
              }),
          border: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blue)),
          labelText: text,
        ),
      ),
    );
  }
}
