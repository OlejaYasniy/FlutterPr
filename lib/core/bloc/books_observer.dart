import 'package:bloc/bloc.dart';

class BooksObserver extends BlocObserver {
  const BooksObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    print('${bloc.runtimeType} $change');
  }
}
