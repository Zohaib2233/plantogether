
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseConsts{
  static FirebaseAuth auth = FirebaseAuth.instance;
  static User? user = FirebaseAuth.instance.currentUser;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static String userCollection = 'users';
  static String tripsCollection = 'trips';
  static String placesCollection = 'places';
  static String daysCollection = 'days';
  static String itemsCollection = 'items';
  static String chatRoomsCollection = 'chatRooms';
  static String messagesCollection = 'messages';

  static String postsCollection = 'posts';
  static String personalBudgetCollection = 'personal_budget';
  static String groupBudgetCollection = 'group_budget';
  static String totalBudgetCollection = 'total_budget';
  static String totalExpensesCollection = 'total_expenses';
  static String phoneNumbersCollection = 'phoneNumbers';
  static String addDocumentCollection = 'documents';
  static String commentsCollection = 'comments';



}