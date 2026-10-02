import 'package:flutter/material.dart';
import 'services/dog_api_service.dart';

void main() {
  runApp(const PetCareApp());
}



class Pet {
  String name;
  String type;
  int age;
  String image;
  String careNote;

  Pet({
    required this.name,
    required this.type,
    required this.age,
    required this.image,
    required this.careNote,
  });
}

class PetCareApp extends StatelessWidget {
  const PetCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ang Campus Pet Care ni Alaniel',

      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: const Color(0xFFF5F8F7),

        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 0, 0, 0),
          foregroundColor: Colors.white,
          centerTitle: true,
        ),

        cardTheme: CardThemeData(
          elevation: 3,
          margin: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
        ),

        textTheme: const TextTheme(
          titleLarge: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      home: const PetHomePage(),
    );
  }
}


class PetHomePage extends StatefulWidget {
  const PetHomePage({super.key});

  @override
  State<PetHomePage> createState() => _PetHomePageState();
}

class _PetHomePageState extends State<PetHomePage> {

  final DogApiService dogApiService = DogApiService();
  late Future<List<String>> dogImages;

  final List<Pet> pets = [
    Pet(
      name: 'Harvey',
      type: 'Dog',
      age: 3,
      image: 'assets/images/dog.jpeg',
      careNote: 'Give Harvey regular exercise, clean water, and healthy food.',
    ),

    Pet(
      name: 'Kier',
      type: 'Cat',
      age: 2,
      image: 'assets/images/cat.jpeg',
      careNote: 'Keep Kier indoors and provide a clean litter box.',
    ),

    Pet(
      name: 'Jiani',
      type: 'Rabbit',
      age: 1,
      image: 'assets/images/rabbit.jpeg',
      careNote: 'Jiani needs fresh vegetables, hay, and a clean cage.',
    ),

    Pet(
      name: 'Clarky',
      type: 'Bird',
      age: 2,
      image: 'assets/images/bird.jpg',
      careNote: "Keep Clarky's cage clean and provide fresh drinking water.",
    ),

    Pet(
      name: 'Realmy',
      type: 'Fish',
      age: 1,
      image: 'assets/images/fish.jpeg',
      careNote: 'Change the aquarium water regularly and feed Realmy properly.',
    ),

    Pet(
      name: 'Aljony',
      type: 'Hamster',
      age: 1,
      image: 'assets/images/hamster.jpeg',
      careNote: 'Aljony needs clean bedding, food, water, and a safe cage.',
    ),
  ];

  

  int favoritePet = -1;

 

  @override
  void initState() {
    super.initState();
    dogImages = dogApiService.fetchDogImages();
  }

  void refreshDogImages() {
    setState(() {
      dogImages = dogApiService.fetchDogImages();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

  

      appBar: AppBar(
        title: const Text(
          'Pet Care Directory',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        leading: const Icon(
          Icons.pets,
        ),
      ),


      body: Column(
        children: [

          // Custom Header Widget
          const PetHeader(),

      
          Expanded(
            child: ListView.builder(
              itemCount: pets.length,

              itemBuilder: (context, index) {

                return PetCard(
                  pet: pets[index],

                  isFavorite: favoritePet == index,
                  onDeletePressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (dialogContext) => AlertDialog(
                        title: const Text('Delete Pet'),
                        content: Text('Are you sure you want to delete ${pets[index].name}?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(dialogContext, false),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(dialogContext, true),
                            child: const Text('Delete'),
                          ),
                        ],
                      ),
                    );

                    if (confirm == true && mounted) {
                      setState(() {
                        pets.removeAt(index);
                        if (favoritePet == index) {
                          favoritePet = -1;
                        } else if (favoritePet > index) {
                          favoritePet--;
                        }
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Pet deleted successfully')),
                      );
                    }
                  },

                  onFavoritePressed: () {
                    setState(() {

                      if (favoritePet == index) {
                        favoritePet = -1;
                      } else {
                        favoritePet = index;
                      }

                    });
                  },
                );
              },
            ),
          ),

          // Custom Care Tips Widget
          const CareTips(),
        ],
      ),
    );
  }
}


class PetHeader extends StatelessWidget {
  const PetHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      margin: const EdgeInsets.all(12),

      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.teal.shade50,

        borderRadius: BorderRadius.circular(15),

        border: Border.all(
          color: const Color.fromARGB(255, 0, 0, 0),
        ),
      ),

      child: Row(
        children: [

          // Icon
          Container(
            padding: const EdgeInsets.all(12),

            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 0, 0, 0),
              borderRadius: BorderRadius.circular(50),
            ),

            child: const Icon(
              Icons.pets,
              color: Colors.white,
              size: 30,
            ),
          ),

          const SizedBox(width: 15),

          // Expanded
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                Text(
                  'Campus Pet Care',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 5),

               
              ],
            ),
          ),
        ],
      ),
    );
  }
}



class PetCard extends StatelessWidget {

  final Pet pet;
  final bool isFavorite;
  final VoidCallback onFavoritePressed;
  final VoidCallback onDeletePressed;

  const PetCard({
    super.key,
    required this.pet,
    required this.isFavorite,
    required this.onFavoritePressed,
    required this.onDeletePressed,
  });

  @override
  Widget build(BuildContext context) {

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),

        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

         

            ClipRRect(
              borderRadius: BorderRadius.circular(12),

              child: Image.asset(
                pet.image,

                width: 100,
                height: 100,

                fit: BoxFit.cover,

              
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 100,
                    height: 100,
                    color: Colors.grey.shade300,

                    child: const Icon(
                      Icons.pets,
                      size: 50,
                      color: Colors.grey,
                    ),
                  );
                },
              ),
            ),

            const SizedBox(width: 12),

         
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

                  // Pet name
                  Row(
                    children: [

                      Expanded(
                        child: Text(
                          pet.name,

                          style: const TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      // Favorite icon
                      IconButton(
                        tooltip: 'Add to favorites',
                        onPressed: onFavoritePressed,
                        icon: Icon(
                          isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,

                          color: isFavorite
                              ? Colors.red
                              : Colors.grey,
                        ),
                      ),
                      IconButton(
                        tooltip: 'Delete pet',
                        onPressed: onDeletePressed,
                        icon: const Icon(Icons.delete, color: Colors.red),
                      ),
                    ],
                  ),

                  // Type
                  Row(
                    children: [

                      const Icon(
                        Icons.category,
                        size: 17,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),

                      const SizedBox(width: 5),

                      Text(
                        'Type: ${pet.type}',
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 5),

                  // Age
                  Row(
                    children: [

                      const Icon(
                        Icons.cake,
                        size: 17,
                        color: Colors.teal,
                      ),

                      const SizedBox(width: 5),

                      Text(
                        'Age: ${pet.age} year(s)',
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Care note
                  Text(
                    pet.careNote,

                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,

                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade700,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Static Button
                  SizedBox(
                    width: double.infinity,

                    child: ElevatedButton.icon(
                      onPressed: () {
                        showDialog(
                          context: context,

                          builder: (context) {
                            return AlertDialog(
                              title: Text(
                                '${pet.name} - Care Tips',
                              ),

                              content: Text(
                                pet.careNote,
                              ),

                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },

                                  child: const Text(
                                    'Close',
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },

                      icon: const Icon(
                        Icons.info_outline,
                      ),

                      label: const Text(
                        'View Care Tips',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}



class ApiDogGallery extends StatelessWidget {
  final Future<List<String>> dogImages;
  final VoidCallback onRefresh;

  const ApiDogGallery({
    super.key,
    required this.dogImages,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.cloud_download, color: Colors.teal),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Dogs from API',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: 'Refresh API data',
                  onPressed: onRefresh,
                  icon: const Icon(Icons.refresh),
                ),
              ],
            ),
            SizedBox(
              height: 95,
              child: FutureBuilder<List<String>>(
                future: dogImages,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'API error: ${snapshot.error}',
                        style: const TextStyle(fontSize: 12),
                      ),
                    );
                  }

                  final images = snapshot.data ?? [];

                  if (images.isEmpty) {
                    return const Center(
                      child: Text('No dog images received.'),
                    );
                  }

                  return ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: images.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          images[index],
                          width: 95,
                          height: 95,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, progress) {
                            if (progress == null) return child;
                            return Container(
                              width: 95,
                              height: 95,
                              color: Colors.grey.shade200,
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 95,
                              height: 95,
                              color: Colors.grey.shade200,
                              child: const Icon(Icons.broken_image),
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class CareTips extends StatelessWidget {
  const CareTips({super.key});

  @override
  Widget build(BuildContext context) {

    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(12),

      color: Colors.white,

      child: Row(
        children: [

          

          const SizedBox(width: 8),

          const Expanded(
            child: Text(
              'Pakan a inyong iro para di mabuang.',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}