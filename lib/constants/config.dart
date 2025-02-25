class Config {
// ignore: non_constant_identifier_names
  static const String API_BASE_URL = 'https://god-did.de/v1';
  static const String LANDLORD_TEAM_ID = '67a6333d562e8cfa48bd';
  static const String PROJECT_ID = '6780ee1a896fed0b8da7';
  static const String DB_ID = '6780faa636107ddbb899';

  //these are only valid for property objects/files
  static const String PROPERTY_COLLECTION_ID = '6780fb97607609a113df';
  static const String IMAGE_BUCKET_ID = '67a5d2f8f0ec7c4b941c';
  //this is only valid for booking objects
  static const String BOOKING_COLLECTION_ID = '67a4f2cd96ff4e22d5f6';
  //this is only valid for message objects
  static const String MESSAGE_COLLECTION_ID = '67bc7759468571ae5750';

  //Note: Obviously, storing API Keys in the frontend is incredibly stupid and a smarter solution should be found to achieve the upgrade functionality.
  //This key only grants permission to create team memberships.
  static const String LANDLORD_UPGRADE_API_KEY =
      'd8f2582ac8444cc75531d743a6d71f19d5f437bb6247cfe8b93f613e74353bf2831815a574f01857192d92896e2823030f49cef029369ee0f1879317990d4e1619a235368c650e5424ae3f901b36bfff5b683c75d22f2464df9fbea0c325786f847638e0134ae42f88023ba63c18ec790f1b1e11d05681933c6e9e6f96fc3401';
}
