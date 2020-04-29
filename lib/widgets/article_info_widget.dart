import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:samachar_hub/data/model/feed.dart';
import 'package:samachar_hub/store/bookmark_store.dart';

class DefaultFeedInfoWidget extends StatelessWidget {
  DefaultFeedInfoWidget(this.article);

  final Feed article;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        FeedSourceSection(article),
        SizedBox(height: 16),
        FeedTitleDescriptionSection(article),
        SizedBox(height: 8),
        Divider(),
        FeedOptionsSection(
          article: article,
        )
      ],
    );
  }
}

class FeedSourceSection extends StatelessWidget {
  final Feed article;

  const FeedSourceSection(this.article);

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(6),
              ),
            ),
            child: CachedNetworkImage(
              fit: BoxFit.cover,
              imageUrl: article.source?.getFavicon(),
              placeholder: (context, _) =>
                  Icon(FontAwesomeIcons.image, size: 28),
              errorWidget: (context, url, error) =>
                  Icon(FontAwesomeIcons.image, size: 28),
            ),
          ),
          SizedBox(
            width: 8,
            height: 8,
          ),
          RichText(
            text: TextSpan(
              text: article.formatedSource(),
              style: Theme.of(context)
                  .textTheme
                  .body1
                  .copyWith(fontWeight: FontWeight.w600),
              children: <TextSpan>[
                TextSpan(
                    text: '\n${article.formatedPublishedDate()}',
                    style: Theme.of(context).textTheme.display4)
              ],
            ),
          ),
          Spacer(),
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
                color: Colors.blueGrey,
                borderRadius: BorderRadius.all(Radius.circular(12))),
            child: Text(
              article.formatedCategory(),
              style: Theme.of(context)
                  .textTheme
                  .display4
                  .copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class FeedTitleDescriptionSection extends StatelessWidget {
  final Feed article;

  const FeedTitleDescriptionSection(this.article);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          article.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context)
              .textTheme
              .title
              .copyWith(fontWeight: FontWeight.w700),
        ),
        SizedBox(
          height: 8,
        ),
        Opacity(
          opacity: 0.9,
          child: Text(
            article.description ?? '',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.body1,
          ),
        ),
      ],
    );
  }
}

class FeedOptionsSection extends StatefulWidget {
  final Feed article;

  FeedOptionsSection({Key key, this.article}) : super(key: key);

  @override
  _FeedOptionsSectionState createState() => _FeedOptionsSectionState();
}

class _FeedOptionsSectionState extends State<FeedOptionsSection> {
  bool isBookmarked = false;
  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<BookmarkStore>(
      builder: (context, bookmarkStore, child) {
        return Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            IconButton(
              icon: Icon(
                isLiked ? FontAwesomeIcons.solidHeart : FontAwesomeIcons.heart,
                size: 16,
              ),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(
                FontAwesomeIcons.shareAlt,
                size: 16,
              ),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(
                FontAwesomeIcons.comment,
                size: 16,
              ),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(
                isBookmarked
                    ? FontAwesomeIcons.solidBookmark
                    : FontAwesomeIcons.bookmark,
                size: 16,
              ),
              onPressed: () async {
                setState(() {
                  isBookmarked = !isBookmarked;
                });
                await bookmarkStore
                    .toggleBookmark(feed: widget.article)
                    .then((onValue) => isBookmarked = onValue);
              },
            ),
            IconButton(
              icon: Icon(
                FontAwesomeIcons.ellipsisV,
              ),
              iconSize: 18,
              onPressed: () {},
            ),
          ],
        );
      },
    );
  }
}
