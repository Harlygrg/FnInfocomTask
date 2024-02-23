import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:machine_task/Controller/home_screen_controller.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  HomeScreenProvider ? provider;

  @override
  void initState() {
   provider = Provider.of<HomeScreenProvider>(context,listen: false);
   WidgetsBinding.instance.addPostFrameCallback((timeStamp) async{
     await provider?.getImage();
     await provider?.getUser();
   });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(

      appBar: AppBar(
        title: const Text('Home Screen'),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: SafeArea(
        child: SizedBox(
          height: size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Consumer<HomeScreenProvider>(
                builder: (context,model,_) {
                  if(model.isLoading) {
                    debugPrint('-----------> loading');
                    return const Expanded(
                      child: Align(
                        alignment: Alignment.center,
                        child:  SizedBox.square(
                          dimension: 25,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        ),
                      ),
                    );
                  }
                  if(model.imageData!=null) {
                    return Padding(
                      padding: const EdgeInsets.all(10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                          child: Image.network(
                            model.imageData!.message!,
                            fit: BoxFit.contain,
                          )),
                    );
                  }

                  return const SizedBox(
                    child: Text("Something went wrong. Please try again later."),
                  );

                }
              ),
              const Spacer(),


              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton.icon(
                        onPressed: ()async{
                          await provider!.getImage();
                        },
                        icon: const Icon(Icons.refresh),
                      label: const Text('Refresh'),
                    ),
                    ElevatedButton(
                      onPressed: ()async{


                      },
                    child: const Text('Enable Bluetooth'),
                    )
                  ],
                ),
              )

            ],
          ),
        ),

        
      ),
      drawer: Drawer(
        child: Consumer<HomeScreenProvider>(
          builder: (context,model,_) {
            if(model.userData!=null) {
              var userData = model.userData!.results![0];
              return ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  decoration:const BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: Column(
                    children: [
                       Text('${userData.name?.title ?? ''} ${userData?.name?.first ?? ' '}'
                          ' ${userData.name?.last ?? ''}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage('${userData.picture?.thumbnail}'),
                      )
                    ],
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.location_on),
                  title: Text(userData.location?.city ??''),
                  onTap: () {
                    // Navigate to the home screen
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.email),
                  title: Text('${userData.email}'),
                  onTap: () {
                    // Navigate to the profile screen
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.cake),
                  title: Text(userData.dob!=null ? DateFormat('yyyy-MM-dd').format(userData.dob!.date!):''),
                  onTap: () {
                    // Navigate to the settings screen
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Text('No of days Passed '),
                  title: Text('${model.calculateDaysPassed(userData.registered?.date)}'),
                  onTap: () {
                    // Navigate to the settings screen
                    Navigator.pop(context);
                  },
                ),
              ],
            );
            }
            return const SizedBox();
          }
        ),
      ),
    );
  }
}
