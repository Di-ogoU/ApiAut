class CarEntity {
  const CarEntity({
    this.id,
    required this.buying,
    required this.maint,
    required this.doors,
    required this.persons,
    required this.lugBoot,
    required this.safety,
    required this.className,
    this.createdAt,
  });

  final int? id;
  final String buying;
  final String maint;
  final String doors;
  final String persons;
  final String lugBoot;
  final String safety;
  final String className;
  final DateTime? createdAt;
}
