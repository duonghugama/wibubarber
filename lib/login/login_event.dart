import 'dart:async';
import 'dart:developer' as developer;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wibubarber/login/index.dart';
import 'package:meta/meta.dart';
import 'package:wibubarber/model/user_model.dart';

@immutable
abstract class LoginEvent {
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
                        email: value.docs[0].data()['email'].toString(), password: password)
                  }
              },
            );
      } else {
        await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      }
      final userLogin = FirebaseAuth.instance.currentUser ?? "";
      if (userLogin != "") {
        yield InLoginState(UserModel(username, email, null));
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
        yield InLoginState(
          UserModel(auth.currentUser!.uid, auth.currentUser!.email ?? "", null),
        );
        yield LoginSuccessState();
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
      final user = UserModel(
        username,
        email,
        ["Customer", "Admin"],
      );
      await docUser.set(user.toJson());
      yield CreateUserSuccessState(email);
    } catch (_, stackTrace) {
      developer.log('$_', name: 'LoadLoginEvent', error: _, stackTrace: stackTrace);
      yield ErrorLoginState(_.toString());
    }
  }
}
