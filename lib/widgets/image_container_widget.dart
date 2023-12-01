import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ImageContainer extends StatefulWidget {
  ImageContainer({
    super.key,
    required this.setImage,
  });

  void Function(File?) setImage;

  @override
  State<ImageContainer> createState() => _ImageContainerState();
}

class _ImageContainerState extends State<ImageContainer> {
  //이미지를 담을 변수 선언
  XFile? _image;

  //ImagePicker 초기화
  final ImagePicker picker = ImagePicker();

  Future<bool> isPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
    ].request();
    if (statuses[Permission.camera] == PermissionStatus.denied) {
      return false;
    }
    if (statuses[Permission.camera] == PermissionStatus.permanentlyDenied) {
      openAppSettings();

      return false;
    }

    return true;
  }

  Future getImage(ImageSource imageSource) async {
    final grant = await isPermission();
    if (!grant) {
      return;
    }

    //pickedFile에 ImagePicker로 가져온 이미지가 담긴다.
    final XFile? pickedFile = await picker.pickImage(source: imageSource);
    if (pickedFile != null) {
      setState(() {
        _image = XFile(pickedFile.path); //가져온 이미지를 _image에 저장
        widget.setImage(File(pickedFile.path));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconButton(
          onPressed: () async {
            final grant = await isPermission();
            if (!grant) return;
            // ignore: use_build_context_synchronously
            showModalBottomSheet(
              context: context,
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              builder: (BuildContext context) {
                return StatefulBuilder(builder: (
                  BuildContext context,
                  StateSetter bottomState,
                ) {
                  return Container(
                    height: 175,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20),
                      ),
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: [
                          const Center(
                            child: Icon(
                              Icons.horizontal_rule_rounded,
                              size: 40,
                              color: Colors.black45,
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                leading: const Icon(
                                  CupertinoIcons.camera,
                                ),
                                title: const Text('Camera'),
                                onTap: () {
                                  getImage(ImageSource.camera);
                                  Navigator.pop(context);
                                },
                              ),
                              const Divider(
                                height: 0,
                              ),
                              ListTile(
                                leading: const Icon(
                                  Icons.image_outlined,
                                ),
                                title: const Text('Gallery'),
                                onTap: () {
                                  getImage(ImageSource.gallery);
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                });
              },
            );
          },
          icon: const Icon(
            Icons.photo_library,
          ),
        ),
        if (_image != null)
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.7,
            height: 250,
            child: Stack(
              children: [
                Image.file(
                  File(_image!.path),
                ),
                Positioned(
                  top: 10,
                  right: 94,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _image = null;
                        widget.setImage(null);
                      });
                    },
                    child: Container(
                      width: 17,
                      height: 17,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: Colors.white,
                            width: 1,
                          )),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
      ],
    );
  }
}
