import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyApi extends StatefulWidget {
  MyApi({Key? key}) : super(key: key);
  @override
  _MyApiState createState() => _MyApiState();
}

class _MyApiState extends State<MyApi> {

  late final jsonListResponse; //TS added this of type Future<List<dynamic>>

  @override
  void initState() {
    jsonListResponse = fetchUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Downloading and Parsing Json"),
      ),
      body: myApiWidget(jsonListResponse), //TS added argument response
    );
  }
}




//--------------------------
Future<List<dynamic>> fetchUsers() async {
  var result =
  await http.get(Uri.parse("https://randomuser.me/api/?results=40"));
  return jsonDecode(result.body)['results'];
}
//----------------------------
//TS added parameter response and return type
FutureBuilder myApiWidget(jsonListResponse) {
  return FutureBuilder(


    future: jsonListResponse,

    builder: (BuildContext context, AsyncSnapshot snapshot)
    {
      if (snapshot.hasError) { //TS added this
        return Center(
            child: Text(
                "Error message: ${snapshot.error.toString()}"));
      }
      else if (snapshot.connectionState == ConnectionState.done)
      {
        return ListView.builder //TS: as in Ch6 S.31
          (
          itemCount: snapshot.data.length,
          physics: ClampingScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return Dismissible(
              direction: DismissDirection.endToStart,
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: EdgeInsets.only(right: 20.0),
                child: Icon(Icons.delete, color: Colors.white),
              ),
              key: Key(snapshot.data[index]['email']),
              onDismissed: (direction)
              {
                var temp_item = snapshot.data[index];
                var temp_item_index = index;
                snapshot.data.removeAt(index);



                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: const Text('Item Deleted'),
                      action: SnackBarAction(
                        label: 'Undo',
                        onPressed: () {
                          snapshot.data.insert(temp_item_index, temp_item);
                        },
                      ),
                    )
                );
              },

              child: Card(
                child: Column(
                  children: [
                    ListTile( //TS ListTile not ListTitle !
                      onTap: ()
                      {
                        showDialog(
                            context: context,
                          builder: (BuildContext context)
                            {
                              return AlertDialog(
                                title: const Text('User Details:'),
                                content: SingleChildScrollView(
                                  child: ListBody(
                                    children: <Widget>[
                                      Text('Name: ${snapshot.data[index]['name']['first']} ${snapshot.data[index]['name']['last']}'),
                                      Text('Age: ${snapshot.data[index]['dob']['age']} | Date of Birth: ${snapshot.data[index]['dob']['date'].toString().substring(0, 10)} '),
                                      Text('Email: ${snapshot.data[index]['email']}'),
                                    ],
                                  )
                                ),
                                actions: <Widget>[
                                  TextButton(
                                      onPressed: Navigator.of(context).pop,
                                      child: Text('Close'),
                                  )
                                ],
                              );
                            }
                        );
                      },
              
                      title: Text(
                          snapshot.data[index]['name']['title']+ " " +
                              snapshot.data[index]['name']['first']+ " " +
                              snapshot.data[index]['name']['last']),
                      trailing:
                      Text('${snapshot.data[index]['dob']['age']}'),
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                          snapshot.data[index]['picture']['large'],
                        ),
                      ),
                      subtitle: Text(snapshot.data[index]['email']),
                    )
                  ],
                ),
              ),
            );
          },
        );
      } else {//including if (snapshot.connectionState == ConnectionState.waiting)
        return Center(
          child: CircularProgressIndicator(),
        );
      }
    },
  );
}

