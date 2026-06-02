import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/database/app_database.dart';
import 'core/network/dio_client.dart';
import 'features/car_recommendation/data/datasources/car_local_data_source.dart';
import 'features/car_recommendation/data/datasources/car_remote_data_source.dart';
import 'features/car_recommendation/data/repositories/car_repository_impl.dart';
import 'features/car_recommendation/domain/usecases/evaluate_car_usecase.dart';
import 'features/car_recommendation/domain/usecases/get_cars_usecase.dart';
import 'features/car_recommendation/domain/usecases/get_favorites_usecase.dart';
import 'features/car_recommendation/domain/usecases/get_history_usecase.dart';
import 'features/car_recommendation/domain/usecases/get_recommendations_usecase.dart';
import 'features/car_recommendation/domain/usecases/remove_favorite_usecase.dart';
import 'features/car_recommendation/domain/usecases/remove_history_usecase.dart';
import 'features/car_recommendation/domain/usecases/save_favorite_usecase.dart';
import 'features/car_recommendation/domain/usecases/save_history_usecase.dart';
import 'features/car_recommendation/presentation/cubit/car_cubit.dart';
import 'features/car_recommendation/presentation/cubit/favorites_cubit.dart';
import 'features/car_recommendation/presentation/cubit/history_cubit.dart';
import 'features/car_recommendation/presentation/cubit/stats_cubit.dart';
import 'features/car_recommendation/presentation/pages/favorites_page.dart';
import 'features/car_recommendation/presentation/pages/history_page.dart';
import 'features/car_recommendation/presentation/pages/home_page.dart';
import 'features/car_recommendation/presentation/pages/recommendations_page.dart';
import 'features/car_recommendation/presentation/pages/stats_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final dioClient = DioClient();
  final database = AppDatabase();
  final remoteDataSource = CarRemoteDataSource(dioClient.dio);
  final localDataSource = CarLocalDataSource(database);
  final repository = CarRepositoryImpl(remoteDataSource, localDataSource);

  runApp(
    RecomendadorAutosApp(
      carCubit: CarCubit(
        getCarsUseCase: GetCarsUseCase(repository),
        evaluateCarUseCase: EvaluateCarUseCase(repository),
        getRecommendationsUseCase: GetRecommendationsUseCase(repository),
      ),
      historyCubit: HistoryCubit(
        getHistoryUseCase: GetHistoryUseCase(repository),
        saveHistoryUseCase: SaveHistoryUseCase(repository),
        removeHistoryUseCase: RemoveHistoryUseCase(repository),
      )..loadHistory(),
      favoritesCubit: FavoritesCubit(
        getFavoritesUseCase: GetFavoritesUseCase(repository),
        saveFavoriteUseCase: SaveFavoriteUseCase(repository),
        removeFavoriteUseCase: RemoveFavoriteUseCase(repository),
      )..loadFavorites(),
      statsCubit: StatsCubit(getHistoryUseCase: GetHistoryUseCase(repository))
        ..loadStats(),
    ),
  );
}

class RecomendadorAutosApp extends StatelessWidget {
  const RecomendadorAutosApp({
    super.key,
    required this.carCubit,
    required this.historyCubit,
    required this.favoritesCubit,
    required this.statsCubit,
  });

  final CarCubit carCubit;
  final HistoryCubit historyCubit;
  final FavoritesCubit favoritesCubit;
  final StatsCubit statsCubit;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: carCubit),
        BlocProvider.value(value: historyCubit),
        BlocProvider.value(value: favoritesCubit),
        BlocProvider.value(value: statsCubit),
      ],
      child: MaterialApp(
        title: 'Recomendador de autos',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2F6FED)),
          scaffoldBackgroundColor: const Color(0xFFF4F7FB),
          cardTheme: const CardThemeData(
            color: Colors.white,
            elevation: 0,
            margin: EdgeInsets.zero,
          ),
          useMaterial3: true,
        ),
        home: const AppShell(),
      ),
    );
  }
}

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  static const _pages = [
    HomePage(),
    RecommendationsPage(),
    HistoryPage(),
    FavoritesPage(),
    StatsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recomendador de autos'),
        backgroundColor: Colors.white,
      ),
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.tune), label: 'Inicio'),
          NavigationDestination(
            icon: Icon(Icons.auto_awesome),
            label: 'Recomendaciones',
          ),
          NavigationDestination(icon: Icon(Icons.history), label: 'Historial'),
          NavigationDestination(icon: Icon(Icons.favorite), label: 'Favoritos'),
          NavigationDestination(
            icon: Icon(Icons.bar_chart),
            label: 'Estadísticas',
          ),
        ],
        onDestinationSelected: (value) => setState(() => _index = value),
      ),
    );
  }
}
