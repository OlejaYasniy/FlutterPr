import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'books/core/books_observer.dart';
import 'books/view/books_app.dart';

void main() {
  Bloc.observer = const BooksObserver();
  runApp(const BooksApp());
}
