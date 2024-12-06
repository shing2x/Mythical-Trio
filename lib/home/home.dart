import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tf_app/crops/crop.dart';
import 'package:tf_app/crops/crop_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;
  final _cropController = Get.put(CropController());

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true); // Repeat animation back and forth
    _animation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.2, 0), // Move slightly to the right
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final List<Map<String, dynamic>> plants = [
    //   {"name": "Pechay", "image": "assets/images/p1.png"},
    // ];

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting Section with Animated Hand Wave
              Padding(
                padding: const EdgeInsets.only(
                  top: 50,
                  left: 30,
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.grey,
                      backgroundImage: AssetImage(
                        'assets/images/2.jpg',
                      ), // Replace with your avatar image
                    ),
                    const SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              "Hi Sajon! ",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SlideTransition(
                              position: _animation,
                              child: const Text(
                                "👋",
                                style: TextStyle(fontSize: 22),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          "Welcome to CropCure.",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // GridView Section
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 650, // Set height to accommodate all content
                      child: Obx(() {
                        _cropController.fetchPlantDetails();
                        return GridView.builder(
                          physics:
                              const NeverScrollableScrollPhysics(), // Disable inner scroll
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, // Number of columnsw
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio:
                                0.9, // Adjust for desired card shape
                          ),
                          itemCount: _cropController.plantDetails.length,
                          itemBuilder: (context, index) {
                            final plant = _cropController.plantDetails[index];
                            Uint8List imageBytes = base64Decode(plant['image']);
                            return GestureDetector(
                              onTap: () => Get.to(() => PlantDiseasePage(
                                    docId: plant['id'],
                                    imageBytes: imageBytes,
                                  )),
                              child: Card(
                                color: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 5,
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: imageBytes != null
                                              ? Image.memory(
                                                  imageBytes,
                                                  height: 100,
                                                  fit: BoxFit.cover,
                                                  gaplessPlayback: true,
                                                )
                                              : Image.asset(
                                                  'assets/images/p3.png',
                                                  height: 100,
                                                  fit: BoxFit.cover,
                                                ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        plant['name'],
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }),
                    ), // Add spacing here
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
