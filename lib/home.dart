import 'package:flutter/material.dart';
import 'package:metsaf1/data.dart';
import 'package:photo_view/photo_view.dart';
import 'package:metsaf1/image_viewer.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final ScrollController _controller = ScrollController();
  final double _height = 500;
  final String appBarTitle = 'Home';

  void _animateToIndex(int index) {
    _controller.jumpTo((index.toDouble() * _height));
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
      body: ListView.builder(
        controller: _controller,
        itemCount: 20,
        itemBuilder: (_, i) {
          return Card(
            elevation: 0.0,
            child: InkWell(
              onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ImageViewer(imagePath: 'assets/${indexList[i]}.jpg'),
              ),
            );
          },
          child: Image(
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
              image: AssetImage('assets/${indexList[i]}.jpg')),));
        },
      ),
    );
  }

  Widget navigationDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey[200],
      child: SingleChildScrollView(
          child: Column(children: [
        TopWidget(context),
        BottomWidget(context),
        otherNavigatorList('Favorite', Icons.favorite),
        otherNavigatorList('About', Icons.info),
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
          shrinkWrap: true,
          itemCount: gospelName.length,
          itemBuilder: ((context, index) {
            return gospel(gospelName[index], context, index);
          }),
        ),
      ),
    );
  }

  Widget gospel(String gospel, BuildContext context, int index) {
    return ListTile(
      leading: Icon(Icons.book),
      tileColor: Colors.grey[200],
      onTap: (() async {
        Navigator.of(context).pop();
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              //   actionsAlignment: MainAxisAlignment.spaceBetween,
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
                              //backgroundColor: Colors.grey[200]
                          ),
                          onPressed: () {
                            // print(offSet[index] + index1);
                            print(chapterAndPage[offSet[index] + index1 + 1]);

                            Navigator.of(context).pop();
                            _animateToIndex(
                                chapterAndPage[offSet[index] + index1 + 1]!);
                          },
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                elevation: 0.0,
                                //backgroundColor: Colors.grey[200],
                                fixedSize: Size(
                                    MediaQuery.of(context).size.width * 5,
                                    MediaQuery.of(context).size.height * 0.05)),
                            onPressed: () {},
                            child: Text(
                              'Chapter ${index1 + 1}',
                              style: const TextStyle(color: Colors.black),
                            ),
                          ));
                    }),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  child: const Text("Cancel",
                      style: TextStyle(color: Colors.black)),
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

  Widget otherNavigatorList(String title, IconData icon) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      tileColor: Colors.grey[200],
    );
  }
}
