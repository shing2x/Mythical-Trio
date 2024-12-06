import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tf_app/crops/crop_controller.dart';

class PlantDiseasePage extends StatefulWidget {
  Uint8List imageBytes;
  String docId;
  PlantDiseasePage({super.key, required this.imageBytes, required this.docId});

  @override
  State<PlantDiseasePage> createState() => _PlantDiseasePageState();
}

class _PlantDiseasePageState extends State<PlantDiseasePage> {
  final _controller = Get.put(CropController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initPlant();
  }

  @override
  Widget build(BuildContext context) {
    // final List<Map<String, dynamic>> plants = [
    //   {
    //     "name": _controller.plantDetails,
    //     "diseases": [
    //       {
    //         "image": "assets/images/p1a.png",
    //         "name": "Downy Mildew (Amag na Mabaho)",
    //         "cause": "Prolonged wet and cool weather, poor air circulation.",
    //         "treatment": [
    //           "Mix 3 parts milk to 10 parts water and spray weekly.",
    //           "Dissolve 1 tablespoon of baking soda into 1 liter of water, mix, and spray weekly."
    //         ],
    //       },
    //     ]
    //   },
    // ];

    return Scaffold(
      body: Column(
        children: [
          // Header Section
          Padding(
            padding: const EdgeInsets.only(
              top: 20,
              left: 20,
              right: 20,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Back Button
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.arrow_back, color: Colors.black),
                ),
                // Logo
                Image.asset(
                  "assets/images/3.png", // Replace with your logo path
                  height: 60,
                ),
              ],
            ),
          ),
          // Disease List Section
          Expanded(
            child: Obx(() {
              _controller.fetchPlantDet(id: widget.docId);
              final plant = _controller.plantDet;
              return Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Plant Name
                        Text(
                          plant['name'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Diseases List
                        ...plant['diseases'].map<Widget>((disease) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Divider(color: Colors.grey),
                              // Disease Image
                              Container(
                                height: 150,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                    image: MemoryImage(widget.imageBytes),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              // Disease Name
                              Text(
                                disease['name'],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 15, 129, 19),
                                ),
                              ),
                              const SizedBox(height: 5),
                              // Disease Cause
                              Text(
                                "Cause: ${disease['cause']}",
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 5),
                              // Disease Treatment
                              const Text(
                                "Treatment:",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              ...disease['treatment'].map<Widget>((treatment) {
                                return Text(
                                  "- $treatment",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                );
                              }).toList(),
                              const SizedBox(height: 10),
                            ],
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Future<void> initPlant() async {
    await _controller.fetchPlantDetails();
  }
}
