import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:delta_to_html/delta_to_html.dart';
import 'package:docx_template/docx_template.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html_to_pdf/flutter_html_to_pdf.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:ocrapp/Controller/ServerController.dart';
import 'package:ocrapp/Views/FilesandFolder.dart';
import 'package:ocrapp/Views/HomePage.dart';
import 'package:ocrapp/Views/SavedFilesPreview.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:uuid/uuid.dart';

import '../AdsController/GettingAdds.dart';
import '../AdsController/OpenAds.dart';
import '../Constants/Constants.dart';

class TextEditingScreen extends StatefulWidget {
  const TextEditingScreen({Key? key}) : super(key: key);

  @override
  State<TextEditingScreen> createState() => _TextEditingScreenState();
}

class _TextEditingScreenState extends State<TextEditingScreen> {
  ServerController server=ServerController();
  final PdfDocument document = PdfDocument();
  TextEditingController name=TextEditingController();
  String text = '';
 var uid;
  var args=Get.arguments;
  var cont;
  AppOpenAdManager appOpenAdManager = AppOpenAdManager();

  @override
  void initState(){
    final applicationBloc = Provider.of<get_ads>(context, listen: false);

    //Show AppOpen Ad After 8 Seconds

    WidgetsBinding.instance.addPostFrameCallback(
          (_) => getads(),
    );
    appOpenAdManager.loadAd();
    cont=args;
    super.initState();
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
        Get.off(()=>HomePage());
       return applicationBloc.showBackAd();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(

          child: Container(
            child: ListView(

              children: [
                Stack(children: [
                  Container(
                      color: Colors.white,
                      width: double.infinity,
                      height: 7.h,
                      child: applicationBloc.is_textEdit_banner_Ready == true
                          ? AdWidget(ad: applicationBloc.textEdit_banner)
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
                  height: 22.h,
                  color: darkBlue,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(onPressed: (){
                            Get.off(()=>HomePage());
                          }, icon: Icon(Icons.arrow_back_ios,color: Colors.white,)),
                          Text('Edit OCR Text',style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                          ),),
                          IconButton(onPressed: (){
                            showMaterialModalBottomSheet(
                              backgroundColor: Colors.transparent,
                              context: context,
                              builder: (context) => SingleChildScrollView(
                                controller: ModalScrollController.of(context),
                                child: Container(
                                  height: 25.h,
                                  decoration: BoxDecoration(
                                      color: darkBlue,
                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('Save As',style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24,
                                        color: Colors.white
                                      ),),
                                      SizedBox(height: 20,),
                                      Container(
                                        width: 90.w,
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: InkWell(
                                                onTap: () async {
                                                  uid= await Uuid();
                                                  //name.text='OCR ${DateTime.now().toString().split('.')[0]}';
                                                  name.text=uid.v1();
                                                  setState(() {


                                                    text = 'You pressed \"Let\'s go for a walk!\"';
                                                    Get.defaultDialog(
                                                      backgroundColor: dialogueColor,
                                                      titleStyle: TextStyle(fontWeight: FontWeight.bold,color: darkBlue),
                                                      title: "Enter File Name",
                                                      content:  Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: TextFormField(
                                                          style: TextStyle(color: darkBlue),
                                                          decoration: InputDecoration(
                                                            prefixIcon: const Icon(Icons.picture_as_pdf,color: darkBlue,),
                                                            border: OutlineInputBorder(
                                                              borderRadius: BorderRadius.circular(10.0),
                                                            ),
                                                            filled: true,
                                                            labelStyle: TextStyle(color: darkBlue),
                                                            labelText: 'Doc Name',

                                                          ),
                                                          //onTap: () => name.selection = TextSelection(baseOffset: 0, extentOffset: name.value.text.length),
                                                          keyboardType: TextInputType.emailAddress,
                                                          controller: name,
                                                        ),
                                                      ),
                                                      barrierDismissible: false,
                                                      radius: 20.0,
                                                      confirm: Container(
                                                        width: 80,
                                                        child: ElevatedButton(onPressed: () async {

                                                          // var g = await editImage(uint8list1!);

                                                          Navigator.of(Get.overlayContext!, rootNavigator: true).pop();
                                                          applicationBloc.showInterstitialFileAd();
                                                          await addDoc();
                                                        },
                                                          child: Center(child: Text('Ok'),),
                                                          style: ButtonStyle(
                                                            backgroundColor: MaterialStateProperty.all<Color>(
                                                                darkBlue),),),
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
                                                    //addDoc();
                                                  });
                                                },
                                                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        SvgPicture.asset('assets/pdf.svg'),
                                                        SizedBox(width: 5,),
                                                        Text('PDF',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                                                      ],
                                                    ),

                                                    Icon(Icons.arrow_forward_ios,color: Colors.white,),

                                                  ],
                                                ),
                                              ),
                                            ),
                                            Divider(
                                              height: 1,color: Colors.white,
                                              thickness: 1,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: InkWell(
                                                onTap: () async{
                                                  uid= await Uuid();
                                                  //name.text='OCR ${DateTime.now().toString().split('.')[0]}';
                                                  name.text=uid.v1();
                                                  setState(() {
                                                    text = 'You pressed \"Let\'s start a run!\"';
                                                    // var pickedFile=  server.pickFiles();
                                                    Get.defaultDialog(
                                                      backgroundColor: dialogueColor,
                                                      titleStyle: TextStyle(fontWeight: FontWeight.bold,color: darkBlue),
                                                      title: "Enter File Name",
                                                      content:  Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: TextFormField(
                                                          style: TextStyle(color: darkBlue),
                                                          decoration: InputDecoration(
                                                            prefixIcon: const Icon(Icons.file_copy,color: darkBlue,),
                                                            border: OutlineInputBorder(
                                                              borderRadius: BorderRadius.circular(10.0),
                                                            ),
                                                            filled: true,

                                                            labelStyle: TextStyle(color: darkBlue),
                                                            labelText: 'Doc Name',

                                                          ),
                                                          //onTap: () => name.selection = TextSelection(baseOffset: 0, extentOffset: name.value.text.length),
                                                          keyboardType: TextInputType.emailAddress,
                                                          controller: name,
                                                        ),
                                                      ),
                                                      barrierDismissible: false,
                                                      radius: 20.0,
                                                      confirm: Container(
                                                        width: 80,
                                                        child: ElevatedButton(onPressed: () async {

                                                          // var g = await editImage(uint8list1!);

                                                          Navigator.of(Get.overlayContext!, rootNavigator: true).pop();
                                                          await addWord();
                                                        },
                                                          child: Center(child: Text('Ok'),),
                                                          style: ButtonStyle(
                                                            backgroundColor: MaterialStateProperty.all<Color>(
                                                                darkBlue),),),
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
                                                  });
                                                },
                                                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        SvgPicture.asset('assets/word.svg'),
                                                        SizedBox(width: 5,),
                                                        Text('Word',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                                                      ],
                                                    ),

                                                    Icon(Icons.arrow_forward_ios,color: Colors.white,),

                                                  ],
                                                ),
                                              ),
                                            ),
                                            Divider(
                                              height: 1,color: Colors.white,
                                              thickness: 1,
                                            ),
                                          ],

                                        ),
                                      ),

                                    ],
                                  ),
                                ),
                              ),
                            );
                          }, icon: Icon(Icons.save_outlined,color: Colors.white,))

                        ],
                      ),
                    SizedBox(height: 5,),
                      quill.QuillToolbar.basic(controller: cont),
                    ],
                  ),
                ),

                quill.QuillEditor.basic(
                  keyboardAppearance: Brightness.dark,
                      controller: cont,
                      readOnly: false,
                    ),

              ],
            ),
          ),
        ),
      ),
    );

  }
  addDoc() async{
    var jsonn = jsonEncode(cont.document.toDelta().toJson());
    var deltaJson=cont.document.toDelta().toJson();
   var deltaHtml= DeltaToHTML.encodeJson(deltaJson);
    // List valueMap = json.decode(jsonn);
    // // var text = valueMap[0]['insert'].toString();
    // log(valueMap.toString());
    // log(text.toString());
    final PdfPage page = document.pages.add();
// Create a new PDF text element class and draw the flow layout text.
    final PdfLayoutResult layoutResult = PdfTextElement(
        text: '',
        font: PdfStandardFont(PdfFontFamily.helvetica, 24),
        brush: PdfSolidBrush(PdfColor(0, 0, 0)))
        .draw(
        page: page,
        bounds: Rect.fromLTWH(
            0, 0, page.getClientSize().width, page.getClientSize().height),
        format: PdfLayoutFormat(layoutType: PdfLayoutType.paginate))!;
// Draw the next paragraph/content.
    page.graphics.drawLine(
        PdfPen(PdfColor(255, 0, 0)),
        Offset(0, layoutResult.bounds.bottom + 10),
        Offset(page.getClientSize().width, layoutResult.bounds.bottom + 10));
    // document.pages.add().graphics.drawString(
    //     '$text', PdfStandardFont(PdfFontFamily.helvetica, 12),
    //     brush: PdfSolidBrush(PdfColor(0, 0, 0)),
    //     bounds: const Rect.fromLTWH(0, 0, 150, 20));
// Save the document.
    final dir = await getApplicationDocumentsDirectory();
    var now=DateTime.now();
    var dateTime=DateTime(now.year, now.month, now.day);
    bool directoryExists =
    await Directory("${dir.path}/Documents/Folders/Saved/").exists();
    if(!directoryExists){
      await Directory("${dir.path}/Documents/Folders/Saved/").create(recursive: true);

    }
    final myImagePath = "${dir.path}/Documents/Folders/Saved/${name.text}.pdf";
    File documentFile = File(myImagePath);

    var targetPath = dir.path + "/Documents/Folders/Saved/";
    var targetFileName = name.text;

    var generatedPdfFile = await FlutterHtmlToPdf.convertFromHtmlContent(
        deltaHtml, targetPath, targetFileName);

    print("kjnuihnu  ${generatedPdfFile.path}");
    Navigator.pop(context);

    Get.off(()=>SavedFilesPreview(),arguments:generatedPdfFile.path);
    // print(result);
// Dispose the document.
    document.dispose();
  }




   addWord()async{
    var jsonn = jsonEncode(cont.document.toDelta().toJson());
   // var text1= await extractTextFromPDF();
    List valueMap = json.decode(jsonn);
    var txt='';
    for(int i=0; i<valueMap.length;i++){
      txt=txt+valueMap[i]['insert'].toString();
    }
    print('txt is:$txt');
   // var text = valueMap[0]['insert'].toString();
    log(valueMap.toString());
    //log(text1.toString());
    final data = await rootBundle.load('assets/templateOCR.docx');
    final bytes = data.buffer.asUint8List();

    final docx = await DocxTemplate.fromBytes(bytes);

    Content content = Content();
    content
      ..add(TextContent("docname", "${txt}"));
    log(" content is : $content");


    final docGenerated = await docx.generate(content);

    final dir = await getApplicationDocumentsDirectory();
    final myImagePath = "${dir.path}/Documents/Folders/Saved/${name.text}.docx";
    File documentFile = File(myImagePath);
    if (!await documentFile.exists()) {
      documentFile.create(recursive: true);
    }
// Save the document.
    if (docGenerated != null) {
      var result= await documentFile.writeAsBytes(docGenerated);

   var a= await OpenFilex.open(result.path);
      Navigator.pop(context);
   Get.off(()=>FilesandFolders());
   //Get.to(()=>PdfCreatedPreview(),arguments: result.path);
      log(a.toString());
      log(" content is : $content");
    log(result.path);
    }
    //OpenFilex.open(result.path);
    //Get.to(()=>PdfCreatedPreview());

  }
 SaveToFolder(){
    Get.defaultDialog(
      title: "Select Folder",
          content: Column(
        children: [
          Container(
            height: 40.h,
            width: 70.w,
          )
      ],
    )
    );
 }
}
