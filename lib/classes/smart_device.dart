class SmartDevice {
  final String? id;
  final String? name;
  final String? location;
  final bool? status;
  final Function? startDevice;
  final String? description;
  final String? image;

  const SmartDevice(
      {this.id,
      this.name,
      this.location,
      this.status,
      this.startDevice,
      this.description,
      this.image});
}
