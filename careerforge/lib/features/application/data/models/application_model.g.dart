// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'application_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ApplicationModelAdapter extends TypeAdapter<ApplicationModel> {
  @override
  final int typeId = 3;

  @override
  ApplicationModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ApplicationModel(
      applicationId: fields[0] as String,
      companyName: fields[1] as String,
      jobRole: fields[2] as String,
      dateApplied: fields[3] as DateTime,
      resumeId: fields[4] as String,
      resumeProfileName: fields[5] as String,
      status: fields[6] as ApplicationStatus,
      notes: fields[7] as String,
      salaryExpectation: fields[8] as String,
      jobUrl: fields[9] as String,
      lastUpdated: fields[10] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, ApplicationModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.applicationId)
      ..writeByte(1)
      ..write(obj.companyName)
      ..writeByte(2)
      ..write(obj.jobRole)
      ..writeByte(3)
      ..write(obj.dateApplied)
      ..writeByte(4)
      ..write(obj.resumeId)
      ..writeByte(5)
      ..write(obj.resumeProfileName)
      ..writeByte(6)
      ..write(obj.status)
      ..writeByte(7)
      ..write(obj.notes)
      ..writeByte(8)
      ..write(obj.salaryExpectation)
      ..writeByte(9)
      ..write(obj.jobUrl)
      ..writeByte(10)
      ..write(obj.lastUpdated);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ApplicationModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ApplicationStatusAdapter extends TypeAdapter<ApplicationStatus> {
  @override
  final int typeId = 4;

  @override
  ApplicationStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ApplicationStatus.applied;
      case 1:
        return ApplicationStatus.shortlisted;
      case 2:
        return ApplicationStatus.interviewScheduled;
      case 3:
        return ApplicationStatus.rejected;
      case 4:
        return ApplicationStatus.selected;
      default:
        return ApplicationStatus.applied;
    }
  }

  @override
  void write(BinaryWriter writer, ApplicationStatus obj) {
    switch (obj) {
      case ApplicationStatus.applied:
        writer.writeByte(0);
        break;
      case ApplicationStatus.shortlisted:
        writer.writeByte(1);
        break;
      case ApplicationStatus.interviewScheduled:
        writer.writeByte(2);
        break;
      case ApplicationStatus.rejected:
        writer.writeByte(3);
        break;
      case ApplicationStatus.selected:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ApplicationStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
