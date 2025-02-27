import 'dart:io';

import 'package:bnbscout24/components/button.dart';
import 'package:bnbscout24/constants/constants.dart';
import 'package:bnbscout24/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerWidget extends StatefulWidget {
  final Function(List<XFile> files) onImagesPicked;
  final double? size;

  const ImagePickerWidget({super.key, required this.onImagesPicked, this.size});

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  List<XFile> pickedFiles = List.empty(growable: true);
  final ImagePicker imagePicker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: widget.size ?? 250,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            SizedBox(
              width: widget.size ?? 250,
              height: widget.size ?? 250,
              child: ElevatedButton(

                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorPalette.lightGrey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Sizes.borderRadius),
                    ),
                  
                    elevation: 0, // No shadow
                  ),
                  onPressed: () async {
                    List<XFile> files = await imagePicker.pickMultiImage();
                    widget.onImagesPicked(files);
                    setState(() {
                      pickedFiles = files;
                    });
                  },
                  child: Icon(Icons.photo),
                  ),
            ),
            ...pickedFiles.map((file) => Container(
                  width: widget.size ?? 250,
                  height: widget.size ?? 250,
                  margin: EdgeInsets.all(Sizes.paddingSmall),
                  decoration: BoxDecoration(
                      color: ColorPalette.lighterGrey,
                      borderRadius: BorderRadius.circular(Sizes.borderRadius)),
                  child: Image.file(File(file.path)),
                ))
          ],
        ));
  }
}
