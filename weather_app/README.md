# weather_app

Weather forecast app, with the following functionalities:
  - When you open the app, a screen shows that has a button, asking you to "Enter the app." Once pressed, you enter the main Weather Screen.
  - The main weather app consists of 6 cities at the top, whose data we get from a JSON file through an API. What each card shows is the Weather in (CityName), and the current weather there. 
    - When you press on any of the 6 city cards, an alert dialog opens up, giving more information about the weather in that city, including the windspeed, feels like, humidity percentage, etc...
      - There is another button that takes you to another alert dialog (inside the current one) that shows you the forecast for the next 5 days (including the max and min temps)

  - Another feature of the weather screen is the ability to search for a city by name. If you search for a name and it finds a match, you can either press search to open another alert dialog with the same information as before, or you can press search new page to see the same information in a new page

  - You can see the current longitude and latitude of the user at the bottom of the screen, along with an image. 

  - There is a drawer in the app with no functionality, and an AppBar with basic text / an icon (not functional)

  - There is no use of shared preferences here. 
