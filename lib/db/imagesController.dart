import 'package:trab/db/appImage.dart';
import 'package:trab/db/appImageRepository.dart';

class ImagesController {
  List<AppImage> images = [];

  AppImageRepository repository = AppImageRepository();

  //TextEditingController nomeController = TextEditingController();

  Future<void> queryAll() async {
    return await repository.selectAll().then((value) {
      images = value;
    });
  }

  Future<void> queryID(int index) async {
    return await repository.selectById(index).then((value) {
      images = value;
    });
  }

  Future<void> insert(titulo,comment,data,lat,long,img) async {
    AppImage pessoa = AppImage(titulo,comment,data,lat,long,img);
    return await repository.insert(pessoa).then((value) {
      //nomeController.clear();
    });
  }

  Future<void> delete(int index) async {
    await repository.delete(images[index]).whenComplete(() {
      images.removeAt(index);
    });
  }
  
}
