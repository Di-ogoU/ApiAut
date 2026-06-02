import '../../domain/entities/car_entity.dart';

class CarModel extends CarEntity {
  const CarModel({
    super.id,
    required super.buying,
    required super.maint,
    required super.doors,
    required super.persons,
    required super.lugBoot,
    required super.safety,
    required super.className,
    super.createdAt,
  });

  factory CarModel.fromJson(Map<String, dynamic> json) {
    return CarModel(
      id: json['id'] as int?,
      buying: json['buying'] as String,
      maint: json['maint'] as String,
      doors: json['doors'] as String,
      persons: json['persons'] as String,
      lugBoot: json['lug_boot'] as String,
      safety: json['safety'] as String,
      className: json['class_name'] as String,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.tryParse(json['created_at'] as String),
    );
  }

  factory CarModel.fromEntity(CarEntity entity) {
    return CarModel(
      id: entity.id,
      buying: entity.buying,
      maint: entity.maint,
      doors: entity.doors,
      persons: entity.persons,
      lugBoot: entity.lugBoot,
      safety: entity.safety,
      className: entity.className,
      createdAt: entity.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'buying': buying,
      'maint': maint,
      'doors': doors,
      'persons': persons,
      'lug_boot': lugBoot,
      'safety': safety,
      'class_name': className,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  CarModel withCreatedNow() {
    return CarModel(
      id: id,
      buying: buying,
      maint: maint,
      doors: doors,
      persons: persons,
      lugBoot: lugBoot,
      safety: safety,
      className: className,
      createdAt: DateTime.now(),
    );
  }
}
