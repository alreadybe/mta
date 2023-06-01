import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mta_app/core/theme/colors.dart';
import 'package:mta_app/core/theme/styles.dart';
import 'package:mta_app/features/manage_users/bloc/manage_users_bloc.dart';
import 'package:mta_app/features/manage_users/widget/user_item.dart';

class ManageUsersPage extends StatefulWidget {
  static const routeName = 'manage_users';

  const ManageUsersPage({super.key});

  @override
  State<ManageUsersPage> createState() => _ManageUsersPageState();
}

class _ManageUsersPageState extends State<ManageUsersPage> {
  late ManageUsersBloc _manageUsersBloc;

  late TextEditingController _searchController;

  late bool isSearch;

  @override
  void initState() {
    isSearch = false;
    _searchController = TextEditingController();
    _manageUsersBloc = context.read();
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ManageUsersBloc, ManageUsersState>(
      listener: (context, state) {},
      builder: (context, state) {
        state.mapOrNull(
          initial: (value) => _manageUsersBloc.add(ManageUsersEvent.getData()),
        );
        return state.maybeMap(
            loaded: (value) => GestureDetector(
                  onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                  child: Scaffold(
                    backgroundColor: AppColors.dark,
                    appBar: AppBar(
                      backgroundColor: AppColors.lightDark,
                      actions: [
                        if (isSearch)
                          const SizedBox()
                        else
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  isSearch = true;
                                });
                              },
                              icon: Icon(
                                Icons.search,
                                color: AppColors.cyan,
                              ))
                      ],
                      title: isSearch
                          ? Center(
                              child: TextField(
                                style: AppStyles.textStyle,
                                cursorColor: AppColors.cyan,
                                controller: _searchController,
                                onChanged: (newValue) => _manageUsersBloc.add(
                                    ManageUsersEvent.getData(
                                        name: _searchController.text)),
                                decoration: InputDecoration(
                                    hintStyle: AppStyles.textStyle
                                        .copyWith(color: AppColors.dark),
                                    suffixIcon: IconButton(
                                        icon: Icon(
                                          Icons.clear,
                                          color: AppColors.cyan,
                                        ),
                                        onPressed: () {
                                          _searchController.clear();
                                          setState(() {
                                            isSearch = false;
                                          });
                                          _manageUsersBloc
                                              .add(ManageUsersEvent.getData());
                                        }),
                                    hintText: 'Поиск...',
                                    border: InputBorder.none),
                              ),
                            )
                          : Text(
                              'Manage users',
                              style: AppStyles.textStyle
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                    ),
                    body: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: state.mapOrNull(
                              loaded: (value) => ListView.builder(
                                itemCount: value.users.length,
                                itemBuilder: (context, index) => Padding(
                                  padding: const EdgeInsets.only(bottom: 5),
                                  child: UserItem(
                                    user: value.users[index],
                                  ),
                                ),
                              ),
                            ) ??
                            Center(
                                child: CircularProgressIndicator(
                              color: AppColors.red,
                            ))),
                  ),
                ),
            orElse: () => ColoredBox(
                  color: AppColors.dark,
                  child: Center(
                    child: CircularProgressIndicator(color: AppColors.red),
                  ),
                ));
      },
    );
  }
}
