import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trab/db/imagesController.dart';

class ViewImage extends StatefulWidget{

  late final int _i;
  ViewImage(int indx){
    this._i=indx;
  }

  @override
  _ViewImage createState() => _ViewImage(this._i);

}

class _ViewImage extends State<ViewImage>{
  late int _i;
  bool _isLoading=true;
  ImagesController _imagesController = new ImagesController();
  
  _ViewImage(int ind){
    this._i=ind;
  }

  @override
    void initState() {
      super.initState();
      loadID(this._i);
    }
  

  Future<void> loadID(int i) async {
      return await _imagesController.queryID(i).whenComplete(() {
          setState(() {
              _isLoading = false;
              print("loaded");
          });
      });
    }
  
  @override
  Widget build(BuildContext context) {
    return _imagesController.images.length > 0 ? Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => {
            Navigator.pop(context)
          },
        ),
        title: Text(_imagesController.images[0].titulo!),
      ),
      body: !_isLoading ? Column(
        children: [
          Container(
            child: Text(_imagesController.images[0].comment!),
            alignment: Alignment.center,
            margin: EdgeInsets.all(15)
          ),
          Image.memory(base64.decode(_imagesController.images[0].img!)),
        ],
      ) : Center(child: CircularProgressIndicator()),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        heroTag: null,
        onPressed: (){
          showDialog(context: context, builder: (ctx) {
            return AlertDialog(
              title: Text("Deletando Imagem"),
              content: Text("Realmente deletar?"),
              actions: [
                ElevatedButton(onPressed: () {
                  _imagesController.delete(0).then((value) {
                    Navigator.pop(ctx);
                    Navigator.pop(context);
                  });
                }, child: Text("Sim")),
                ElevatedButton(onPressed: () {
                  Navigator.pop(ctx);
                }, child: Text("Não")),
              ],
            );
          });
        },
        child: Icon(Icons.delete),
      ),
    ) : Text("Image deleted");
  }
}