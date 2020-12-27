import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

final String table = 'fun_heart_eating';
final String columnId = 'time';
final String columnClass = 'fruit_class';
final String columnName = 'fruit_name';
final String columnArea = 'area';
final String columnRate='rate';


class FunHeart {
  String time;
  String fruitClass;
  String name;
  String area;
  double rate;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      columnId: time,
      columnClass: fruitClass,
      columnName: name,
      columnArea: area,
      columnRate:rate
    };
  }

  FunHeart(String t, String f, String n, String a,double r) {
    time = t;
    fruitClass = f;
    name = n;
    area = a;
    rate=r;
  }

  FunHeart.fromMap(Map<String, dynamic> map) {
    time = map[columnId];
    fruitClass = map[columnClass];
    name = map[columnName];
    area = map[columnArea];
    rate=map[columnRate];
  }
  String output(){
    return "-------\ntime\t${time}\nclass\t${fruitClass}\nname\t${name}\narea\t${area}\nrate\t${rate}\n-------";
  }
}

class FunHeartProvider {
  Database db;

  Future open() async {
    print(await getDatabasesPath());
    db = await openDatabase(join(await getDatabasesPath(), "funHeart.db"),
        version: 1, onCreate: (Database db, int version) async {
      await db.execute('''
        create table $table ( 
         $columnId text primary key , 
        $columnClass text not null,
        $columnName text,
        $columnArea text not null,
        $columnRate num not null)
        ''');
    });
  }

  Future<FunHeart> insert(FunHeart funHeart) async {
    print(funHeart.output());
    await db.insert(table, funHeart.toMap());
    return funHeart;
  }

  Future<List<Map>> getFunHeart() async {
    List<Map> maps = await db
        .query(table, columns: [columnId, columnClass, columnName, columnArea,columnRate]);
    if (maps.length > 0) {
      return maps;
    }
    return null;
  }

  Future close() async => db.close();
}
