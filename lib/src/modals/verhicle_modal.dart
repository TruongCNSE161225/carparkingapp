class VehicleModal {
  String? id;
  String? name;
  String? licensePlate;
  String? color;
  List<String>? images;
  String? userId;
  int? vehicleTypeId;

  VehicleModal(
      {this.id,
      this.name,
      this.licensePlate,
      this.color,
      this.images,
      this.userId,
      this.vehicleTypeId});

  VehicleModal.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    licensePlate = json['licensePlate'];
    color = json['color'];
    images = json['images'].cast<String>();
    userId = json['userId'];
    vehicleTypeId = json['vehicleTypeId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['licensePlate'] = this.licensePlate;
    data['color'] = this.color;
    data['images'] = this.images;
    data['userId'] = this.userId;
    data['vehicleTypeId'] = this.vehicleTypeId;
    return data;
  }
}