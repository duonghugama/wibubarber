import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:wibubarber/barber/index.dart';
import 'package:meta/meta.dart';
import 'package:wibubarber/model/barber_model.dart';

@immutable
abstract class BarberEvent {
  Stream<BarberState> applyAsync({BarberState currentState, BarberBloc bloc});
}

class UnBarberEvent extends BarberEvent {
  @override
  Stream<BarberState> applyAsync({BarberState? currentState, BarberBloc? bloc}) async* {
    yield UnBarberState();
  }
}

class LoadBarberEvent extends BarberEvent {
  @override
  Stream<BarberState> applyAsync({BarberState? currentState, BarberBloc? bloc}) async* {
    try {
      yield UnBarberState();
      List<BarberModel> barbers = [];

      barbers = await getbarber();
      yield InBarberState(barbers);
    } catch (_, stackTrace) {
      developer.log('$_', name: 'LoadBarberEvent', error: _, stackTrace: stackTrace);
      yield ErrorBarberState(_.toString());
    }
  }
}

Future<List<BarberModel>> getbarber() async {
  CollectionReference collectionRef = FirebaseFirestore.instance.collection("barber");
  QuerySnapshot snapshot = await collectionRef.get();
  return snapshot.docs.map((e) => BarberModel.fromJson(e.data() as Map)).toList();
}

class AddBarberEvent extends BarberEvent {
  final String email;
  final String exp;
  final String name;
  final String description;
  final String avatarURL;
  final PlatformFile? image;

  AddBarberEvent(this.email, this.exp, this.name, this.description, this.image, this.avatarURL);
  @override
  Stream<BarberState> applyAsync({BarberState? currentState, BarberBloc? bloc}) async* {
    try {
      String url = "";
      CollectionReference collectionRef = FirebaseFirestore.instance.collection("barber");
      if (avatarURL == "") {
        if (image != null) {
          String path = name.replaceAll(' ', '-');
          final storageRef = FirebaseStorage.instance.ref("user").child(path);
          File file = File(image!.path!);
          UploadTask uploadTask = storageRef.putFile(file);
          var dowurl = await (await uploadTask).ref.getDownloadURL();
          url = dowurl.toString();
        }
        collectionRef.add(
          BarberModel(avatarURL: url, description: description, email: email, exp: exp, name: name).toJson(),
        );
      } else {
        final snapshot = await collectionRef
            .where('email', isEqualTo: email)
            .limit(1)
            .get()
            .then((value) => value.docs[0].reference);
        await collectionRef.doc(snapshot.id).delete();
        await collectionRef.add(
          BarberModel(avatarURL: url, description: description, email: email, exp: exp, name: name).toJson(),
        );
      }

      final post = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get()
          .then((value) => value.docs[0].reference);

      var batch = FirebaseFirestore.instance.batch();
      batch.update(post, {
        'permission': {'Customer', 'Barber'}
      });
      await batch.commit();
      yield AddBarberState();
      List<BarberModel> barbers = [];
      barbers = await getbarber();
      yield InBarberState(barbers);
    } catch (_, stackTrace) {
      developer.log('$_', name: 'LoadBarberEvent', error: _, stackTrace: stackTrace);
      yield ErrorBarberState(_.toString());
    }
  }
}

class DeleteBarber extends BarberEvent {
  final String email;

  DeleteBarber(this.email);
  @override
  Stream<BarberState> applyAsync({BarberState? currentState, BarberBloc? bloc}) async* {
    try {
      if (email != "") {
        CollectionReference collectionRef = FirebaseFirestore.instance.collection("barber");
        final snapshot = await collectionRef
            .where('email', isEqualTo: email)
            .limit(1)
            .get()
            .then((value) => value.docs[0].reference);
        collectionRef.doc(snapshot.id).delete();

        final post = await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: email)
            .limit(1)
            .get()
            .then((value) => value.docs[0].reference);
        var batch = FirebaseFirestore.instance.batch();
        batch.update(post, {
          'permission': {'Customer'}
        });
        await batch.commit();
        List<BarberModel> barbers = [];
        barbers = await getbarber();
        yield InBarberState(barbers);
      }
    } catch (_, stackTrace) {
      developer.log('$_', name: 'LoadBarberEvent', error: _, stackTrace: stackTrace);
      yield ErrorBarberState(_.toString());
    }
  }
}
