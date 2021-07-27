import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:trab/db/db.dart';
import 'package:trab/db/imagesController.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trab/screens/newImage.dart';

import 'viewImage.dart';

class Home extends StatefulWidget {
    Home({Key? key, required this.title}) : super(key: key);
    final String title;
    @override
    _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
    ImagesController _imagesController = new ImagesController();
    bool _isLoading = true;

    @override
    void initState() {
        super.initState();
        AppDatabase().openDb().whenComplete(loaded);
    }

    Future<void> loaded() async {
      return await _imagesController.queryAll().whenComplete(() {
          setState(() {
              _isLoading = false;
          });
      });
    }

    final imageCanceled = SnackBar(
      content: Text('Imagem não criada!'),
      duration: Duration(seconds:2),
    );

    _newImage(XFile? image) async {
      if(image != null){
        final Uint8List bytes = await image.readAsBytes();
        //Uint8List bytes = await FlutterImageCompress.compressWithList(bytes2,quality: 100,rotate: 0);
        //final img2 = await FlutterExifRotation.rotateImage(path: image!.path);
        //Uint8List bytes = await img2.readAsBytes();

        final val = await Navigator.push(context, 
        MaterialPageRoute(builder: (BuildContext c){
          return new NewImage(bytes);
        }));
        if(val) loaded();
      }else{
        ScaffoldMessenger.of(context).showSnackBar(imageCanceled);
      }
    }

    @override
    Widget build(BuildContext context) {
        ImagePicker picker = ImagePicker();
        return !_isLoading ? Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            appBar: AppBar(
                centerTitle: true,
                title: Text("Galeria de fotos"),
            ),
            body: Center(
                // Center is a layout widget. It takes a single child and positions it
                // in the middle of the parent.
                child: _imagesController.images.length == 0 ? Text("Não tem imagens :3") : _getPhotoList()
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton(
                    heroTag: null,
                    onPressed: () async {
                        final XFile? image = await picker.pickImage(source: ImageSource.camera,preferredCameraDevice: CameraDevice.rear);
                        await _newImage(image);
                    },
                    tooltip: 'Tirar foto',
                    child: Icon(Icons.camera,size: 30,),
                ),
                FloatingActionButton(
                    heroTag: null,
                    onPressed: () async {
                        final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                        await _newImage(image);
                    },
                    tooltip: 'Pegar na galeria',
                    child: Icon(Icons.photo_library_outlined,size: 30,),
                )
              ],
            ), // This trailing comma makes auto-formatting nicer for build methods.
        ) : Center(child: CircularProgressIndicator());
    }




    _getPhotoList(){
        return ListView.builder(itemBuilder: (context, index) {
          return _imageCard(index);
        },
        itemCount: _imagesController.images.length,);
    }

    _imageCard(int i){
      DateTime d = DateTime.parse(_imagesController.images[i].data!);
      return Container(
          child: Card(
              child: InkWell(
                  onTap: () async {
                      final val = await Navigator.push(context, 
                      MaterialPageRoute(builder: (BuildContext c) {
                        return new ViewImage(_imagesController.images[i].id!); 
                      }));
                      if(val != null && val == true) loaded();
                  },
                  child: Ink(
                      child: Row(
                          children: [
                              Expanded(
                                  child: Column(
                                      children: [
                                          Text(_imagesController.images[i].titulo!),
                                          Text("${d.day}/${d.month}/${d.year} ${d.hour > 12 ? d.hour - 12 : d.hour} : ${d.minute} ${d.hour > 12 ? 'PM' : 'AM'}"),
                                          Text(_imagesController.images[i].lat!.toString()),
                                          Text(_imagesController.images[i].long!.toString())
                                      ],
                                  ),
                              ),
                              Expanded(
                                  child: Container(
                                      child: Image.memory(base64.decode(_imagesController.images[i].img!)),
                                      //Image(image: NetworkImage("https://i.pinimg.com/originals/41/71/b1/4171b1b35e0c25ed4871c1109372ea4c.gif"),),
                                      margin: EdgeInsets.all(15),
                                  ),
                              )
                          ],
                      ),
                  ),
              ),
              elevation: 3,
              shadowColor: Colors.black54,
              borderOnForeground: true,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
          ),
          margin: EdgeInsets.fromLTRB(15, 25, 15, 25),
          );
          
    }
}
