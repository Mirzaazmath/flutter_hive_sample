import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lottie/lottie.dart';

void main()async{
  // Make sure you add all dependencies
  // just take look at pubspec.yaml
  // here we are initailizing the hive
  // this is an asyncronus function so make sure you use the async and await

  await Hive.initFlutter();
  // here we are creating the hive box with the name of textBox
  // you can give any name you want
  // it is important to create the box
 Box box = await Hive.openBox('testBox');
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHome(),
    );
  }
}
class MyHome extends StatefulWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  TextEditingController textEditingController=TextEditingController();
  @override
  var value;
  // here we are call the hive box and assign it to a variable
  // make sure you use the same name of the box
  var box = Hive.box('testBox');

  @override
  Widget build(BuildContext context) {
    print("hello");
    return Scaffold(
      appBar: AppBar(
        title: const Text("HIVE EXAMPLE"),
        actions: [
          IconButton(onPressed:(){
            // deleting entire list
            removealldata();
          }, icon: const Icon(Icons.delete))
        ],
      ),
      body: SafeArea(
        child: Column(
        
          children: [



            Padding(
              padding: const EdgeInsets.all(20),
              child: TextFormField(
                controller:textEditingController ,
                decoration:const  InputDecoration(
                  border: OutlineInputBorder()
                ),

              ),
            ),
            ElevatedButton(onPressed: savedata,

             child:const Text("Save")),
            Expanded(
              // here we are using the value listner so
              // everytime if there is any changes it will automatically
              //update the ui
              child: ValueListenableBuilder<Box>(
                valueListenable: Hive.box('testBox').listenable(),
                builder: (context, box, widget) {
                  print("world");
                  value=box.get(1);

                  return value==null?
                 Lottie.asset("assets/nodata.json"):ListView.builder(
                    shrinkWrap: true,
                    itemCount: value.length,
                      itemBuilder: (context,index){
                    return ListTile(
                      leading: CircleAvatar(
                        child: Text(index.toString(),style: const TextStyle(fontWeight: FontWeight.bold),),
                      ),
                      title: Text(value[index].toString().toUpperCase()),
                      trailing: IconButton(onPressed:(){
                        removedata(index);
                      },icon:const  Icon(Icons.delete),),
                    );
                  });
                },),
            ),
          ],
        ),
      ),
    );
  }
  void savedata(){


    List<String>list=[];

    list.addAll(box.get(1)??[]);

    list.add(textEditingController.text);

// put is used to store the data
    // here 1 is the key
    box.put(1, list);
    textEditingController.clear();
    FocusScope.of(context).unfocus();
  }
  void removedata(index){
    List<String>list=[];
    list.addAll(box.get(1));
    list.removeAt(index);
    list.isNotEmpty?

    box.put(1, list):box.delete(1);
  }
  void removealldata(){

// delete is used to delete
    box.delete(1);
  }
}

