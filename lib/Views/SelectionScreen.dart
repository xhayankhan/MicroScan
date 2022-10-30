import 'dart:developer';
import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ocrapp/Controller/ServerController.dart';
import 'package:ocrapp/Views/FilesandFolder.dart';
import 'package:ocrapp/Views/HomePage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';

import '../AdsController/GettingAdds.dart';
import '../AdsController/OpenAds.dart';
import '../Constants/Constants.dart';
import '../Controller/FolderController.dart';

class MultiSelectCheckListScreen extends StatefulWidget {
  MultiSelectCheckListScreen({Key? key}) : super(key: key);

  @override
  State<MultiSelectCheckListScreen> createState() => _MultiSelectCheckListScreenState();
}

class _MultiSelectCheckListScreenState extends State<MultiSelectCheckListScreen> {
  var pickedFile;

  File? image1;

  bool pdf=false;

  ServerController server=Get.find();

  FolderController folder=Get.find();

  ImagePicker imagePicker = ImagePicker();

  TextEditingController search=TextEditingController();
  List allPagesList = [];
  List allPagesList2 = [];
  List reversedList=[];
  List straightList=[];
  List pdfs=[];
  List docx=[];
  List folders=[];
  var itemss = [];

  final List<String> items = [
    'A to Z',
    'Z to A',
  ];

  final List<String> options = [
    'Open',
    'Rename',
    'Delete',
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

    var selectedItems=[];

  final MultiSelectController _controller = MultiSelectController();
  var foldersPath ;
  Directory? dirFolder ;
  var args=Get.arguments;
  AppOpenAdManager appOpenAdManager = AppOpenAdManager();
  var selectAll=true;
  var unselectAll=false;
  @override
void initState(){
  final applicationBloc = Provider.of<get_ads>(context, listen: false);

  //Show AppOpen Ad After 8 Seconds

  WidgetsBinding.instance.addPostFrameCallback(
        (_) => getads(),
  );
  appOpenAdManager.loadAd();
  super.initState();
  itemss=args;
  getFolders();
}
void dispose(){

    super.dispose();
}
  getads() async {
    final applicationBloc = Provider.of<get_ads>(context, listen: false);
    appOpenAdManager.loadAd();
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

        log(f1.absolute.path);}
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
  @override
  Widget build(BuildContext context) {
    final applicationBloc = Provider.of<get_ads>(context);

    return Scaffold(
      backgroundColor: Colors.white,

        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(children: [
                Container(
                    color: Colors.white,
                    width: double.infinity,
                    height: 7.h,
                    child: applicationBloc.is_select_banner_Ready == true
                        ? AdWidget(ad: applicationBloc.select_banner)
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
                height: 20.h,
                width: 100.w,
                decoration: const BoxDecoration(
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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(

                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(onPressed: (){
                            Navigator.pop(context);
                          }, icon: const Icon(Icons.arrow_back_ios,color: Colors.white,)),
                          Builder(
                            builder: (context) {
                              if(selectAll==false){
                              return InkWell(
                                onTap: (){
                                  setState((){
                                    selectAll=true;
                                    unselectAll=false;
                                  });
                                  selectedItems.clear();

                                  _controller.deselectAll();


                                },
                                child: const Text('Unselect All',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: Colors.white),),
                              );
                            }
                            else{
                                return InkWell(
                                  onTap: (){
                                    setState((){
                                      selectAll=false;
                                      unselectAll=true;
                                    });
                                    selectedItems.clear();

                                    _controller.selectAll();
                                    for(var itms in args){
                                      selectedItems.add(itms);

                                    }
                                    print(selectedItems);
                                  },
                                  child: const Text('Select All',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: Colors.white),),
                                );
                              }

                            }
                          ),


                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0,right: 8,top: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text('Select',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: Colors.white),),


                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 55.w,
                            height: 5.h,

                            child: TextField(
                              onChanged: (value) {
                                filterSearchResults(value);
                              },
                              controller: search,
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
                          DropdownButtonHideUnderline(
                            child: DropdownButton2(
                              isExpanded: true,
                              hint: Row(
                                children: const [

                                  Expanded(
                                    child: Text(
                                      'All files',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              items: filesOption
                                  .map((item) =>
                                  DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(
                                      item,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ))
                                  .toList(),
                              value: selectedFileOption,
                              onChanged: (value) {
                                setState(() {
                                  selectedFileOption = value as String;
                                });
                                if(selectedFileOption=='PDF'){
                                  setState((){
                                    itemss=pdfs;});
                                }
                                else if(selectedFileOption=='DOCX'){
                                  setState((){
                                    itemss=docx;});
                                }
                                else if(selectedFileOption=='All files'){
                                  setState((){
                                    itemss=allPagesList2;});
                                }
                                else{
                                  setState((){
                                    itemss =allPagesList2;});
                                }
                              },
                              icon: const Icon(
                                Icons.keyboard_arrow_down_sharp,
                                size: 20,
                              ),
                              iconSize: 14,
                              iconEnabledColor: Colors.white,
                              iconDisabledColor: Colors.grey,
                              buttonHeight: 5.h,
                              buttonWidth: 25.w,
                              buttonPadding: const EdgeInsets.only(left: 14, right: 14),
                              buttonDecoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),

                                color: fillColor,
                              ),
                              itemHeight: 40,
                              itemPadding: const EdgeInsets.only(left: 14, right: 14),
                              dropdownMaxHeight: 200,
                              dropdownWidth: 130,
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


              Expanded(
                child: MultiSelectCheckList(
                 // maxSelectableCount: 5,
                  textStyles: const MultiSelectTextStyles(
                      selectedTextStyle: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                  itemsDecoration: MultiSelectDecorations(
                      selectedDecoration:
                      BoxDecoration(color: lightBlue.withOpacity(0.8))),
                  listViewSettings: ListViewSettings(
                      separatorBuilder: (context, index) => const Divider(
                        height: 0,
                      )),
                  controller: _controller,
                  items: List.generate(
                      args.length,
                          (index) => CheckListCard(
                          value: args[index],
                          title: Text('${args[index]}'.split("Folders/")[1].split("/")[1],overflow: TextOverflow.fade,maxLines: 1,softWrap: false,style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),

                              selectedColor: Colors.white,
                          checkColor: darkBlue,
                         // selected: index == 0,
                         // enabled: !(index == 5),
                          checkBoxBorderSide:
                          const BorderSide(color: Colors.blue),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)))),
                  onChange: (allSelectedItems, selectedItem) {
                    setState((){
                      selectedItems=allSelectedItems;
                      log(selectedItem.toString());
                      log(allSelectedItems.toString());
                    });

                  },

                ),
              ),
              Container(
                height: 10.h,
                decoration: const BoxDecoration(
                  color: darkBlue
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0,bottom: 8,left: 20,right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                    InkWell(
                      onTap: () async{

                        List<String> selectedPaths=[];
                        var selectedFolder;
                        Get.defaultDialog(
                            backgroundColor: Colors.white,
                            title: 'Select Folder',
                            titleStyle: const TextStyle(fontWeight: FontWeight.bold),
                            content: Container(
                              height: 30.h,
                              width: 80.w,
                              child: ListView.builder(
                                itemCount: folders.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return InkWell(
                                    onTap: () async{
                                      setState(() {
                                        selectedFolder=folders[index].toString();

                                        log(selectedFolder);
                                      });
                                      for(int i=0;i<selectedItems.length;i++){
                                        selectedPaths.add(selectedItems[i].toString());
                                        log('Selected items are $i: ${selectedItems[i]}');
                                        var filename='${selectedItems[i]}'.split("Folders/")[1].split("/")[1];
                                        //await folder.moveFile(selectedItems[i], '$selectedFolder/');
                                        await File(selectedItems[i]).rename('$selectedFolder/$filename');
                                      }
                                      Navigator.pop(context);
                                      Fluttertoast.showToast(
                                          msg: "Files moved successfully",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.green,
                                          textColor: Colors.white,
                                          fontSize: 16.0
                                      );

                                      Get.off(()=>const FilesandFolders());
                                      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>FilesandFolders()));
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Directory(folders[index]).listSync().length==0?SvgPicture.asset('assets/noitemfolder.svg',):SvgPicture.asset('assets/itemsfolder.svg'),
                                          const SizedBox(width: 7,),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Text('${folders[index].toString().split('/Folders/')[1]}',style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 12,overflow: TextOverflow.ellipsis,),maxLines: 1,),
                                              Text('${Directory(folders[index]).listSync().length} files',style: const TextStyle(color: Colors.black,fontSize: 12)),

                                            ],
                                          ),

                                        ],
                                      ),
                                    ),
                                  );

                                },

                              ),
                            ));


                      },
                      child: Column(
                        children: [
                          const Icon(Icons.drive_file_move,color: Colors.white,),
                          const Text('Move',style: TextStyle(color: Colors.white),),
                        ],
                      ),
                    ),

                      InkWell(
                        onTap: () async{

                          List<String> selectedPaths=[];
                          for(int i=0;i<selectedItems.length;i++){
                            selectedPaths.add(selectedItems[i].toString());
                            print(selectedPaths);
                          }
                          await Share.shareFiles(selectedPaths, text: 'Courtesy of Micro Scan\nhttps://play.google.com/store/apps/details?id=com.appexsoft.microscan.image.to.text');

                          Get.off(()=>const HomePage());
                        },
                        child: Column(
                          children: [
                            const Icon(Icons.share,color: Colors.white,),
                            const Text('Share',style: TextStyle(color: Colors.white),),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: (){

                          Get.defaultDialog(
                            titleStyle: const TextStyle(
                              color: darkBlue,
                              fontWeight: FontWeight.bold
                            ),
                            title: 'Are you sure?'.tr,
                            middleText: "Once deleted, the Documents cannot be returned".tr,
                            middleTextStyle: const TextStyle(
                                color: darkBlue,
                            ),
                            backgroundColor: dialogueColor,
                            barrierDismissible: false,
                            radius: 20.0,
                            confirm: Container(
                              width: 80,
                              child: ElevatedButton(onPressed: () async{

                                //await documentController.fetchNewMedia();

                                for(int i=0;i<selectedItems.length;i++){
                                  server.deleteFile(File(selectedItems[i]));
                                }

                                Get.snackbar('Deleted'.tr,'All Selected Documents Deleted Successfully'.tr,duration: const Duration(seconds: 2),backgroundColor: Colors.red,snackPosition: SnackPosition.BOTTOM);

                                Get.off(()=>const HomePage());

                              },
                                child:Center(child: Text('Yes'.tr),),style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.red),),),
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
                            ),                          );

                        },
                        child: Column(
                          children: [
                            const Icon(Icons.delete,color: Colors.white,),
                            const Text('Delete',style: TextStyle(color: Colors.white),),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
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
        itemss.addAll(args);
      });
    }
  }
}