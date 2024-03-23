# dara_music_library

Playlist song tracker app, with the following functionalities:

  - You can log in to the app with a username, email and password (if it does not match, it does not let you in). 
  - Once you are in, the main screen is a song queue, where you can add songs (add the name of the song, the artist, and a link to the song). These come up in a list fashion in the main screen. 
  - You can delete a song by swiping left, and edit a song's details by swiping right. 
    - After you delete a song, a snackbar comes up, prompting you to UNDO. If you press undo, the song comes back
  - You can press on a song tile to be taken to the link. If the link does not work, you get a snack bar saying so. Otherwise, you will be taken there directly. 
  - The app utilizes shared preferences, meaning that if you reload, exit and come back, the songs will still be there. You can delete one song at a time from the shared preferences and the app, or you can delete the whole playlist through a button in the drawer. 

  - There is no parsing and reading from JSON files in this app. 
