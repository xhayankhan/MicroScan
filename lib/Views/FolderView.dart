import 'dart:developer';
import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:ocrapp/Constants/Constants.dart';
import 'package:ocrapp/Controller/FolderController.dart';
import 'package:ocrapp/Views/FilesandFolder.dart';
import 'package:ocrapp/Views/HomePage.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../AdsController/GettingAdds.dart';
import '../AdsController/OpenAds.dart';
import '../Controller/ServerController.dart';
import 'SavedFilesPreview.dart';
import 'SelectionScreen.dart';

class FolderView extends StatefulWidget {
  const FolderView({Key? key}) : super(key: key);

  @override
  State<FolderView> createState() => _FolderViewState();
}

class _FolderViewState extends State<FolderView> {
  var pickedFile;
  File? image1;
  bool pdf=false;
  ServerController server=Get.find();
  FolderController folder=Get.find();

  ImagePicker imagePicker = ImagePicker();
  TextEditingController search=TextEditingController();
  var itemss = [];
  final List<String> items = [
    'A to Z',
    'Z to A',
  ];
  final List<String> options = [
    'Open',
    'Rename',
    'Delete',
    'Move to',
    'Share'
  ];
  final List<String> folderOptions = [
    'Open',
    'Rename',
    'Delete',
    'Share'
  ];
  final List<String> filesOption = [
    'All files',
    'PDF',
    'DOCX'
  ];
  String? selectedFileOption;
  String? selectedValue;
  String? selectedOption;
  String? selectedOption1;
  String? selectedFolderOpt;
  var img;
  AppOpenAdManager appOpenAdManager = AppOpenAdManager();

  @override
  void initState(){
    final applicationBloc = Provider.of<get_ads>(context, listen: false);

    //Show AppOpen Ad After 8 Seconds

    WidgetsBinding.instance.addPostFrameCallback(
          (_) => getads(),
    );
    appOpenAdManager.loadAd();
    super.initState();
    getData();
    getFolders();
  folderName=args.toString().split('/Folders/')[1];
  if(folderName.toString().contains('Recents')){
    recents=true;
  }
  log(folderName);
    server.permissionCheck();
  }
  void dispose(){
    search.dispose();
    super.dispose();
  }
  List allPagesList = [];
  List allPagesList2 = [];
  List reversedList=[];
  List straightList=[];
  List pdfs=[];
  var folderName;
  List docx=[];
  List folders=[];
  var ImagesPath ;
  Directory? dir2 ;
  var foldersPath ;
  Directory? dirFolder ;
  var recents=false;
  var args=Get.arguments;
  void getData() async {
    reversedList.clear();
    allPagesList2.clear();
    allPagesList.clear();
    itemss.clear();

    var appDir=await getApplicationDocumentsDirectory();
    dir2=Directory('$args/');
    ImagesPath='$args/';

    bool directoryExists =
    await Directory(ImagesPath).exists();

    if(directoryExists){
      List<FileSystemEntity> files = dir2!.listSync();
      print("\nAll Images inside");

      for (FileSystemEntity f1 in files) {
        allPagesList.add(f1.absolute.path);
        setState((){});
        print(f1.absolute.path);
      }
      allPagesList2=allPagesList.reversed.toList();
      log("allpages:${allPagesList2}");


    }
    else if(!directoryExists){
      await Directory('${ImagesPath}').create(recursive: true);
    }
    allPagesList2.sort((a, b) => a.toString().compareTo(b.toString()));
    straightList=allPagesList2;
    reversedList=allPagesList2.reversed.toList();
    itemss=allPagesList2;

    docTypeCheck();
  }
  void getFolders() async {

    folders.clear();

    var appDir=await getApplicationDocumentsDirectory();
    dirFolder=Directory('${appDir.path}/Documents/Folders/');
    foldersPath='${appDir.path}/Documents/Folders/';

    bool directoryExists =
    await Directory(foldersPath).exists();

    if(directoryExists){
      List<FileSystemEntity> files = dirFolder!.listSync();

      for (FileSystemEntity f1 in files) {
        
        if(f1.absolute.path.contains('Saved')||f1.absolute.path.contains('Recents')){
          log(f1.absolute.path);
        }else{
          folders.add(f1.absolute.path);
          setState((){

          });

          print(f1.absolute.path);}
      }
      // folders=folders.reversed.toList();
      print("allfolders:${folders}");


    }
    else if(!directoryExists){
      await Directory('${foldersPath}').create(recursive: true);
      var a= await Directory('${foldersPath}/Recents').create(recursive: true);
      print(a);
    }

  }
  docTypeCheck(){
    for(int i=0;i<allPagesList2.length;i++){
      pdf=allPagesList2[i].contains(".pdf");
      if(pdf==true){
        setState(() {

          pdfs.add(allPagesList2[i]);
        });
      }
      else{
        setState(() {

          docx.add(allPagesList2[i]);
        });
      }
    }
    print('pdfs are $pdfs');
    print('docxs are $docx');
  }
  getads() async {
    final applicationBloc = Provider.of<get_ads>(context, listen: false);
    appOpenAdManager.loadAd();

  }
  @override
  Widget build(BuildContext context) {
    final applicationBloc = Provider.of<get_ads>(context);

    return WillPopScope(
      onWillPop: (){

        if(recents==true){
          Get.off(()=>HomePage());
        }else{
          Get.off(()=>FilesandFolders());
        }
        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: ListView(
            children: [
              Column(
                children: [
                  Stack(children: [
                    Container(
                        color: Colors.white,
                        width: double.infinity,
                        height: 7.h,
                        child: applicationBloc.is_folder_banner_Ready == true
                            ? AdWidget(ad: applicationBloc.folder_banner)
                            : Container()
                    ),
                    Container(
                      color: Colors.transparent,
                      width: double.infinity,
                      height: 7.h,
                      alignment: Alignment.topRight,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        color: Colors.yellow,
                        child: const Text(
                          "Ad",
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w500),
                        ),
                      ),
                    )
                  ]),
                  Container(

                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            lightBlue,
                            darkBlue,
                          ],
                        )
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0,right: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: recents==true?14.h:20.h,
                              width: 100.w,
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      lightBlue,
                                      darkBlue,
                                    ],
                                  )
                              ),
                              child: Column(
                                children: [
                                  SizedBox(height: 2,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                       IconButton(onPressed: (){
                                        if(recents==true){
                                          Get.off(()=>HomePage());
                                        }else{
                                          Get.off(()=>FilesandFolders());
                                        }
                                      },icon: Icon(Icons.arrow_back_ios,color: Colors.white,),),
                                       InkWell(
                                        onTap: (){
                                          if(allPagesList2.isEmpty){
                                            Fluttertoast.showToast(
                                                msg: "No items to select from",
                                                toastLength: Toast.LENGTH_LONG,
                                                gravity: ToastGravity.BOTTOM,
                                                timeInSecForIosWeb: 1,
                                                backgroundColor: Colors.red,
                                                textColor: Colors.white,
                                                fontSize: 16.0
                                            );
                                          }
                                          else {
                                            Get.off(() =>
                                                MultiSelectCheckListScreen(),
                                                arguments: allPagesList2);
                                          }},
                                        child: Text('Select Files',style: TextStyle(fontWeight: FontWeight.w900,color: Colors.white),),
                                      ),


                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0,right: 8,top: 8),
                                    child: Row(
                                      mainAxisAlignment: recents==true?MainAxisAlignment.center:MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: recents==true?CrossAxisAlignment.center:CrossAxisAlignment.end,
                                      children: [
                                        Text(args.toString().split('/Folders/')[1],style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: Colors.white),),


                                      ],
                                    ),
                                  ),
                                  recents==true?Text(''):Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: 70.w,
                                          height: 5.h,

                                          child: TextField(
                                            onChanged: (value) {
                                              filterSearchResults(value);
                                            },
                                            controller: search,
                                            style: TextStyle(
                                              color: Colors.white
                                            ),
                                            decoration: const InputDecoration(
                                                fillColor: fillColor,
                                                filled: true,
                                                labelText: "Search",
                                                // hintText: "Search",
                                                suffixIcon: Icon(Icons.search),
                                                border: OutlineInputBorder(

                                                    borderRadius: BorderRadius.all(Radius.circular(10.0)))),
                                          ),
                                        ),
                                        Container(
                                          height: 5.h,
                                          width: 10.w,
                                          decoration: BoxDecoration(
                                              color: fillColor,
                                              borderRadius: BorderRadius.circular(8)
                                          ),
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton2(
                                              isExpanded: true,
                                              customButton: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: const [
                                                  Icon(
                                                    Icons.filter_list,
                                                    size: 28,
                                                    color: Colors.white,
                                                  ),

                                                ],
                                              ),
                                              items: items
                                                  .map((item) => DropdownMenuItem<String>(
                                                value: item,
                                                child: Row(
                                                  children: [
                                                    Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: item=='A to Z'?SvgPicture.asset('assets/atoz.svg'):SvgPicture.asset('assets/ztoa.svg')
                                                    ),

                                                    Text(
                                                      item,
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.white,
                                                      ),
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ],
                                                ),
                                              ))
                                                  .toList(),
                                              value: selectedValue,
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedValue = value as String;
                                                });
                                                if(selectedValue=='Z to A'){
                                                  setState((){
                                                    itemss=reversedList;

                                                  });

                                                }
                                                else if(selectedValue=='A to Z'){
                                                  setState(() {
                                                    itemss=straightList;
                                                  });
                                                }
                                              },
                                              icon: const Icon(
                                                Icons.arrow_forward_ios_outlined,
                                              ),
                                              iconSize: 14,
                                              iconEnabledColor: Colors.white,
                                              iconDisabledColor: Colors.grey,
                                              buttonHeight: 50,
                                              buttonWidth: 100,
                                              buttonPadding: const EdgeInsets.only(left: 14, right: 14),
                                              buttonDecoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(8),
                                                border: Border.all(
                                                  color: Colors.black26,
                                                ),
                                                color: fillColor,
                                              ),
                                              buttonElevation: 2,
                                              itemHeight: 40,
                                              itemPadding: const EdgeInsets.only(left: 14, right: 14),
                                              dropdownMaxHeight: 200,
                                              dropdownWidth:130,
                                              dropdownPadding: null,
                                              dropdownDecoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(8),
                                                color: fillColor,
                                              ),
                                              dropdownElevation: 8,
                                              scrollbarRadius: const Radius.circular(40),
                                              scrollbarThickness: 6,
                                              scrollbarAlwaysShow: true,
                                              offset: const Offset(-20, 0),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),


                          ],
                        ),
                      ),
                    ),
                  ),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 10,
                      ),
                      Container(
                        height: 70.h,
                        width: 95.w,
                        child: Builder(
                            builder: (context) {
                              if(itemss.isNotEmpty){
                                  if(recents==false) {
                                    return ListView.builder(

                                        itemCount: itemss.length,
                                        itemBuilder: (context, index) {
                                          return Column(
                                            children: [
                                              InkWell(
                                                onTap: () async {
                                                  if (itemss[index]
                                                      .toString()
                                                      .contains('.docx')) {
                                                    final result1 = await OpenFilex
                                                        .open(itemss[index]);
                                                    if (result1.message ==
                                                        'No APP found to open this file。') {
                                                      Get.defaultDialog(
                                                        title: "Can't Open",
                                                        content: Text(
                                                            'No app found to open word file'),
                                                        confirm: Padding(
                                                          padding: const EdgeInsets
                                                              .all(8.0),
                                                          child: InkWell(
                                                            onTap: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: Container(

                                                              height: 30,
                                                              width: 60,
                                                              decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius
                                                                      .circular(
                                                                      10),
                                                                  color: Colors
                                                                      .red
                                                              ),
                                                              child: Center(
                                                                  child: Text(
                                                                      'Ok')),
                                                            ),
                                                          ),
                                                        ),

                                                      );
                                                    }
                                                    log(result1.message);
                                                  }
                                                  else {
                                                    Get
                                                        .to(() => const SavedFilesPreview(),
                                                        arguments: itemss[index]);
                                                  }
                                                },
                                                child: Card(
                                                  elevation: 0,
                                                  color: Colors.white,
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(
                                                        8.0),
                                                    child: Row(

                                                      mainAxisAlignment: MainAxisAlignment
                                                          .spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            itemss[index].toString().contains('.pdf')?SvgPicture.asset('assets/pdf (1).svg'):SvgPicture.asset('assets/word (1).svg'),
                                                            SizedBox(width: 5.w,),
                                                            Column(
                                                              crossAxisAlignment: CrossAxisAlignment
                                                                  .start,
                                                              mainAxisAlignment: MainAxisAlignment
                                                                  .start,
                                                              children: [
                                                                Container(
                                                                    width: 60.w,
                                                                    child: itemss[index]
                                                                        .toString()
                                                                        .contains(
                                                                        '.png')
                                                                        ? Text(
                                                                      '${itemss[index]}'
                                                                          .split(
                                                                          "/$folderName/")[1]
                                                                          .split(
                                                                          ".png")[0],
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .black,
                                                                          fontWeight: FontWeight
                                                                              .bold),
                                                                      overflow: TextOverflow
                                                                          .fade,
                                                                      maxLines: 1,
                                                                      softWrap: false,)
                                                                        : Text(
                                                                      '${itemss[index]}'
                                                                          .split(
                                                                          "/$folderName/")[1]
                                                                          .split(
                                                                          ".docx")[0],
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .black,
                                                                          fontWeight: FontWeight
                                                                              .w900),
                                                                      overflow: TextOverflow
                                                                          .fade,
                                                                      maxLines: 1,
                                                                      softWrap: false,)),
                                                                Text(
                                                                  'Created: ${FileStat
                                                                      .statSync(
                                                                      itemss[index])
                                                                      .accessed}'
                                                                      .split(
                                                                      ".")[0]
                                                                      .replaceAll(
                                                                      '-', '/'),
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .grey),),

                                                              ],
                                                            ),
                                                            SizedBox(width: 10,),
                                                            DropdownButtonHideUnderline(
                                                              child: DropdownButton2(
                                                                customButton: Row(
                                                                  children: const [
                                                                    Icon(
                                                                      Icons
                                                                          .more_horiz,
                                                                      size: 28,
                                                                      color: Colors
                                                                          .grey,
                                                                    ),

                                                                  ],
                                                                ),
                                                                items: options
                                                                    .map((item) =>
                                                                    DropdownMenuItem<
                                                                        String>(
                                                                      value: item,
                                                                      child: Text(
                                                                        item,
                                                                        style: const TextStyle(
                                                                          fontSize: 14,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          color: Colors
                                                                              .white,
                                                                        ),
                                                                        overflow: TextOverflow
                                                                            .ellipsis,
                                                                      ),
                                                                    ))
                                                                    .toList(),
                                                                value: selectedOption1,
                                                                onChanged: (
                                                                    value) async {
                                                                  setState(() {
                                                                    selectedOption1 =
                                                                    value as String;
                                                                  });
                                                                  if (value ==
                                                                      'Open') {
                                                                    if (itemss[index]
                                                                        .toString()
                                                                        .contains(
                                                                        '.docx')) {
                                                                      final result1 = await OpenFilex
                                                                          .open(
                                                                          itemss[index]);
                                                                    }
                                                                    else {
                                                                      Get
                                                                          .to(() => const SavedFilesPreview(),
                                                                          arguments: itemss[index]);
                                                                    }
                                                                  }
                                                                  else
                                                                  if (value ==
                                                                      'Move to') {

                                                                    var selFile = itemss[index];
                                                                    var selectedFolder;
                                                                    Get.defaultDialog(
                                                                        backgroundColor: Colors.white,
                                                                        title: 'Select Folder',
                                                                        titleStyle: TextStyle(fontWeight: FontWeight.bold),
                                                                        content: Container(
                                                                          height: 30.h,
                                                                          width: 80.w,
                                                                          child: ListView.builder(
                                                                            itemCount: folders.length,
                                                                            itemBuilder: (BuildContext context, int index) {
                                                                              return InkWell(
                                                                                onTap: () async {
                                                                                  setState(() {
                                                                                    selectedFolder =
                                                                                        folders[index]
                                                                                            .toString();
                                                                                  });
                                                                                  log(
                                                                                      selFile
                                                                                          .toString());
                                                                                  log(
                                                                                      selectedFolder);

                                                                                  var filename = '${selFile
                                                                                      .toString()}'
                                                                                      .split(
                                                                                      "Folders/")[1]
                                                                                      .split(
                                                                                      "/")[1];
                                                                                  var a = await File(
                                                                                      selFile
                                                                                          .toString())
                                                                                      .rename(
                                                                                      '$selectedFolder/$filename');

                                                                                  Navigator.pop(context);
                                                                                  setState((){getData();});
                                                                                  Fluttertoast.showToast(
                                                                                      msg: "File moved successfully",
                                                                                      toastLength: Toast.LENGTH_SHORT,
                                                                                      gravity: ToastGravity.BOTTOM,
                                                                                      timeInSecForIosWeb: 1,
                                                                                      backgroundColor: Colors.green,
                                                                                      textColor: Colors.white,
                                                                                      fontSize: 16.0
                                                                                  );
                                                                                },
                                                                                child: Padding(
                                                                                  padding: const EdgeInsets.all(8.0),
                                                                                  child: Row(
                                                                                    children: [
                                                                                      Directory(folders[index]).listSync().length==0?SvgPicture.asset('assets/noitemfolder.svg',):SvgPicture.asset('assets/itemsfolder.svg'),
                                                                                      SizedBox(width: 7,),
                                                                                      Column(
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                                        children: [
                                                                                          Text('${folders[index].toString().split('/Folders/')[1]}',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 12,overflow: TextOverflow.ellipsis,),maxLines: 1,),
                                                                                          Text('${Directory(folders[index]).listSync().length} files',style: TextStyle(color: Colors.black,fontSize: 12)),

                                                                                        ],
                                                                                      ),

                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              );

                                                                            },

                                                                          ),
                                                                        ));
                                                                  }
                                                                  else
                                                                  if (value ==
                                                                      'Delete') {
                                                                    Get.defaultDialog(

                                                                      title: 'Are you sure?'
                                                                          .tr,
                                                                      middleText: "Once deleted, the Document cannot be returned"
                                                                          .tr,
                                                                      middleTextStyle: TextStyle(
                                                                        color: darkBlue
                                                                      ),
                                                                      titleStyle: TextStyle(
                                                                        color: darkBlue,
                                                                        fontWeight: FontWeight.bold
                                                                      ),
                                                                      backgroundColor: dialogueColor,
                                                                      barrierDismissible: false,
                                                                      radius: 20.0,
                                                                      confirm: Container(
                                                                        width: 80,
                                                                        child: ElevatedButton(
                                                                          onPressed: () async {
                                                                            await server
                                                                                .deleteFile(
                                                                                File(
                                                                                    itemss[index]));
                                                                            setState(() {
                                                                              getData();
                                                                            });
                                                                            //await documentController.fetchNewMedia();
                                                                            Get
                                                                                .snackbar(
                                                                                'Deleted'
                                                                                    .tr,
                                                                                'Document Deleted Successfully'
                                                                                    .tr,
                                                                                duration: const Duration(
                                                                                    seconds: 2),
                                                                                backgroundColor: Colors
                                                                                    .red,
                                                                                snackPosition: SnackPosition
                                                                                    .BOTTOM);

                                                                            Navigator
                                                                                .pop(
                                                                                context);
                                                                          },
                                                                          child: Center(
                                                                            child: Text(
                                                                                'Yes'
                                                                                    .tr),),
                                                                          style: ButtonStyle(
                                                                            backgroundColor: MaterialStateProperty
                                                                                .all<
                                                                                Color>(
                                                                                Colors
                                                                                    .red),),),
                                                                      ),
                                                                      cancel: InkWell(
                                                                        onTap: () {
                                                                          Navigator.of(Get.overlayContext!, rootNavigator: true).pop();
                                                                        },
                                                                        child: Container(
                                                                          margin: EdgeInsets.only(top: .8.h),
                                                                          width: 80,
                                                                          height: 4.5.h,
                                                                          decoration: BoxDecoration(
                                                                            borderRadius: BorderRadius.circular(10),
                                                                            border: Border.all(
                                                                                color: darkBlue,
                                                                                width: 1
                                                                            ),
                                                                          ),
                                                                          child: const Center(child: Text('Cancel',style: TextStyle(color: darkBlue),),),
                                                                        ),
                                                                      ),
                                                                    );
                                                                  }
                                                                  else
                                                                  if (value ==
                                                                      'Share') {
                                                                    server.share(
                                                                        itemss[index]);
                                                                  }
                                                                  else
                                                                  if (value ==
                                                                      'Rename') {
                                                                    var pdf = false;
                                                                    var docx = false;
                                                                    if (itemss[index]
                                                                        .toString()
                                                                        .contains(
                                                                        '.pdf')) {
                                                                      setState(() {
                                                                        pdf =
                                                                        true;
                                                                      });
                                                                    }
                                                                    else {
                                                                      setState(() {
                                                                        docx =
                                                                        true;
                                                                      });
                                                                    }
                                                                    server.rename
                                                                        .text =
                                                                    itemss[index]
                                                                        .toString()
                                                                        .contains(
                                                                        '.pdf')
                                                                        ? '${itemss[index]}'
                                                                        .split(
                                                                        "/$folderName/")[1]
                                                                        .split(
                                                                        ".pdf")[0]
                                                                        : '${itemss[index]}'
                                                                        .split(
                                                                        "/$folderName/")[1]
                                                                        .split(
                                                                        ".docx")[0];
                                                                    Get
                                                                        .defaultDialog(
                                                                      backgroundColor: dialogueColor,
                                                                      title: "Rename File",
                                                                      titleStyle: TextStyle(fontWeight: FontWeight.bold,color: darkBlue),
                                                                      content: Padding(
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                            8.0),
                                                                        child: TextFormField(
                                                                          style: TextStyle(color: darkBlue),
                                                                          decoration: InputDecoration(
                                                                            prefixIcon: const Icon(
                                                                                Icons
                                                                                    .drive_file_rename_outline,color: darkBlue,),
                                                                            border: OutlineInputBorder(
                                                                              borderRadius: BorderRadius
                                                                                  .circular(
                                                                                  10.0),
                                                                            ),
                                                                            filled: true,
                                                                              labelStyle: TextStyle(color: darkBlue),
                                                                            labelText: 'New Name',

                                                                          ),
                                                                          //onTap: () => name.selection = TextSelection(baseOffset: 0, extentOffset: name.value.text.length),
                                                                          keyboardType: TextInputType
                                                                              .emailAddress,
                                                                          controller: server
                                                                              .rename,
                                                                        ),
                                                                      ),
                                                                      barrierDismissible: false,
                                                                      radius: 20.0,
                                                                      confirm: Container(
                                                                        width: 80,
                                                                        child: ElevatedButton(
                                                                          onPressed: () async {
                                                                            // var g = await editImage(uint8list1!);
                                                                            if (pdf ==
                                                                                true) {
                                                                              await server
                                                                                  .changeFileNameOnly(
                                                                                  File(
                                                                                      itemss[index]),
                                                                                  '${server
                                                                                      .rename
                                                                                      .text}.pdf');
                                                                            }
                                                                            else {
                                                                              await server
                                                                                  .changeFileNameOnly(
                                                                                  File(
                                                                                      itemss[index]),
                                                                                  '${server
                                                                                      .rename
                                                                                      .text}.docx');
                                                                            }

                                                                            await server
                                                                                .deleteFile(
                                                                                File(
                                                                                    itemss[index]));
                                                                            getData();
                                                                            Get
                                                                                .snackbar(
                                                                                'Successful'
                                                                                    .tr,
                                                                                'Document Renamed Successfully'
                                                                                    .tr,
                                                                                duration: const Duration(
                                                                                    seconds: 2),
                                                                                backgroundColor: Colors
                                                                                    .green,
                                                                                snackPosition: SnackPosition
                                                                                    .BOTTOM);

                                                                            Navigator
                                                                                .of(
                                                                                Get
                                                                                    .overlayContext!,
                                                                                rootNavigator: true)
                                                                                .pop();
                                                                          },
                                                                          child: Center(
                                                                            child: Text(
                                                                                'Ok'),),
                                                                          style: ButtonStyle(
                                                                            backgroundColor: MaterialStateProperty
                                                                                .all<
                                                                                Color>(
                                                                                darkBlue
                                                                            ),),),
                                                                      ),
                                                                      cancel: InkWell(
                                                                        onTap: () {
                                                                          Navigator.of(Get.overlayContext!, rootNavigator: true).pop();
                                                                        },
                                                                        child: Container(
                                                                          margin: EdgeInsets.only(top: .8.h),
                                                                          width: 80,
                                                                          height: 4.5.h,
                                                                          decoration: BoxDecoration(
                                                                            borderRadius: BorderRadius.circular(10),
                                                                            border: Border.all(
                                                                                color: darkBlue,
                                                                                width: 1
                                                                            ),
                                                                          ),
                                                                          child: Center(child: Text('Cancel',style: TextStyle(color: darkBlue),),),
                                                                        ),
                                                                      ),
                                                                    );
                                                                  }
                                                                },
                                                                icon: const Icon(
                                                                  Icons
                                                                      .arrow_forward_ios_outlined,
                                                                ),
                                                                iconSize: 14,
                                                                iconEnabledColor: Colors
                                                                    .white,
                                                                iconDisabledColor: Colors
                                                                    .grey,
                                                                buttonHeight: 50,
                                                                buttonWidth: 160,
                                                                buttonPadding: const EdgeInsets
                                                                    .only(
                                                                    left: 14,
                                                                    right: 14),
                                                                buttonDecoration: BoxDecoration(
                                                                  borderRadius: BorderRadius
                                                                      .circular(
                                                                      14),
                                                                  border: Border
                                                                      .all(
                                                                    color: Colors
                                                                        .black26,
                                                                  ),
                                                                  color: fillColor,
                                                                ),
                                                                buttonElevation: 2,
                                                                itemHeight: 40,
                                                                itemPadding: const EdgeInsets
                                                                    .only(
                                                                    left: 14,
                                                                    right: 14),
                                                                dropdownMaxHeight: 200,
                                                                dropdownWidth: 200,
                                                                dropdownPadding: null,
                                                                dropdownDecoration: BoxDecoration(
                                                                  borderRadius: BorderRadius
                                                                      .circular(
                                                                      14),
                                                                  color:fillColor,
                                                                ),
                                                                dropdownElevation: 8,
                                                                scrollbarRadius: const Radius
                                                                    .circular(40),
                                                                scrollbarThickness: 6,
                                                                scrollbarAlwaysShow: true,
                                                                offset: const Offset(
                                                                    -20, 0),
                                                              ),
                                                            ),
                                                          ],
                                                        ),


                                                      ],
                                                    ),
                                                  ),

                                                ),
                                              ),
                                              Container(
                                                width: 65.w,
                                                child: Divider(
                                                  height: 2,
                                                  thickness: 1,
                                                  color: Colors.grey,
                                                ),
                                              )
                                            ],
                                          );
                                        }

                                    );
                                  }
                                  else{
                                    return GridView.builder(

                                        itemCount: itemss.length>15?15:itemss.length,
                              gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3,
                              mainAxisSpacing: 15,
                              crossAxisSpacing: 10,
                              childAspectRatio: 0.65.h/0.7.h),
                              itemBuilder: (BuildContext context, int index) {
                                       return InkWell(
                                         onTap: (){
                                           Get
                                               .off(() => const SavedFilesPreview(),
                                               arguments: itemss[index]);
                                         },
                                         child: ClipRRect(
                                           borderRadius: BorderRadius.circular(10),
                                           child: Image.file(File(itemss[index]),   fit: BoxFit
                                             .cover,
                                             height: 60,
                                             width: 40,),
                                         ),
                                       );
                              });
                                  }
                              }
                              else{
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 30.h,
                                      child: Lottie.asset('assets/notFound.json'),
                                    ),
                                    const Text('No Saved documents are found',style: TextStyle(color: Colors.black),)
                                  ],
                                );
                              }
                            }
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void filterSearchResults(String query) {
    List dummySearchList = [];
    dummySearchList.addAll(itemss);
    if(query.isNotEmpty) {
      List<String> dummyListData = [];
      dummySearchList.forEach((item) {
        if(item.split('Documents/')[1].split('.')[0].contains(query)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        itemss.clear();
        itemss.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        itemss.clear();
        itemss.addAll(allPagesList2);
      });
    }
  }
}
