import 'appImage.dart';
import 'db.dart';

class AppImageRepository {
  Future<List<AppImage>> selectAll() async {
    List<AppImage> appImages = [];
    await AppDatabase().db!.rawQuery('select * from appImages').then((value) {
      value.forEach((element) {
        appImages.add(AppImage.fromMap(element));
      });
    });
    return appImages;
  }

  Future<List<AppImage>> selectById(int index) async {
    List<AppImage> appImages = [];
    await AppDatabase().db!.rawQuery('select * from appImages where id=$index').then((value) {
      value.forEach((element) {
        appImages.add(AppImage.fromMap(element));
      });
    });
    return appImages;
  }

  Future<void> insert(AppImage appImage) async {
    await AppDatabase()
        .db!
        .rawInsert('insert into appImages (title,comment,data,lat,long,img) values (?,?,?,?,?,?);', 
        [appImage.titulo,appImage.comment,appImage.data,appImage.lat,appImage.long,appImage.img]);
    return;
  }

  Future<void> delete(AppImage appImage) async {
    await AppDatabase()
        .db!
        .rawDelete('delete from appImages where id = ?;', [appImage.id]);
    return;
  }
}
