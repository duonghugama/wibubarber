import 'dart:async';
import 'dart:developer' as developer;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:wibubarber/login/index.dart';
import 'package:meta/meta.dart';
import 'package:wibubarber/model/user_model.dart';
import 'package:wibubarber/userlocalstorage.dart';

@immutable
abstract class LoginEvent {
  static String username = "";
  static List<String> roles = [];
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
                    // await UserLocalStorage.setRoles(List.castFrom(value.docs[0].data()['permission']))
                  }
              },
            );
      } else {
        await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      }
      final userLogin = FirebaseAuth.instance.currentUser ?? "";
      String name = await UserLocalStorage.getname();
      // List<String> roles = await UserLocalStorage.getRoles();

      if (userLogin != "") {
        yield InLoginState(
            UserModel(username, FirebaseAuth.instance.currentUser!.email.toString(), [], name));
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
        // List<String> roles = await UserLocalStorage.getRoles();
        // List<String> roles = await UserLocalStorage.getRoles();

        yield LoginSuccessState();
        await Future.delayed(Duration(seconds: 1));
        yield InLoginState(
          UserModel(username, auth.currentUser!.email ?? "", [], name),
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
      final user = UserModel(username, email, ["Customer"], "");
      await docUser.set(user.toJson());
      yield CreateUserSuccessState(email);
    } catch (_, stackTrace) {
      developer.log('$_', name: 'LoadLoginEvent', error: _, stackTrace: stackTrace);
      yield ErrorLoginState(_.toString());
    }
  }
}
