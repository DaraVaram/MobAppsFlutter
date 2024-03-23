import './song.dart';

class Playlist
{
  String playlistName;
  List<Song> songs;

  Playlist({this.playlistName = '', this.songs = const []});
}