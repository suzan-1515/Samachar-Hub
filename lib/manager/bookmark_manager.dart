import 'package:flutter/material.dart';
import 'package:samachar_hub/data/feed_activity_event.dart';
import 'package:samachar_hub/manager/feed_activity_manager.dart';

class BookmarkManager extends FeedActivityManager {
  BookmarkManager(
      {@required authenticationManager,
      @required analyticsService,
      @required activityService})
      : super(authenticationManager, analyticsService,
            activityService, FeedActivityEvent.Bookmark);
}
