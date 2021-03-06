import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samachar_hub/feature_news/presentation/blocs/news_category/follow_unfollow/follow_un_follow_bloc.dart';
import 'package:samachar_hub/feature_news/presentation/models/news_category.dart';
import 'package:samachar_hub/feature_news/presentation/ui/category/category_feed/widgets/news_category_feed_header.dart';
import 'package:samachar_hub/feature_news/presentation/ui/category/category_feed/widgets/news_category_feed_list.dart';
import 'package:samachar_hub/feature_news/presentation/ui/widgets/news_filter_appbar.dart';
import 'package:samachar_hub/feature_news/utils/provider.dart';
import 'package:scoped_model/scoped_model.dart';

class NewsCategoryFeedScreen extends StatelessWidget {
  static const String ROUTE_NAME = '/news-category-feed';
  const NewsCategoryFeedScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final NewsCategoryUIModel newsCategoryUIModel =
        ModalRoute.of(context).settings.arguments;
    return NewsProvider.categoryFeedBlocProvider(
      newsCategoryUIModel: newsCategoryUIModel,
      child: ScopedModel<NewsCategoryUIModel>(
        model: newsCategoryUIModel,
        child: Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          body: SafeArea(
            child: BlocListener<CategoryFollowUnFollowBloc,
                CategoryFollowUnFollowState>(
              listener: (context, state) {
                if (state is CategoryFollowSuccessState) {
                  ScopedModel.of<NewsCategoryUIModel>(context).entity =
                      state.category;
                } else if (state is CategoryUnFollowSuccessState) {
                  ScopedModel.of<NewsCategoryUIModel>(context).entity =
                      state.category;
                }
              },
              child: NewsFilteringAppBar(
                header: const NewsCategoryFeedHeader(),
                body: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: const NewsCategoryFeedList(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
