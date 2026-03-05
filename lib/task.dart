import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';

part 'task.g.dart';

@HiveType(typeId: 1)
class Task extends HiveObject {

  @HiveField(0)
  String? name;
   @HiveField(1)
  String? content;
   @HiveField(2) 
  int? number ;

  Task({
    required this.name,
    required this.content,
    required this.number,
  });
}
