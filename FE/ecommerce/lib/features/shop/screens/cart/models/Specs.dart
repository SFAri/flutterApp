class Specs {
  final String? processor;
  final String? gpu;
  final String? ram;
  final String? storage;
  final String? motherboard;
  final String? powerSupply;
  final String? socket;
  final String? chipset;
  final String? interfaceType;
  final String? formFactor;
  final String? screenSize;
  final String? refreshRate;
  final String? resolution;

  Specs({
    this.processor,
    this.gpu,
    this.ram,
    this.storage,
    this.motherboard,
    this.powerSupply,
    this.socket,
    this.chipset,
    this.interfaceType,
    this.formFactor,
    this.screenSize,
    this.refreshRate,
    this.resolution,
  });

  factory Specs.fromJson(Map<String, dynamic> json) => Specs(
    processor: json['processor'],
    gpu: json['gpu'],
    ram: json['ram'],
    storage: json['storage'],
    motherboard: json['motherboard'],
    powerSupply: json['powerSupply'],
    socket: json['socket'],
    chipset: json['chipset'],
    interfaceType: json['interface'],
    formFactor: json['formFactor'],
    screenSize: json['screenSize'],
    refreshRate: json['refreshRate'],
    resolution: json['resolution'],
  );

  Map<String, dynamic> toJson() {
    return {
      'processor': processor,
      'gpu': gpu,
      'ram': ram,
      'storage': storage,
      'motherboard': motherboard,
      'powerSupply': powerSupply,
      'socket': socket,
      'chipset': chipset,
      'interface': interfaceType,
      'formFactor': formFactor,
      'screenSize': screenSize,
      'refreshRate': refreshRate,
      'resolution': resolution,
    };
  }

  @override
  String toString() {
    return '{processor: $processor, gpu: $gpu, ram: $ram, storage: $storage, screenSize: $screenSize, refreshRate: $refreshRate, resolution: $resolution}';
  }
}
