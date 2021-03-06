import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:trab/db/imagesController.dart';

class NewImage extends StatefulWidget{
  //const NewImage({Key? key}) : super(key: key);
  //late final Uint8List bytes;
  late Uint8List bytes;
  Image? _imgItem;
  NewImage(Uint8List b){
    this.bytes=b;
    this._imgItem = Image.memory(this.bytes);
  }

  @override
  _NewImageState createState() => _NewImageState();
}

class _NewImageState extends State<NewImage>{
  

  bool? _serviceEnabled;
  PermissionStatus? _permissionGranted;
  LocationData? _local;
  //StreamSubscription? _sub;
  TextEditingController titleC = TextEditingController();
  TextEditingController titleD = TextEditingController();

  ImagesController _imagesController = new ImagesController();

  @override
  void initState(){
    super.initState();
    print("SS_SHOW");
    _locationData();
  }

  void _locationData() async {

    Location location = new Location();

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled!) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled!) {
        print("LOCATION FAILED TO ENABLE!");
      }
    }

    print("Getting location");
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted == PermissionStatus.granted) {
        _local = await location.getLocation();
        print("SS_Local definido");
      }
    }else{
      if(_permissionGranted != PermissionStatus.deniedForever){
        _local = await location.getLocation();
        print("SS_Local definido");
      }
    }

    /* this._sub = Location.instance.onLocationChanged.listen((event) {
      setState(() {
        this._local = event;
        print("SS_LOCAL NOVO");
      });
    }); */
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => {
            showDialog(context: context, builder: (ctx) {
              return AlertDialog(
                title: Text("Adicionar imagem."),
                content: Text("Retornar?"),
                actions: [
                  ElevatedButton(onPressed: (){
                    Navigator.pop(ctx);
                    Navigator.pop(context);
                  }, child: Text("Sim")),
                  ElevatedButton(onPressed: (){
                    Navigator.pop(ctx);
                  }, child: Text("N??o")),
                ],
              );
            },)
          },
        ),
        title: Text("Nova imagem"),
      ),
      body: Container(child: ListView(children: [
          widget._imgItem == null? Text("No image!"):Container(
            child: widget._imgItem!,
            margin: EdgeInsets.all(15),
          ),
          Container(
            child: TextField(
                decoration: InputDecoration(
                  alignLabelWithHint: true,
                  hintText: "T??tulo"
                  ),
                controller: titleC,
              ),
            margin: EdgeInsets.all(15),
          ),
          Container(
            child: TextField(
                decoration: InputDecoration(
                  alignLabelWithHint: true,
                  hintText: "Descri????o"
                  ),
                controller: titleD,
              ),
            margin: EdgeInsets.all(15)
          ),
      ],),
      margin: EdgeInsets.fromLTRB(0,0,0,80),),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        heroTag: null,
        onPressed: () async {
          String d = DateTime.now().toString();
          await _imagesController.insert(titleC.text, titleD.text, d, this._local == null ? 0.0 : this._local!.latitude!, this._local == null ? 0.0 : this._local!.longitude! , base64.encode(widget.bytes));
          Navigator.pop(context,true);
        },
        child: Icon(Icons.save),
      ),
    );
  }
}