// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$UserStore on _UserBase, Store {
  final _$currentAtom = Atom(name: '_UserBase.current');

  @override
  User? get current {
    _$currentAtom.reportRead();
    return super.current;
  }

  @override
  set current(User? value) {
    _$currentAtom.reportWrite(value, super.current, () {
      super.current = value;
    });
  }

  final _$accountsAtom = Atom(name: '_UserBase.accounts');

  @override
  ObservableList<User> get accounts {
    _$accountsAtom.reportRead();
    return super.accounts;
  }

  @override
  set accounts(ObservableList<User> value) {
    _$accountsAtom.reportWrite(value, super.accounts, () {
      super.accounts = value;
    });
  }

  final _$_UserBaseActionController = ActionController(name: '_UserBase');

  @override
  void addUser(User value) {
    final _$actionInfo =
        _$_UserBaseActionController.startAction(name: '_UserBase.addUser');
    try {
      return super.addUser(value);
    } finally {
      _$_UserBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setCurrent(User value) {
    final _$actionInfo =
        _$_UserBaseActionController.startAction(name: '_UserBase.setCurrent');
    try {
      return super.setCurrent(value);
    } finally {
      _$_UserBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
current: ${current},
accounts: ${accounts}
    ''';
  }
}
