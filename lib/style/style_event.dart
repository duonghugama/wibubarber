import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:wibubarber/model/style_model.dart';
import 'package:wibubarber/style/index.dart';

@immutable
abstract class StyleEvent {
  static List<StyleModel> styles = [];
  Stream<StyleState> applyAsync({StyleState currentState, StyleBloc bloc});
}

class LoadStyleEvent extends StyleEvent {
  @override
  Stream<StyleState> applyAsync({StyleState? currentState, StyleBloc? bloc}) async* {
    try {
      yield UnStyleState();
      StyleEvent.styles.clear();
      await getStyle();
      yield InStyleState(StyleEvent.styles);
    } catch (_, stackTrace) {
      developer.log('$_', name: 'LoadStyleEvent', error: _, stackTrace: stackTrace);
      yield ErrorStyleState(_.toString());
    }
  }
}

Future<bool> getStyle() async {
  final ref = FirebaseDatabase.instance.ref();
  final snapshot = await ref.child('style').get();
  if (snapshot.exists) {
    for (final child in snapshot.children) {
      Map item = child.value as Map;
      StyleEvent.styles.add(StyleModel.fromJson(item));
    }
    return Future.value(true);
  } else {
    return Future.value(false);
  }
}

class AddStyleEvent extends StyleEvent {
  final StyleModel style;
  final PlatformFile? image;

  AddStyleEvent(this.style, this.image);
  @override
  Stream<StyleState> applyAsync({StyleState? currentState, StyleBloc? bloc}) async* {
    try {
      DatabaseReference dataRef = FirebaseDatabase.instance.ref("style");
      // if (image != null) {
      //   await storageRef.putFile(File(image!.path!),);
      // }
      String url = "";
      String path = "${style.styleName?.replaceAll(' ', '-')}";
      if (image != null) {
        final storageRef = FirebaseStorage.instance.ref("style").child(path);
        File file = File(image!.path!);
        UploadTask uploadTask = storageRef.putFile(file);
        var dowurl = await (await uploadTask).ref.getDownloadURL();
        url = dowurl.toString();
      }
      StyleModel styleModel = StyleModel(
        styleName: style.styleName,
        description: style.description,
        styleTime: style.styleTime,
        stylePrice: style.stylePrice,
        styleType: style.styleType,
        imageURL: url,
      );
      await dataRef.update(styleModel.toJson());
      StyleEvent.styles.add(styleModel);
      yield AddStyleSuccessState();
      await Future.delayed(Duration(milliseconds: 100));
      yield InStyleState(StyleEvent.styles);
    } catch (_, stackTrace) {
      developer.log('$_', name: 'LoadStyleEvent', error: _, stackTrace: stackTrace);
      yield ErrorStyleState(_.toString());
    }
  }
}

class UpdateStyleEvent extends StyleEvent {
  final StyleModel styleModel;
  final PlatformFile? image;

  UpdateStyleEvent(this.styleModel, this.image);
  @override
  Stream<StyleState> applyAsync({StyleState? currentState, StyleBloc? bloc}) async* {
    try {
      DatabaseReference dataRef = FirebaseDatabase.instance.ref("style");
      final storageRef = FirebaseStorage.instance.ref("style");
      if (image != null) {
        await storageRef.putFile(File(image!.path!));
      }
      await dataRef.update(styleModel.toJson());
      StyleEvent.styles.add(styleModel);
      yield UpdateStyleSuccessState();
      await Future.delayed(Duration(milliseconds: 100));
      yield InStyleState(StyleEvent.styles);
    } catch (_, stackTrace) {
      developer.log('$_', name: 'LoadStyleEvent', error: _, stackTrace: stackTrace);
      yield ErrorStyleState(_.toString());
    }
  }
}
