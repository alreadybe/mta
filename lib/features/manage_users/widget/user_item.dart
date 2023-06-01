import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mta_app/core/theme/colors.dart';
import 'package:mta_app/core/theme/styles.dart';
import 'package:mta_app/features/manage_users/bloc/manage_users_bloc.dart';
import 'package:mta_app/models/user_model.dart';
import 'package:mta_app/models/user_type_model.dart';

class UserItem extends StatefulWidget {
  final UserModel user;
  const UserItem({required this.user, super.key});

  @override
  State<UserItem> createState() => _UserItemState();
}

class _UserItemState extends State<UserItem> {
  late bool isAdmin;
  late bool isOrg;
  late bool isPlayer;
  late bool isUnapproved;

  late ManageUsersBloc _regRequestBloc;

  @override
  void initState() {
    isAdmin = widget.user.userType.contains(UserType.ADMIN);
    isOrg = widget.user.userType.contains(UserType.ORG);
    isPlayer = widget.user.userType.contains(UserType.PLAYER);
    isUnapproved = widget.user.userType.contains(UserType.WAITING_APPROVE);

    _regRequestBloc = context.read();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ManageUsersBloc, ManageUsersState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(5.0),
          child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.lightDark),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          '${widget.user.firstname} ${widget.user.nickname ?? ""} ${widget.user.lastname}',
                          style: AppStyles.textStyle.copyWith(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text('ELO: ${widget.user.elo}',
                            style: AppStyles.textStyle.copyWith(fontSize: 15)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Wrap(
                          direction: Axis.vertical,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: -10,
                          children: [
                            Checkbox(
                              side: BorderSide(color: AppColors.white),
                              checkColor: AppColors.cyan,
                              activeColor: AppColors.lightDark,
                              value: isAdmin,
                              onChanged: (value) {
                                setState(() {
                                  isAdmin = value ?? false;
                                  _regRequestBloc.add(
                                      ManageUsersEvent.changeStatus(
                                          user: widget.user,
                                          newStatus: [
                                        if (isAdmin) UserType.ADMIN,
                                        if (isOrg) UserType.ORG,
                                        if (isPlayer) UserType.PLAYER,
                                        if (isUnapproved)
                                          UserType.WAITING_APPROVE
                                      ]));
                                });
                              },
                            ),
                            Text('Admin', style: AppStyles.textStyle),
                          ],
                        ),
                        Wrap(
                          direction: Axis.vertical,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: -10,
                          children: [
                            Checkbox(
                              side: BorderSide(color: AppColors.white),
                              checkColor: AppColors.cyan,
                              activeColor: AppColors.lightDark,
                              value: isOrg,
                              onChanged: (value) {
                                setState(() {
                                  isOrg = value ?? false;
                                  _regRequestBloc.add(
                                      ManageUsersEvent.changeStatus(
                                          user: widget.user,
                                          newStatus: [
                                        if (isAdmin) UserType.ADMIN,
                                        if (isOrg) UserType.ORG,
                                        if (isPlayer) UserType.PLAYER,
                                        if (isUnapproved)
                                          UserType.WAITING_APPROVE
                                      ]));
                                });
                              },
                            ),
                            Text('Org', style: AppStyles.textStyle),
                          ],
                        ),
                        Wrap(
                          direction: Axis.vertical,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: -10,
                          children: [
                            Checkbox(
                              side: BorderSide(color: AppColors.white),
                              checkColor: AppColors.cyan,
                              activeColor: AppColors.lightDark,
                              value: isPlayer,
                              onChanged: (value) {
                                setState(() {
                                  isPlayer = value ?? false;
                                  _regRequestBloc.add(
                                      ManageUsersEvent.changeStatus(
                                          user: widget.user,
                                          newStatus: [
                                        if (isAdmin) UserType.ADMIN,
                                        if (isOrg) UserType.ORG,
                                        if (isPlayer) UserType.PLAYER,
                                        if (isUnapproved)
                                          UserType.WAITING_APPROVE
                                      ]));
                                });
                              },
                            ),
                            Text('Player', style: AppStyles.textStyle),
                          ],
                        ),
                        Wrap(
                          direction: Axis.vertical,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: -10,
                          children: [
                            Checkbox(
                              side: BorderSide(color: AppColors.white),
                              checkColor: AppColors.cyan,
                              activeColor: AppColors.lightDark,
                              value: isUnapproved,
                              onChanged: (value) {
                                setState(() {
                                  isUnapproved = value ?? false;
                                  _regRequestBloc.add(
                                      ManageUsersEvent.changeStatus(
                                          user: widget.user,
                                          newStatus: [
                                        if (isAdmin) UserType.ADMIN,
                                        if (isOrg) UserType.ORG,
                                        if (isPlayer) UserType.PLAYER,
                                        if (isUnapproved)
                                          UserType.WAITING_APPROVE
                                      ]));
                                });
                              },
                            ),
                            Text('Unapproved', style: AppStyles.textStyle),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              )),
        );
      },
    );
  }
}
