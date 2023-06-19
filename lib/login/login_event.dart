import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:wibubarber/login/index.dart';
import 'package:meta/meta.dart';
import 'package:wibubarber/model/user_model.dart';
import 'package:wibubarber/userlocalstorage.dart';

@immutable
abstract class LoginEvent {
  static List<String> permission = [];
  Stream<LoginState> applyAsync({LoginState currentState, LoginBloc bloc});
}

class UnLoginEvent extends LoginEvent {
  @override
  Stream<LoginState> applyAsync({LoginState? currentState, LoginBloc? bloc}) async* {
    yield UnLoginState();
  }
}

class SignInEvent extends LoginEvent {
  final String username;
  final String email;
  final String password;

  SignInEvent(this.username, this.email, this.password);

  @override
  Stream<LoginState> applyAsync({LoginState? currentState, LoginBloc? bloc}) async* {
    try {
      yield UnLoginState();
      if (username != "") {
        await FirebaseFirestore.instance
            .collection('users')
            .where("username", isEqualTo: username)
            .get()
            .then(
              (value) async => {
                if (value.size > 0)
                  {
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: value.docs[0].data()['email'].toString(), password: password),
                    await UserLocalStorage.setname(value.docs[0].data()['name'].toString()),
                    await UserLocalStorage.setUsername(username),
                    await UserLocalStorage.setPassword(password),
                    await UserLocalStorage.setAvatar(value.docs[0].data()['avatarURL'].toString()),
                    LoginEvent.permission = List.from(value.docs[0].data()['permission'])
                  }
              },
            );
      } else {
        await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      }
      await Future.delayed(Duration(seconds: 1));
      final userLogin = FirebaseAuth.instance.currentUser ?? "";
      String name = await UserLocalStorage.getname();
      String avatarUrl = await UserLocalStorage.getAvatar();

      if (userLogin != "") {
        yield InLoginState(
            UserModel(username, FirebaseAuth.instance.currentUser!.email.toString(), [], name, avatarUrl));
        await Future.delayed(Duration(seconds: 1));
        yield LoginSuccessState();
      }
    } catch (_, stackTrace) {
      developer.log('$_', name: 'LoadLoginEvent', error: _, stackTrace: stackTrace);
      yield ErrorLoginState(_.toString());
    }
  }
}

class LoadLoginEvent extends LoginEvent {
  @override
  Stream<LoginState> applyAsync({LoginState? currentState, LoginBloc? bloc}) async* {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      // yield UnLoginState();
      if (auth.currentUser != null) {
        String username = await UserLocalStorage.getUsername();
        String name = await UserLocalStorage.getname();
        String avatarUrl = await UserLocalStorage.getAvatar();
        yield LoginSuccessState();
        await Future.delayed(Duration(seconds: 1));
        yield InLoginState(
          UserModel(username, auth.currentUser!.email ?? "", [], name, avatarUrl),
        );
      } else {
        yield InLoginState(null);
      }
    } catch (_, stackTrace) {
      developer.log('$_', name: 'LoadLoginEvent', error: _, stackTrace: stackTrace);
      yield ErrorLoginState(_.toString());
    }
  }
}

class LogoutEvent extends LoginEvent {
  @override
  Stream<LoginState> applyAsync({LoginState? currentState, LoginBloc? bloc}) async* {
    try {
      await FirebaseAuth.instance.signOut();
      yield LogoutState();
      yield InLoginState(null);
    } catch (_, stackTrace) {
      developer.log('$_', name: 'LoadLoginEvent', error: _, stackTrace: stackTrace);
      yield ErrorLoginState(_.toString());
    }
  }
}

class SignUpEvent extends LoginEvent {
  final String username;
  final String email;
  final String password;

  SignUpEvent(this.username, this.email, this.password);

  @override
  Stream<LoginState> applyAsync({LoginState? currentState, LoginBloc? bloc}) async* {
    try {
      FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      final docUser = FirebaseFirestore.instance.collection('users').doc();
      final user = UserModel(username, email, ["Customer"], "", "");
      await docUser.set(user.toJson());
      yield CreateUserSuccessState(email);
      yield InLoginState(null);
    } catch (_, stackTrace) {
      developer.log('$_', name: 'LoadLoginEvent', error: _, stackTrace: stackTrace);
      yield ErrorLoginState(_.toString());
    }
  }
}

class ChangeAvatarEvent extends LoginEvent {
  final PlatformFile? image;

  ChangeAvatarEvent(this.image);

  @override
  Stream<LoginState> applyAsync({LoginState? currentState, LoginBloc? bloc}) async* {
    try {
      String url = "";
      String username = await UserLocalStorage.getUsername();
      String name = await UserLocalStorage.getname();
      String path = username.replaceAll(' ', '-');
      if (image != null) {
        final storageRef = FirebaseStorage.instance.ref("user").child(path);
        File file = File(image!.path!);
        UploadTask uploadTask = storageRef.putFile(file);
        var dowurl = await (await uploadTask).ref.getDownloadURL();
        url = dowurl.toString();
      }
      final post = await FirebaseFirestore.instance
          .collection('users')
          .where("username", isEqualTo: username)
          .limit(1)
          .get()
          .then((value) => value.docs[0].reference);
      var batch = FirebaseFirestore.instance.batch();
      batch.update(post, {'avatarURL': url});
      batch.commit();
      final FirebaseAuth auth = FirebaseAuth.instance;
      yield InLoginState(
        UserModel(username, auth.currentUser!.email ?? "", [], name, url),
      );
    } catch (_, stackTrace) {
      developer.log('$_', name: 'LoadLoginEvent', error: _, stackTrace: stackTrace);
      yield ErrorLoginState(_.toString());
    }
  }
}
