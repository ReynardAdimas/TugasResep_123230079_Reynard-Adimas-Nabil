import 'package:hive/hive.dart';

part 'resep_hive.g.dart';

@HiveType(typeId: 0)
class ResepHive extends HiveObject{
  @HiveField(0)
  final String id; 

  @HiveField(1)
  final String name; 

  @HiveField(2)
  final String Image; 

  ResepHive({
    required this.id, 
    required this.name, 
    required this.Image
  });
}