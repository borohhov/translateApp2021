import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:translation_app/model/translation.dart';

class FirebaseApi {

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  static Future<void> init() async {
    await Firebase.initializeApp();
  }

  void saveToDb(Translation translation) async {
    final translationsRef = FirebaseFirestore.instance.collection('translations').withConverter<Translation>(
      fromFirestore: (snapshot, _) => Translation.fromJson(snapshot.data()!),
      toFirestore: (transl, _) => transl.toJson(),
    );
    // Add a translation to db
    await translationsRef.add(
      translation,
    );
  }

  dynamic getFromDb(){

  }
}