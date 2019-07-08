import 'package:flutter_simple_dependency_injection/injector.dart';

void main() {
  // ini adalah menempatkan semua pekerjaan inisialisasi injektor ke dalam satu atau lebih modul
  // sehingga dapat bertindak lebih seperti dependency injector daripada service locator
  final injector = ModuleContainer().initialise(Injector.getInjector());

  // NOTE: ini adalah yang terbaik untuk merancang kode Anda sehingga Anda tidak perlu untuk
  // berinteraksi dengan injektor itu sendiri.  Jadikan framework ini bertindak seperti depencendy injector
  // dengan menyuntikkan dependencies injected ke objek di konstruktornya. Dengan begitu Anda terhindar
  // dari ikatan erat dengan injektor itu sendiri.

  // Penggunaan dasar, bagaimanapun, pasangan ketat semacam ini dan interaksi langsung dengan injektor
  // harus dibatasi.  Sebagai gantinya lebih suka dependencies injection.

  // Pengambilan dependency sederhana and memanggil method
  injector.get<SomeService>().doSomething();

  // dapatkan instance dari masing-masing jenis yang dipetakan yang sama
  final instances = injector.getAll<SomeType>();
  print(instances.length); // prints '3'

  // menyampaikan argumen tambahan saat menerima contoh
  final instance = injector.get<SomeOtherType>(additionalParameters: {"id": "some-id"});
  print(instance.id); // prints 'some-id'
}

class ModuleContainer {
  Injector initialise(Injector injector) {
    injector.map<Logger>((i) => Logger(), isSingleton: true);
    injector.map<String>((i) => "https://www.themealdb.com/api/json/v1/1/search.php?s=Arrabiata", key: "apiUrl");
    injector.map<SomeService>((i) => SomeService(i.get<Logger>(), i.get<String>(key: "apiUrl")));

    injector.map<SomeType>((injector) => SomeType("0"));
    injector.map<SomeType>((injector) => SomeType("1"), key: "One");
    injector.map<SomeType>((injector) => SomeType("2"), key: "Two");

    injector.mapWithParams<SomeOtherType>((i, p) => SomeOtherType(p["id"]));

    return injector;
  }
}

class Logger {
  void log(String message) => print(message);
}

class SomeService {
  final Logger _logger;
  final String _apiUrl;

  SomeService(this._logger, this._apiUrl);

  void doSomething() {
    _logger.log("Doing something with the api at '$_apiUrl'");
  }
}

class SomeType {
  final String id;
  SomeType(this.id);
}

class SomeOtherType {
  final String id;
  SomeOtherType(this.id);
}