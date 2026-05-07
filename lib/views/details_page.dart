import 'package:flutter/material.dart'; 
import 'package:tugas_resep/api/api_service.dart';
import 'package:tugas_resep/models/resep.dart'; 
import 'package:tugas_resep/models/resep_detail.dart';
import 'package:tugas_resep/models/resep_hive.dart';
import 'package:tugas_resep/service/favorite_service.dart'; 

class DetailsPage extends StatefulWidget {
  final String nama;
  final String id;
  const DetailsPage({super.key, required this.nama, required this.id});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  late Future<ResepDetail?> _detailFuture; 
  bool _isFavorite = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _detailFuture = ApiService.getResepDetail(widget.nama);
    _checkFavorite();
  } 

  void _checkFavorite() {
    setState(() {
      _isFavorite = FavoriteService.isfavorite(widget.id);
    });
  }

  Future<void> _toggleFavorite(ResepDetail resep) async {
    if(_isFavorite) {
        await FavoriteService.removeFavorite(resep.id);
    } else {
        await FavoriteService.addFavorite(ResepHive(
            id: resep.id, 
            name: resep.name, 
            Image: resep.image
        ));
    }
    setState(() {
      _isFavorite = !_isFavorite;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 252, 224, 140),
        body: FutureBuilder<ResepDetail?>(
            future: _detailFuture,
            builder: (context, snapshot) {
                if(snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator(color: Colors.white,),);
                }
                if(snapshot.hasError) {
                    return Center(child: Text('Error'),);
                } 
                if(!snapshot.hasData || snapshot.data == null) {
                    return const Center(child: Text('Resep tidak ditemukan'),);
                } 
                ResepDetail resep = snapshot.data!;
                return CustomScrollView(
                    slivers: [
                        SliverAppBar(
                            expandedHeight: 280,
                            pinned: true,
                            backgroundColor: Color.fromARGB(255, 245, 161, 6),
                            flexibleSpace: FlexibleSpaceBar(
                                background: Image.network(
                                    resep.image,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 60,),      
                                ),
                            ),
                        ), 

                        SliverToBoxAdapter(
                            child: Container(
                                decoration: const BoxDecoration(
                                    color: Color.fromARGB(255, 252, 224, 140),
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(24)
                                    ), 
                                ),
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                        Text(
                                            resep.name, 
                                            style: const TextStyle(
                                                fontSize: 22, 
                                                fontWeight: FontWeight.bold
                                            ),
                                        ),
                                        const SizedBox(height: 8,),
                                        Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                                children: [
                                                    _buildBadge(Icons.category, resep.category), 
                                                    const SizedBox(width: 8,), 
                                                    _buildBadge(Icons.location_on, resep.area),
                                                ],
                                            ),
                                            const SizedBox(height: 12,), 
                                            LayoutBuilder(
                                                builder: (context, contraints) {
                                                    return SizedBox( 
                                                        width: contraints.maxWidth,
                                                        child: 
                                                    ElevatedButton.icon(
                                                            onPressed: () => _toggleFavorite(resep), 
                                                            icon: Icon(
                                                                _isFavorite ? Icons.favorite : Icons.favorite_border,
                                                                color: Colors.white,
                                                            ),
                                                            label: Text(
                                                                _isFavorite ? 'Hapus dari favorit' : 'Tambah ke favorit', 
                                                                style: TextStyle(color: Colors.white, fontSize: 16),
                                                            ),
                                                            style: ElevatedButton.styleFrom(
                                                                backgroundColor: _isFavorite ? Colors.red : Colors.green, 
                                                                padding: const EdgeInsets.symmetric(vertical: 14), 
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius: BorderRadiusGeometry.circular(12)
                                                                )
                                                            ),
                                                        ),
                                                    );
                                                }
                                            )
                                          ],
                                        ),
                                        const SizedBox(height: 20,), 

                                        Text(
                                            'Bahan-Bahan', 
                                            style: const TextStyle(
                                                fontSize: 18, 
                                                fontWeight: FontWeight.bold
                                            ),
                                        ),
                                        const SizedBox(height: 10,), 
                                        _buildIngredient(resep.ingredients),
                                        const SizedBox(height: 20,),
                                        Text(
                                            'Cara memasak', 
                                            style: const TextStyle(
                                                fontSize: 18, 
                                                fontWeight: FontWeight.bold
                                            ),
                                        ),
                                        const SizedBox(height: 10,), 
                                        _buildIntruction(resep.instruction), 
                                        const SizedBox(height: 30,)
                                    ],
                                ),
                            ),
                        )
                    ],
                );
            },
        ),
    );
  }

  Widget _buildBadge(IconData icon, String label) {
    return Container(
        padding: const EdgeInsets.symmetric(
            horizontal: 10, 
            vertical: 4
        ),
        decoration: BoxDecoration(
            color: const Color.fromARGB(255, 245, 161, 6), 
            borderRadius: BorderRadius.circular(20)
        ),
        child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
                Icon(icon, size: 14, color: Colors.white,), 
                const SizedBox(width: 4,), 
                Text(
                    label, 
                    style: TextStyle(
                        color: Colors.white, 
                        fontSize: 12,
                        fontWeight: FontWeight.w600
                    )
                )
            ],
        ),
    );
  }

  Widget _buildIngredient(List<Map<String, String>> ingredients) {
    return Container(
        decoration: BoxDecoration(
            color: Colors.white, 
            borderRadius: BorderRadius.circular(12)
        ),
        child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: ingredients.length,
            separatorBuilder: (_, __) => const Divider(height: 1,), 
            itemBuilder: (context, index) {
                final item = ingredients[index];
                return Padding(
                    padding: const EdgeInsetsGeometry.symmetric(
                        horizontal: 15, 
                        vertical: 10
                    ), 
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                            Row(
                                children: [
                                    const Icon(Icons.fiber_manual_record, size: 8,),
                                    const SizedBox(width: 8,), 
                                    Text(
                                        item['ingredient']!,
                                        style: TextStyle(
                                            fontSize: 14
                                        ),
                                    ),
                                ],
                            ), 
                            Text(
                                item['measure']!, 
                                style: TextStyle(
                                    fontSize: 14, 
                                    color: Colors.grey, 
                                    fontWeight: FontWeight.w500
                                ),
                            )
                        ],
                    ),
                );
            }, 
        ),
    );
  }


  Widget _buildIntruction(String instruction) {
    final steps = instruction.split(RegExp(r'\r?\n+')).where((s) => s.trim().isNotEmpty).toList(); 
    return Column(
        children: List.generate(steps.length,(index) {
            return Padding(
                padding: const EdgeInsets.only(bottom: 12), 
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Container(
                            width: 28,
                            height: 28,
                            margin: const EdgeInsets.only(right: 10, top: 2),
                            decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 245, 161, 6),
                                shape: BoxShape.circle
                            ),
                            alignment: Alignment.center,
                            child: Text(
                                '${index+1}', 
                                style: TextStyle(
                                    color: Colors.white, 
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12
                                ),
                            ),
                        ),

                        Expanded(
                            child: Text(
                                steps[index].trim(), 
                                style: const TextStyle(fontSize: 12, height: 1.5),
                            ),
                        )
                    ],
                ),
            );
        }),
    );
  }
}