part of 'follow_un_follow_bloc.dart';

abstract class FollowUnFollowEvent extends Equatable {
  const FollowUnFollowEvent();
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class FollowUnFollowFollowEvent extends FollowUnFollowEvent {}

class FollowUnFollowUnFollowEvent extends FollowUnFollowEvent {}