import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

import '../../../utill/images.dart';
import 'color_utils.dart';
import 'font_utils.dart';
import 'text_widget.dart';

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(title: Text('Dashed Border with Image Picker')),
      body: Center(
        child: DashedBorderContainer(),
      ),
    ),
  ));
}

class DashedBorderContainer extends StatefulWidget {
  @override
  _DashedBorderContainerState createState() => _DashedBorderContainerState();
}

class _DashedBorderContainerState extends State<DashedBorderContainer> {
  File? _image; // Variable to store the selected image

  final ImagePicker _picker = ImagePicker();

  // Function to pick an image from gallery or camera
  Future<void> _pickImage() async {
    final PickedFile? pickedFile = (await _picker.pickImage(
      source:
      ImageSource.gallery, // Set to ImageSource.camera for camera option
    )) as PickedFile?;

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pickImage, // Open gallery/camera when tapped
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
              color:
              Colors.transparent), // To make the default border invisible
        ),
        child: CustomPaint(
          painter: DashedBorderPainter(),
          child: ClipRRect(
            borderRadius:
            BorderRadius.circular(12.0), // Optional for rounded corners
            child: _image == null
                ? SvgPicture.asset(
              Images.imageUpload,
              fit: BoxFit.fitWidth,
              width: 200,
              height: 200,
            )
                : Image.file(
              _image!, // Display the selected image
              fit: BoxFit.fitWidth,
              width: 200,
              height: 200,
            ),
          ),
        ),
      ),
    );
  }
}

class DashedBorderPainter extends CustomPainter {
  final double dashWidth;
  final double dashSpace;

  DashedBorderPainter({this.dashWidth = 4.0, this.dashSpace = 4.0});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = ColorUtils.hintGrey
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    double startX = 0.0;
    double startY = 0.0;

    // Paint the top border
    _drawDashedLine(
        canvas, paint, Offset(startX, startY), Offset(size.width, startY));

    // Paint the right border
    _drawDashedLine(canvas, paint, Offset(size.width, startY),
        Offset(size.width, size.height));

    // Paint the bottom border
    _drawDashedLine(canvas, paint, Offset(size.width, size.height),
        Offset(0.0, size.height));

    // Paint the left border
    _drawDashedLine(
        canvas, paint, Offset(0.0, size.height), Offset(0.0, startY));
  }

  void _drawDashedLine(Canvas canvas, Paint paint, Offset start, Offset end) {
    double dx = end.dx - start.dx;
    double dy = end.dy - start.dy;
    double distance = sqrt(dx * dx + dy * dy);
    double dashCount = distance / (dashWidth + dashSpace);
    double dxStep = dx / dashCount;
    double dyStep = dy / dashCount;

    for (double i = 0.0; i < dashCount; i++) {
      double startX = start.dx + i * dxStep;
      double startY = start.dy + i * dyStep;
      double endX = startX + dxStep;
      double endY = startY + dyStep;

      if (i.toInt() % 2 == 0) {
        canvas.drawLine(Offset(startX, startY), Offset(endX, endY), paint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class image_picker_2 extends StatefulWidget {
  final Function(File?) onImagePicked; // Callback to send the image back

  image_picker_2({required this.onImagePicked});

  @override
  State<image_picker_2> createState() => _image_picker_2State();
}

class _image_picker_2State extends State<image_picker_2> {
  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery, // Change to ImageSource.camera for camera
    );

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path); // Convert XFile to File
      });
      widget.onImagePicked(_image); // Notify parent about the image
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pickImage, // Open gallery/camera when tapped
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: ColorUtils.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Color(0xFF87CDEA).withOpacity(0.2),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: CustomPaint(

          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: _image == null
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    Images.imgUpload,
                    fit: BoxFit.contain,
                    width: 52,
                    height: 52,
                    color: ColorUtils.grey3,
                  ),
                  // SizedBox(height: 8),
                  // TextWidget(
                  //   textValue: 'Add Image',
                  //   textColor: ColorUtils.grey3,
                  //   fontFamily: FontUtils.urbanistMedium,
                  //   fontSize: 14,
                  // ),
                ],
              ),
            )
                : Image.file(
              _image!, // Display the selected image
              fit: BoxFit.cover,
              width: double.infinity,
              height: 120,
            ),
          ),
        ),
      ),
    );
  }
}