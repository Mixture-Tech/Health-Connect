class Disease{
  Disease({
    required this.id,
    required this.name,
  });

  final String id;
  final String name;

  factory Disease.fromJson(Map<String, dynamic> json){
    return Disease(
      id: json['disease_id'] != null && json['disease_id'] != '' ? json['disease_id'] : 'Unknown ID',
      name: json['disease_name'] != null && json['disease_name'] != '' ? json['disease_name'] : 'Unknown Name',
    );
  }
}