import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'platform_utils.dart';

/// Provides platform-adaptive icons for consistent UI across iOS and Android
class AdaptiveIcons {
  // Navigation icons
  static IconData get home => PlatformUtils.isIOS ? CupertinoIcons.house : Icons.home_outlined;
  static IconData get homeActive => PlatformUtils.isIOS ? CupertinoIcons.house_fill : Icons.home;
  
  static IconData get groups => PlatformUtils.isIOS ? CupertinoIcons.group : Icons.groups_outlined;
  static IconData get groupsActive => PlatformUtils.isIOS ? CupertinoIcons.group_solid : Icons.groups;
  
  static IconData get add => PlatformUtils.isIOS ? CupertinoIcons.add_circled : Icons.add_circle_outline;
  static IconData get addActive => PlatformUtils.isIOS ? CupertinoIcons.add_circled_solid : Icons.add_circle;
  
  static IconData get notifications => PlatformUtils.isIOS ? CupertinoIcons.bell : Icons.notifications_outlined;
  static IconData get notificationsActive => PlatformUtils.isIOS ? CupertinoIcons.bell_solid : Icons.notifications;
  
  static IconData get person => PlatformUtils.isIOS ? CupertinoIcons.person : Icons.person_outline;
  static IconData get personActive => PlatformUtils.isIOS ? CupertinoIcons.person_solid : Icons.person;
  
  // Action icons
  static IconData get heart => PlatformUtils.isIOS ? CupertinoIcons.heart : Icons.favorite_border;
  static IconData get heartFilled => PlatformUtils.isIOS ? CupertinoIcons.heart_solid : Icons.favorite;
  
  static IconData get comment => PlatformUtils.isIOS ? CupertinoIcons.chat_bubble : Icons.chat_bubble_outline;
  static IconData get commentFilled => PlatformUtils.isIOS ? CupertinoIcons.chat_bubble_fill : Icons.chat_bubble;
  
  static IconData get share => PlatformUtils.isIOS ? CupertinoIcons.share : Icons.share_outlined;
  
  // Privacy/Visibility icons
  static IconData get lock => PlatformUtils.isIOS ? CupertinoIcons.lock_shield : Icons.lock;
  static IconData get lockFilled => PlatformUtils.isIOS ? CupertinoIcons.lock_shield_fill : Icons.lock;
  
  static IconData get public => PlatformUtils.isIOS ? CupertinoIcons.globe : Icons.public;
  
  // UI icons
  static IconData get close => PlatformUtils.isIOS ? CupertinoIcons.xmark : Icons.close;
  static IconData get menu => PlatformUtils.isIOS ? CupertinoIcons.line_horizontal_3 : Icons.more_vert;
  static IconData get image => PlatformUtils.isIOS ? CupertinoIcons.photo : Icons.image;
  
  // Additional modern icons
  static IconData get search => PlatformUtils.isIOS ? CupertinoIcons.search : Icons.search;
  static IconData get settings => PlatformUtils.isIOS ? CupertinoIcons.settings : Icons.settings;
  static IconData get edit => PlatformUtils.isIOS ? CupertinoIcons.pencil : Icons.edit_outlined;
  static IconData get delete => PlatformUtils.isIOS ? CupertinoIcons.delete : Icons.delete_outline;
  static IconData get send => PlatformUtils.isIOS ? CupertinoIcons.paperplane : Icons.send;
  static IconData get bookmark => PlatformUtils.isIOS ? CupertinoIcons.bookmark : Icons.bookmark_outline;
  static IconData get bookmarkFilled => PlatformUtils.isIOS ? CupertinoIcons.bookmark_fill : Icons.bookmark;
  static IconData get star => PlatformUtils.isIOS ? CupertinoIcons.star : Icons.star_outline;
  static IconData get starFilled => PlatformUtils.isIOS ? CupertinoIcons.star_fill : Icons.star;
  static IconData get check => PlatformUtils.isIOS ? CupertinoIcons.check_mark : Icons.check;
  static IconData get checkCircle => PlatformUtils.isIOS ? CupertinoIcons.check_mark_circled : Icons.check_circle_outline;
  static IconData get checkCircleFilled => PlatformUtils.isIOS ? CupertinoIcons.check_mark_circled_solid : Icons.check_circle;
  
  // Community/Category icons
  static IconData get academic => PlatformUtils.isIOS ? CupertinoIcons.book : Icons.school_outlined;
  static IconData get relationship => PlatformUtils.isIOS ? CupertinoIcons.heart : Icons.favorite_outline;
  static IconData get mentalHealth => PlatformUtils.isIOS ? CupertinoIcons.heart : Icons.psychology_outlined;
  static IconData get socialLife => PlatformUtils.isIOS ? CupertinoIcons.person_2 : Icons.people_outline;
  static IconData get dormLife => PlatformUtils.isIOS ? CupertinoIcons.house : Icons.home_outlined;
  static IconData get career => PlatformUtils.isIOS ? CupertinoIcons.briefcase : Icons.work_outline;
  static IconData get family => PlatformUtils.isIOS ? CupertinoIcons.house_alt : Icons.family_restroom;
  static IconData get financial => PlatformUtils.isIOS ? CupertinoIcons.money_dollar_circle : Icons.attach_money;
  static IconData get growth => PlatformUtils.isIOS ? CupertinoIcons.arrow_up_right : Icons.trending_up;
}