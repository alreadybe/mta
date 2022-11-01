import 'package:mta_app/core/logger.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:logger_flutter_v2/logger_flutter_v2.dart';

@module
abstract class LoggerModule {
  @injectable
  LogPrinter get logPrinter => PrettyPrinter(printTime: true);

  @singleton
  Logger logger(CustomPrinter customPrinter) => Logger(
        level: Level.verbose,
        filter: ProductionFilter(),
        printer: customPrinter,
        output: MultiOutput([
          ConsoleOutput(),
          ConsoleLogOutput(),
        ]),
      );
}
