import 'package:dara_music_library/login_page.dart';
import 'package:dara_music_library/playlist.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './song.dart';
import 'package:url_launcher/url_launcher.dart';


class Library extends StatefulWidget {
  const Library({super.key, required this.username});
  final String username;

  @override
  State<Library> createState() => _LibraryState();
}

class _LibraryState extends State<Library> {

  Playlist playlist = Playlist(playlistName: 'Playlist #1', songs: []);

  TextEditingController nameController = TextEditingController();
  TextEditingController artistController = TextEditingController();
  TextEditingController linkController = TextEditingController();

  dynamic tempDeletedItem;


  @override
  void initState() {
    super.initState();
    readPrefs().then(
            (_){
          setState(() {
                (){};
          });
        }
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                deletePrefs();
              },
              child: Text('Delete current playlist'),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: null,
              child: Text('Shuffle'),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: null,
              child: Text('Something else'),
            ),
            SizedBox(height: 20),

            TextButton(
              onPressed: null,
              child: Text('About the app'),
            )

          ],
        ),
      ),
      appBar: AppBar(
        title: Text('${widget.username}\'s playlist: ${playlist.playlistName}'),
        actions: <Widget>[
          IconButton(
              onPressed: () => _logoutDialog(context),
              icon: const Icon(
                  Icons.logout)
          )
        ],

      ),
      body: _buildPlaylist(),
      floatingActionButton: _buildAddButton(),

    );
  }

  _logoutDialog(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: const Text('Logout'),
            content: const Text('Are you sure you want to log out?'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('No')
              ),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => const LoginPage()),
                            (Route<dynamic> route) => false);
                  },
                  child: const Text('Yes')
              ),
            ],
          );
        }
    );
  }

  // -------------------------------------------//
  // ------------Shared Preferences-------------//

  Future readPrefs() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var record_id = 1;

    while(true){
      var line = prefs.getString('${record_id}') ?? "";

      if (line.isEmpty){
        break;
      }
      else {
        playlist.songs.add(Song(name: line.split('|')[0], artist: line.split('|')[1], link: line.split('|')[2]));
        record_id++;
      }
    }
  }
  Future writePref(Song song) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('${song.id}', '${song.name}|${song.artist}|${song.link}');
  }
  Future deletePrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    setState(() {
      playlist.playlistName = "New Playlist";
      playlist.songs = [];
    });
  }

  Future<void> deletePrefsSong(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Directly remove the song's SharedPreferences entry.
    await prefs.remove('${index + 1}'); // Assuming `id` is 1-based index.

    // Update SharedPreferences for subsequent songs.
    int totalSongs = playlist.songs.length + 1; // Since one song is already removed from the list.
    for (int i = index + 1; i < totalSongs; i++) {
      final nextSong = prefs.getString('${i + 1}');
      if (nextSong != null) {
        // Move the next song up by one position.
        await prefs.setString('$i', nextSong);
        await prefs.remove('${i + 1}'); // Remove old entry.
      }
    }
  }



  // -------------------------------------------//




  Widget _buildPlaylist() {
    return ListView.builder(
      itemBuilder: (context, index) => _buildSongTile(playlist.songs[index], index),
      itemCount: playlist.songs.length,
      physics: const AlwaysScrollableScrollPhysics(),

    );
  }

  Widget _buildAddButton() {
    return FloatingActionButton(
        onPressed: () => _addSongDialog(context),
        child: const Icon(Icons.add));
  }

  Widget _buildSongTile(Song song, int index) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.horizontal,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),

      secondaryBackground: Container(
        color: Colors.blue,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(
          Icons.edit,
          color: Colors.white,
        ),

      ),
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd) {
          setState(() {
            tempDeletedItem = playlist.songs[index];
            playlist.songs.removeAt(index);

          });

          deletePrefsSong(index);

          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Item deleted.'),
                action: SnackBarAction(
                  label: 'UNDO',
                  onPressed: () {
                    if (tempDeletedItem != null)
                    {
                      playlist.songs.insert(index, tempDeletedItem);
                      writePref(tempDeletedItem);
                    }

                    setState(() {

                    });
                  },
                ),
              )
          );
        }

        else if (direction == DismissDirection.endToStart)
        {
          _editSongDialog(song, index);
        }
      },


      child: Card(
        child: ListTile(
          title: Text(playlist.songs[index].name),
          subtitle: Text(playlist.songs[index].artist),
          trailing: const Text('Press to play.'),
          onTap: () async {
            final Uri url = Uri.parse(playlist.songs[index].link);
            if (await canLaunchUrl(url)) {
              await launchUrl(url);
            }
            else {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Could not launch.'))
              );
            }
          },
        ),
      ),
    );
  }
  _editSongDialog(Song song, int index) async {

    TextEditingController editNameController = TextEditingController(text: song.name);
    TextEditingController editArtistController = TextEditingController(text: song.artist);
    TextEditingController editLinkController = TextEditingController(text: song.link);

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Song'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: editNameController,
                  decoration: const InputDecoration(labelText: 'Song Name'),
                ),
                TextField(
                  controller: editArtistController,
                  decoration: const InputDecoration(labelText: 'Artist'),
                ),
                TextField(
                  controller: editLinkController,
                  decoration: const InputDecoration(labelText: 'Link'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {

                  song.name = editNameController.text;
                  song.artist = editArtistController.text;
                  song.link = editLinkController.text;

                });
                Navigator.of(context).pop();
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  _addSongDialog(BuildContext context) async
  {
    await showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: const Text('Add song...'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                      labelText: 'Enter song name...'
                  ),
                ),
                TextField(
                  controller: artistController,
                  decoration: const InputDecoration(
                      labelText: 'Enter artist name...'
                  ),
                ),
                TextField(
                  controller: linkController,
                  decoration: const InputDecoration(
                      labelText: 'Enter link to song...'
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: Navigator.of(context).pop,
                  child: const Text('Cancel')
              ),
              TextButton(
                  onPressed: () {
                    if (nameController.text.isNotEmpty && artistController.text.isNotEmpty && linkController.text.isNotEmpty) {
                      String name = nameController.text;
                      String artist = artistController.text;
                      String link = linkController.text;

                      nameController.text = '';
                      artistController.text = '';
                      linkController.text = '';
                      setState(() {
                        Song newSong = Song(name: name, artist: artist, link: link);
                        playlist.songs.add(newSong);
                        writePref(newSong);
                      });

                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Add'))
            ],
          );
        }
    );
  }
}
