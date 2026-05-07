import 'package:flutter/material.dart';
import 'package:tugas_resep/models/resep_hive.dart';
import 'package:tugas_resep/service/favorite_service.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tugas_resep/views/details_page.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E0),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 245, 161, 6),
        title: const Text('Favorit Saya'),
        centerTitle: true,
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<ResepHive>('favorites').listenable(), 
        builder: (context, Box<ResepHive> box, _) {
          final favorites = box.values.toList();

          if(favorites.isEmpty) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.favorite_border, size: 64,color: Colors.grey,), 
                  SizedBox(height: 12,),
                  Text('Belum ada resep favorit', style: TextStyle(color: Colors.grey),)
                ],
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, 
              crossAxisSpacing: 12, 
              mainAxisSpacing: 12, 
              childAspectRatio: 0.85
            ), 
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              return _buiilCard(context, favorites[index]);
            }
          );
        }
      ),
    );
  }

  Widget _buiilCard(BuildContext context, ResepHive resep) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context, 
        MaterialPageRoute(builder: (_) => DetailsPage(nama: resep.name, id: resep.id))
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08), 
                  blurRadius: 6,
                  offset: const Offset(0, 3)
                )
              ]
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadiusGeometry.vertical(
                    top: Radius.circular(12)
                  ),
                  child: Image.network(
                    resep.Image,
                    height: 130,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ), 
                Padding(
                  padding: const EdgeInsets.all(8), 
                  child: Text(
                    resep.name, 
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w600, 
                      fontSize: 13
                    ),
                  ),
                )
              ],
            ),
          ), 
          Positioned(
            top: 6,
            right: 6,
            child: GestureDetector(
              onTap: () => FavoriteService.removeFavorite(resep.id),
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle
                ),
                child: const Icon(Icons.close, size: 14, color: Colors.white,),
              ),
            )
          )
        ],
      ),
    );
  }
}