import 'package:ecommerce_app/services/favorite_service.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import './utils/libs.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  final spref = await SharedPreferences.getInstance();
  String? uid = spref.getString('uid');
  runApp(EcommerceApp(uid: uid));
}

class EcommerceApp extends StatelessWidget {
  EcommerceApp({Key? key, this.uid}) : super(key: key);
  final String? uid;

  final SignService service = SignServiceIml(
    userRepo: UserRepository(),
    cartRepo: CartRepository(),
    favoriteRepo: FavoriteRepository(),
    historyRepo: HistoryRepository(),
    orderRepo: OrderRepository(),
  );

  final cartCubit = CartCubit(
    service: CartServiceIml(CartRepository(), ProductRepository()),
  );

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => HomeCubit(
            homeService: HomeServiceIml(),
            cartCubit: cartCubit,
            favoriteService: FavoriteServiceIml(
              FavoriteRepository(),
              ProductRepository(),
            ),
          ),
        ),
        BlocProvider(create: (_) => SignInCubit(service: service)),
        BlocProvider(create: (_) => SignUpCubit(service: service)),
        BlocProvider(create: (_) => cartCubit),
        BlocProvider(create: (_) => ForgetPasswordCubit())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: uid == null ? const SignInPage() : const HomePage(),
      ),
    );
  }
}
