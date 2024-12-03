class ListItems {
  int id;
  int idList;
  String name;
  String quantity;
  String note;

  ListItems(this.id, this.idList, this.name, this.note, this.quantity);

  Map<String, dynamic> toMap() {
    return {
      'id': id == 0 ? null : id,
      'idList': idList,
      'name': name,
      'quantity': quantity,
      'note': note
    };
  }
}
