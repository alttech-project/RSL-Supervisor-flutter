void printLogs(Object object) {
  const bool isProduction = bool.fromEnvironment('dart.vm.product');
  if (!isProduction) {
    // ignore: avoid_print
    print("$object");
  }
}
