import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'core/bloc/books_observer.dart';
import 'features/ books/presentation/pages/books_app.dart';


void main() {
  Bloc.observer = const BooksObserver();
  runApp(const BooksApp());
}
