import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

@injectable
class CustomPrinter extends LogPrinter {
  final LogPrinter _logPrinter;

  CustomPrinter(this._logPrinter);

  @override
  void init() {
    _logPrinter.init();
  }

  @override
  void destroy() {
    _logPrinter.destroy();
  }

  @override
  List<String> log(LogEvent event) {
    return _logPrinter.log(event);
  }
}
