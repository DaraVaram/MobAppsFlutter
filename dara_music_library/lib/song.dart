class Song{
  static int recordID = 1;
  late int id;

  String name;
  String artist;
  String link;

  Song({this.name = '', this.artist = '', this.link = ''})
  {
    id = recordID++;
  }
}