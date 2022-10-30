import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_manager/photo_manager.dart';

import '../Constants/Constants.dart';

class FolderController extends GetxController{
  TextEditingController folderName=TextEditingController();
  RxString factor = ''.obs;

  late File file;

  List mediaList = [];
  int currentPage = 0;
  int? lastPage;
  Uint8List? uint8list1;
  List filesssss = [];
  List item = [];
  RxString inter=''.obs;
  var gal;
  Future<bool> openDialog(BuildContext context) async {
    switch (await showDialog(
        context: context,
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: SimpleDialog(
              backgroundColor: dialogueColor,
              clipBehavior: Clip.hardEdge,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              contentPadding: EdgeInsets.zero,
              children: <Widget>[
                Container(

                  padding: EdgeInsets.only(bottom: 10, top: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        child: Icon(
                          Icons.exit_to_app,
                          size: 30,
                          color: darkBlue,
                        ),
                        margin: EdgeInsets.only(bottom: 10),
                      ),
                      Text(
                        'Exit App'.tr,
                        style: TextStyle(
                            color: darkBlue,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Are you sure to exit app?'.tr,
                        style: TextStyle(color:darkBlue, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                SimpleDialogOption(
                  onPressed: () {
                    Navigator.pop(context, 0);
                  },
                  child: Row(
                    children: <Widget>[
                      Container(
                        child: Icon(
                          Icons.cancel,
                                color: darkBlue,
                        ),
                        margin: EdgeInsets.all(10),
                      ),
                      Text(
                        'Cancel'.tr,
                        style: TextStyle(
color: darkBlue,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
                SimpleDialogOption(
                  onPressed: () {
                    Navigator.pop(context, 1);
                  },
                  child: Row(
                    children: <Widget>[
                      Container(
                        child: Icon(
                          Icons.check_circle,
                            color: darkBlue,
                        ),
                        margin: EdgeInsets.all(10),
                      ),
                      Text(
                        'Yes'.tr,
                        style: TextStyle(
color: darkBlue,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        })) {
      case 0:
        break;
      case 1:
        exit(0);
    }
    return true;
  }
  createFolder(String name)async{
    Directory? directory = await getApplicationDocumentsDirectory();

    bool directoryExists =
    await Directory('${directory.path}/Documents/Folders/$name').exists();

    if (!directoryExists) {
      print("\n Directory not exist");
      //  navigateToShowPage(path, -1);
     var a= await Directory('${directory.path}/Documents/Folders/$name').create(recursive: true);
        log(a.path);
      //Getting all images of chapter from firectory

    }
    else{
      await Directory('${directory.path}/Documents/Folders/${name}1').create(recursive: true);

    }
  }

   moveFile(File sourceFile, String newPath) async {
    try {
      // prefer using rename as it is probably faster
      return await sourceFile.rename(newPath);
    } on FileSystemException catch (e) {
      // if rename fails, copy the source file and then delete it
      final newFile = await sourceFile.copy(newPath);
      log('new file path is :$newFile');
      await sourceFile.delete();

    }
  }
  handleScrollEvent(ScrollNotification scroll) {
    if (scroll.metrics.pixels / scroll.metrics.maxScrollExtent > 0.33) {
      if (currentPage != lastPage) {
        fetchNewMedia();
      }
    }
  }

  fetchNewMedia() async {


    lastPage = currentPage;
      mediaList.clear();
    List<AssetPathEntity> albums =
    await PhotoManager.getAssetPathList(
        type: RequestType.image,
        onlyAll: true);

    List<AssetEntity> media =
    await albums[0].getAssetListPaged(
        size: 20, page: currentPage); //preloading files
    print(media);
    List<Widget> temp = [];


    for (var asset in media) {
      var g=asset.id;
      Uint8List? uint8list=await asset.thumbnailDataWithSize(ThumbnailSize(500,500));
      mediaList.add(uint8list);

    }

  }

}