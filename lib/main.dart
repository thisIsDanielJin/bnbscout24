import 'package:appwrite/appwrite.dart';
import 'package:bnbscout24/components/booking_request_item.dart';
import 'package:bnbscout24/components/conversation_tab_bar_item.dart';
import 'package:bnbscout24/components/custom_tab_bar.dart';
import 'package:bnbscout24/components/custom_tab_bar_item.dart';
import 'package:bnbscout24/components/properties_tab_bar_item.dart';
import 'package:bnbscout24/constants/constants.dart';
import 'package:bnbscout24/constants/sizes.dart';
import 'package:bnbscout24/pages/conversations_page.dart';
import 'package:bnbscout24/pages/create_property.dart';
import 'package:bnbscout24/pages/home_page.dart';
import 'package:bnbscout24/pages/profile_page.dart';
import 'package:bnbscout24/pages/properties_page.dart';
import 'package:bnbscout24/pages/search_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:bnbscout24/utils/snackbar_service.dart';
import 'package:bnbscout24/api/login_manager.dart';
import 'package:bnbscout24/pages/login_register_page.dart';
import 'package:provider/provider.dart';

import 'data/booking.dart';
import 'data/message.dart';
import 'data/property.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //check for existing appwrite session and landlord status
  await LoginManager.checkSession();
  await LoginManager.checkLandlord();

  runApp(
    ChangeNotifierProvider(
      create: (_) => LoginManager(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp();

  @override
  MyAppState createState() {
    return MyAppState();
  }
}

//TODO: only make pages that actually require authentication hidden behind auth
//create auth wrapper with callback?
class MyAppState extends State<MyApp> {
  int bookingRequests = 0;
  int messages = 0;

  RealtimeSubscription? bookingSub;
  static List<MessageConversation> messageConversations = [];
  static List<Booking> bookings = [];
  static List<Property> properties = [];




  void loadBookings() async {
    final loginManager = Provider.of<LoginManager>(context, listen: false);

  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {

      bookingSub = Booking.subsribeBookings();
      bookingSub?.stream.listen((msg) {
        loadBookings();
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    bookingSub?.close();
  }


  @override
  Widget build(BuildContext context) {
    final loginManager = Provider.of<LoginManager>(context);



    return MaterialApp(
      scaffoldMessengerKey: SnackbarService.scaffoldMessengerKey,
    
      theme: ThemeData(
        scaffoldBackgroundColor: ColorPalette.white,
        
      ),
      home: loginManager.isLoggedIn
          ? CustomTabBar(
              items: [
                CustomTabBarItem(
                    page: HomePage(),
                    tab_widget: FaIcon(FontAwesomeIcons.map,
                        size: Sizes.navBarIconSize)),
                CustomTabBarItem(
                    page: SearchPage(),
                    tab_widget: FaIcon(FontAwesomeIcons.magnifyingGlass,
                        size: Sizes.navBarIconSize)),
                if (loginManager.isLandlord)
                  CustomTabBarItem(
                      page: PropertiesPage(),
                      tab_widget: PropertiesTabBarItem()),
                CustomTabBarItem(
                    page: ConversationsPage(),
                    tab_widget: ConversationTabBarItem()),
                CustomTabBarItem(
                    page: ProfilePage(),
                    tab_widget: FaIcon(FontAwesomeIcons.user,
                        size: Sizes.navBarIconSize)),
              ],
            )
          : LoginRegisterPage(),
    );
  }
}
