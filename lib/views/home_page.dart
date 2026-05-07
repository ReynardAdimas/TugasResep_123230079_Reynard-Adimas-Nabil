import 'package:flutter/material.dart';
import 'package:tugas_resep/api/api_service.dart';
import 'package:tugas_resep/models/resep.dart';
import 'package:tugas_resep/service/auth_service.dart';
import 'package:tugas_resep/views/details_page.dart';
import 'package:tugas_resep/views/login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> _categories = [
    'Beef', 'Chicken', 'Seafood', 'Dessert', 'Vegetarian', 'Pasta'
  ]; 
  String _selectedCategory = 'Beef'; 
  late Future<List<Resep>> _resepFuture;

  @override
  void initState() {
    super.initState();
    _resepFuture = ApiService.getResep(_selectedCategory);
  }

  void onCategoryChanged(String category) {
    setState(() {
      _selectedCategory = category; 
      _resepFuture = ApiService.getResep(category);
    });
  }

  Future<void> _logout() async {
    await AuthService.logout(); 
    if(!mounted) return; 
    Navigator.pushReplacement(
      context, 
      MaterialPageRoute(builder: (context) => LoginPage())
    );
  } 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 252, 224, 140),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 245, 161, 6),
        title: const Text('Resep Makanan'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _logout, 
            icon: const Icon(Icons.logout)
          )
        ],
      ),
      body: Column(
        children: [
          _buildCategoryFilter(), 
          Expanded(child: _buildGrid()),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: 12, 
          vertical: 8
        ),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index]; 
          final isSelected = category ==_selectedCategory; 
          return GestureDetector(
            onTap: () => onCategoryChanged(category),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: isSelected 
                      ? const Color.fromARGB(255, 245, 161, 6) 
                      : Colors.white, 
                borderRadius: BorderRadius.circular(20), 
                border: Border.all(
                  color: const Color.fromARGB(255, 245, 161, 6),
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                category, 
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black87, 
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
          );
        }
      ),
    );
  }

  Widget _buildGrid() {
    return FutureBuilder<List<Resep>>(
      future: _resepFuture,
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Colors.white,),);
        }
        if(snapshot.hasError) {
          return Center(child: Text('Error'),);
        }
        if(!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Tidak ada resep'),);
        }

        final resepList = snapshot.data!; 

        return GridView.builder(
          padding: const EdgeInsets.all(12),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, 
            crossAxisSpacing: 12, 
            mainAxisSpacing: 12, 
            childAspectRatio: 0.85
          ),
          itemCount: resepList.length, 
          itemBuilder: (context, index) {
            return _buiilCard(resepList[index]);
          }
        );
      }
    );
  }

  Widget _buiilCard(Resep resep) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context, 
          MaterialPageRoute(
            builder: (_) => DetailsPage(nama: resep.name, id: resep.id,)
          )
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12), 
          boxShadow: [
            BoxShadow(
            color: Colors.black.withValues(alpha: 0.08), 
            blurRadius: 6, 
            offset: const Offset(0, 3)
          )
        ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: Image.network(
                resep.image, 
                height: 130,
                width: double.infinity,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, progress) {
                  if(progress==null) return child;
                  return const SizedBox(
                    height: 130,
                    child: Center(child: CircularProgressIndicator(color: Colors.white,),),
                  );
                },
                errorBuilder: (_, __, ___) => const SizedBox(
                  height: 130,
                  child: Icon(Icons.broken_image, size: 40,),
                )
              ),
            ), 
            Padding(
              padding: const EdgeInsets.all(8), 
              child: Text(
                resep.name, 
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w600, 
                  fontSize: 13
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}