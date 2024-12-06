import 'dart:convert'; // Add import for json decoding
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'dart:math' as rnd;

class AiService extends GetxController {
  final _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? get currentUser => _auth.currentUser;
  var responseFromAi = {}.obs;

  String generateUniqueId() {
    var random = rnd.Random();
    int randomNumber = 1000000 + random.nextInt(9000000);
    return 'plant#$randomNumber';
  }

  // Extracts a part of the string between two delimiters
  String g(String s, String t, String r) {
    var splitByT = s.split(t);
    if (splitByT.length > 1) {
      var splitByR = splitByT[1].split(r);
      return splitByR[0];
    } else {
      return '';
    }
  }

  // Function to fetch and process the AI response
  Future<void> response(
      {required String label,
      required String disease,
      required String image}) async {
    String autoID = generateUniqueId();
    log('click');

    // Your API Key (remember to protect this key in production)
    const apiKey = 'AIzaSyAm46Kh9cKfiLmnKaX_bja5xboiB3TJ6LU';

    // Initialize the model using the API key
    final model = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: apiKey,
    );

    // The prompt requesting the AI to return treatment and cause for Pechay's bacterial spot disease
    final prompt = '''
      Can you give the treatment and the cause for this plant $label. Disease is $disease then respond in JSON format.
      
    {
        "user_id": ${currentUser!.uid},
        "id": $autoID,
        "name": xxxx,
        "diseases": [
          {
            "name": xxxxxx",
            "cause": xxxxxx,
            "treatment": [
              xxxxxxxx,
              xxxxxxx
            ],
          },
        ]
      }
    ''';

    // Send the prompt as content to the API
    final content = [Content.text(prompt)];
    final response = await model.generateContent(content);

    try {
      final parseTry =
          g('${response.text}', '```json', '```'); // Extract the JSON part
      final decodedResponse =
          jsonDecode(parseTry); // Decoding the JSON response
      responseFromAi.value =
          decodedResponse; // Storing the parsed map into the observable variable
      log('Parsed response: $decodedResponse'); // Log the parsed response

      // Now add the response to Firestore
      await _firestore
          .collection('plant')
          .doc(autoID)
          .set(decodedResponse, SetOptions(merge: true));
      await _firestore
          .collection('plant')
          .doc(autoID)
          .set({'image': image}, SetOptions(merge: true));
      log('Successfully added to Firestore');
    } catch (e) {
      log('Error decoding JSON: $e');
    }
  }
}
