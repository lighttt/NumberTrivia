import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/error/exceptions.dart';
import 'package:number_trivia/core/error/failures.dart';
import 'package:number_trivia/core/platform/network_info.dart';
import 'package:number_trivia/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:number_trivia/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:number_trivia/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';

/// Create each test for the data sources and network info

class MockRemoteDataSource extends Mock
    implements NumberTriviaRemoteDataSource {}

class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  /// Getting instances for each
  NumberTriviaRepositoryImpl repositoryImpl;
  MockRemoteDataSource mockRemoteDataSource;
  MockLocalDataSource mockLocalDataSource;
  MockNetworkInfo mockNetworkInfo;

  // Setting up the instance with repository implementation
  setUp(() {
    mockLocalDataSource = MockLocalDataSource();
    mockRemoteDataSource = MockRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repositoryImpl = NumberTriviaRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  void runTestOnline(Function body) {
    group('device is online', () {
      //always return true if device on
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });
      body();
    });
  }

  void runTestOffline(Function body) {
    group('device is offline', () {
      //always return true if device on
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });
      body();
    });
  }

  /// ========================================== GROUP CONCRETE : CHECK NETWORK ==========================================
  /// group test the data got from the api
  /// first test where network is connected
  group('getConcreteNumberTrivia', () {
    //vars for testing
    final tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel(number: tNumber, text: "Test Trivia");
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;

    // test the network info
    test(
      'should check if the device is online',
      () async {
        // arrange
        // first always return true is connected is called
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        // act
        // call the concerete method which for now calls network info
        repositoryImpl.getConcreteNumberTrivia(tNumber);
        // assert
        //then verify
        verify(mockNetworkInfo.isConnected);
      },
    );

    /// ========================================== GROUP ONLINE ==========================================
    /// second test when network is online
    runTestOnline(() {
      /// ========================================== REMOTE DATA ==========================================
      // return the remote data source if the network is on
      test(
        'should return remote data when call to remote data source is successful',
        () async {
          // arrange
          // call the method with any number
          when(mockRemoteDataSource.getConcreteNumberTrivia(any))
              .thenAnswer((_) async => tNumberTriviaModel);
          // act
          // call repository to get the data
          final result = await repositoryImpl.getConcreteNumberTrivia(tNumber);
          // assert
          // check if the data source is called with the same number
          verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
          // expect the data return to have the actual entity
          expect(result, equals(Right(tNumberTrivia)));
        },
      );

      // cache the remote data source if the network is on
      test(
        'should cache data locally when call to remote data source is successful',
        () async {
          // arrange
          // call the method with any number
          when(mockRemoteDataSource.getConcreteNumberTrivia(any))
              .thenAnswer((_) async => tNumberTriviaModel);
          // act
          // call repository to get the data
          final result = await repositoryImpl.getConcreteNumberTrivia(tNumber);
          // assert
          // check if the data source is called with the same number
          verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
          // verify the local data source is called to save data
          verify(mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
        },
      );

      // check if the server failure is returned or not and no data is cached
      test(
        'should return server failure when call to remote data source is unsuccessful',
        () async {
          // arrange
          // call the method with any number
          when(mockRemoteDataSource.getConcreteNumberTrivia(any))
              .thenThrow(ServerException());
          // act
          // call repository to get the data
          final result = await repositoryImpl.getConcreteNumberTrivia(tNumber);
          // assert
          // check if the data source is called with the same number
          verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
          //also make sure nothing caches if server fails
          verifyZeroInteractions(mockLocalDataSource);
          // expect the data return to have the failure
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });

    /// ========================================== GROUP OFFLINE ==========================================
    /// third test when network is offline
    runTestOffline(() {
      /// ========================================== LOCAL DATA ==========================================
      // test if the cache data returns value or not
      test(
        'should return last locally cached data when the cached data is present',
        () async {
          // arrange
          // get the last number trivia
          when(mockLocalDataSource.getLastNumberTrivia())
              .thenAnswer((_) async => tNumberTriviaModel);
          // act
          // call repository to get the data
          final result = await repositoryImpl.getConcreteNumberTrivia(tNumber);
          // assert
          // check if there is no interaction with the remote data source
          verifyZeroInteractions(mockRemoteDataSource);
          // check if the local data source is called once
          verify(mockLocalDataSource.getLastNumberTrivia());
          // expect to return the cache entity
          expect(result, equals(Right(tNumberTrivia)));
        },
      );

      // test if the cache data returns exception
      test(
        'should return CacheFailure when there is no cached data present',
        () async {
          // arrange
          // get the last number trivia
          when(mockLocalDataSource.getLastNumberTrivia())
              .thenThrow(CacheException());
          // act
          // call repository to get the data
          final result = await repositoryImpl.getConcreteNumberTrivia(tNumber);
          // assert
          // check if there is no interaction with the remote data source
          verifyZeroInteractions(mockRemoteDataSource);
          // check if the local data source is called once
          verify(mockLocalDataSource.getLastNumberTrivia());
          // expect to return the cache entity
          expect(result, equals(Left(CacheFailure())));
        },
      );
    });
  });

  /// ========================================== GROUP RANDOM : CHECK NETWORK ==========================================
  /// group test the data got from the api
  /// first test where network is connected
  group('getRandomNumberTrivia', () {
    //vars for testing
    final tNumberTriviaModel =
        NumberTriviaModel(number: 123, text: "Test Trivia");
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;

    // test the network info
    test(
      'should check if the device is online',
      () async {
        // arrange
        // first always return true is connected is called
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        // act
        // call the concerete method which for now calls network info
        repositoryImpl.getRandomNumberTrivia();
        // assert
        //then verify
        verify(mockNetworkInfo.isConnected);
      },
    );

    /// ========================================== GROUP ONLINE ==========================================
    /// second test when network is online
    runTestOnline(() {
      /// ========================================== REMOTE DATA ==========================================
      // return the remote data source if the network is on
      test(
        'should return remote data when call to remote data source is successful',
        () async {
          // arrange
          // call the method with any number
          when(mockRemoteDataSource.getRandomNumberTrivia())
              .thenAnswer((_) async => tNumberTriviaModel);
          // act
          // call repository to get the data
          final result = await repositoryImpl.getRandomNumberTrivia();
          // assert
          // check if the data source is called with the same number
          verify(mockRemoteDataSource.getRandomNumberTrivia());
          // expect the data return to have the actual entity
          expect(result, equals(Right(tNumberTrivia)));
        },
      );

      // cache the remote data source if the network is on
      test(
        'should cache data locally when call to remote data source is successful',
        () async {
          // arrange
          // call the method with any number
          when(mockRemoteDataSource.getRandomNumberTrivia())
              .thenAnswer((_) async => tNumberTriviaModel);
          // act
          // call repository to get the data
          final result = await repositoryImpl.getRandomNumberTrivia();
          // assert
          // check if the data source is called with the same number
          verify(mockRemoteDataSource.getRandomNumberTrivia());
          // verify the local data source is called to save data
          verify(mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
        },
      );

      // check if the server failure is returned or not and no data is cached
      test(
        'should return server failure when call to remote data source is unsuccessful',
        () async {
          // arrange
          // call the method with any number
          when(mockRemoteDataSource.getRandomNumberTrivia())
              .thenThrow(ServerException());
          // act
          // call repository to get the data
          final result = await repositoryImpl.getRandomNumberTrivia();
          // assert
          // check if the data source is called with the same number
          verify(mockRemoteDataSource.getRandomNumberTrivia());
          //also make sure nothing caches if server fails
          verifyZeroInteractions(mockLocalDataSource);
          // expect the data return to have the failure
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });

    /// ========================================== GROUP OFFLINE ==========================================
    /// third test when network is offline
    runTestOffline(() {
      /// ========================================== LOCAL DATA ==========================================
      // test if the cache data returns value or not
      test(
        'should return last locally cached data when the cached data is present',
        () async {
          // arrange
          // get the last number trivia
          when(mockLocalDataSource.getLastNumberTrivia())
              .thenAnswer((_) async => tNumberTriviaModel);
          // act
          // call repository to get the data
          final result = await repositoryImpl.getRandomNumberTrivia();
          // assert
          // check if there is no interaction with the remote data source
          verifyZeroInteractions(mockRemoteDataSource);
          // check if the local data source is called once
          verify(mockLocalDataSource.getLastNumberTrivia());
          // expect to return the cache entity
          expect(result, equals(Right(tNumberTrivia)));
        },
      );

      // test if the cache data returns exception
      test(
        'should return CacheFailure when there is no cached data present',
        () async {
          // arrange
          // get the last number trivia
          when(mockLocalDataSource.getLastNumberTrivia())
              .thenThrow(CacheException());
          // act
          // call repository to get the data
          final result = await repositoryImpl.getRandomNumberTrivia();
          // assert
          // check if there is no interaction with the remote data source
          verifyZeroInteractions(mockRemoteDataSource);
          // check if the local data source is called once
          verify(mockLocalDataSource.getLastNumberTrivia());
          // expect to return the cache entity
          expect(result, equals(Left(CacheFailure())));
        },
      );
    });
  });
}
