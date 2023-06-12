import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:metsaf1/About_us.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:metsaf1/data.dart';

class PdfViewerPage extends StatefulWidget {
  //final int pageNumber;

  //PdfViewerPage({required this.pageNumber});

  @override
  _PdfViewerPageState createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  String? _pdfPath;
  PDFViewController? _pdfViewController;

  final ScrollController _controller = ScrollController();
  final double _height = 500;
  final String appBarTitle = 'ሕያው ቃል መጽሐፍ ቅዱስ';

  void _animateToIndex(PDFViewController? pdfViewController, int index) {
    if (pdfViewController != null) {
      _pdfViewController!.setPage(index-1);
    }
  }

  @override
  void initState() {
    super.initState();
    _loadPdf();
  }

  Future<void> _loadPdf() async {
    final ByteData bytes = await rootBundle.load('assets/pdf/new.pdf');
    final Directory tempDir = await getTemporaryDirectory();
    final File tempFile = File('${tempDir.path}/new.pdf');
    await tempFile.writeAsBytes(bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));

    setState(() {
      _pdfPath = tempFile.path;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      drawer: navigationDrawer(context),
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: (() {}),
            icon: Icon(Icons.more_vert),
          )
        ],
        backgroundColor: Colors.black,
        title: Text(
          appBarTitle,
          style: const TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
      body: _pdfPath != null
          ? PDFView(
        filePath: _pdfPath!,
        onViewCreated: (PDFViewController pdfViewController) {
          _pdfViewController = pdfViewController;
          _pdfViewController!.setPage(0);
        },
        onRender: (_pages) {
          setState(() {
          });
        },
        onPageChanged: (int? page, int? total) {
          setState(() {});
        },
      )
          : Center(child: CircularProgressIndicator()),
    );
  }

  Widget navigationDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey[200],
      child: SingleChildScrollView(
          child: Column(children: [
            TopWidget(context),
            BottomWidget(context),
            otherNavigatorList('About', Icons.info, context),
          ])),
    );
  }

  Widget TopWidget(BuildContext context) {
    return Container(
      alignment: Alignment.bottomRight,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      height: MediaQuery.of(context).size.height * 0.2,
      width: double.infinity,
      decoration: const BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover, image: AssetImage('assets/top.jpg'))),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(begin: Alignment.bottomRight, stops: const [
            0.2,
            0.9
          ], colors: [
            Colors.black, //black.withOpacity(0.8),
            Colors.black.withOpacity(0.1)
          ]),
          borderRadius: const BorderRadius.all(
            Radius.circular(30),
          ),
        ),
        child: const Text(
          'ሕያው ቃል',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }

  Widget BottomWidget(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(right: 70),
      reverse: true,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey[200],
            border: const Border(
                bottom: BorderSide(color: Colors.grey, width: 0.5))),
        height: MediaQuery.of(context).size.height * 0.5,
        width: double.maxFinite,
        child: ListView.builder(
          controller: _controller,
          shrinkWrap: true,
          itemCount: gospelName.length,
          itemBuilder: ((context, index) {
            return gospel(
                gospelName[index], context, index, chapterAndPage[offSet[index] + 1]!);
          }),
        ),
      ),
    );
  }

  Widget gospel(String gospel, BuildContext context, int index, int page) {
    return ListTile(
      leading: Icon(Icons.book),
      tileColor: Colors.grey[200],
      onTap: (() async {
        Navigator.of(context).pop();
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text(
                "Choose the Chapter",
                style: TextStyle(color: Colors.black, fontSize: 17),
              ),
              content: Container(
                height: 200,
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(15)),
                child: Container(
                  height: double.maxFinite,
                  width: double.maxFinite,
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: chapterNumberValue[index],
                    itemBuilder: ((context, index1) {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0.0,
                        ),
                        onPressed: () {
                          print(chapterAndPage[offSet[index] + index1 + 1]);
                          Navigator.of(context).pop();
                          _animateToIndex(_pdfViewController,chapterAndPage[offSet[index] + index1 + 1]!);
                        },
                        child: Text(
                          'Chapter ${index1 + 1}',
                          style: const TextStyle(color: Colors.black),
                        ),
                      );
                    }),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }),
      title: Text(
        gospel,
        style: const TextStyle(
            color: Colors.black, fontSize: 16, fontWeight: FontWeight.w400),
      ),
    );
  }

  Widget otherNavigatorList(String title, IconData icon, BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      tileColor: Colors.grey[200],
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AboutUs(),
          ),
        );
      },
    );
  }

}
