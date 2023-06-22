import 'package:auto_route/auto_route.dart';
import 'package:todo_app_firebase/features/login/pages/login_page.dart';
import 'package:todo_app_firebase/features/register/pages/register_page.dart';
import 'package:todo_app_firebase/features/todo/pages/todo_page.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: LoginRoute.page, initial: true),
        AutoRoute(page: RegisterRoute.page),
        AutoRoute(page: TodoRoute.page),
      ];
}
