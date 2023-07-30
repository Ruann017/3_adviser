import 'package:adviser/1_domain/entities/advice_entity.dart';
import 'package:adviser/1_domain/failures/failures.dart';
import 'package:adviser/1_domain/usecases/advice_usecases.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'adviser_state.dart';

const generalFailureMessage = 'Unexpected Error';
const serverFailureMessage = 'Opps! Server Failure!';
const cacheFailureMessage = 'Opps! Cache Failure!';

class AdviserCubit extends Cubit<AdviserCubitState> {
  final AdviceUseCases adviceUseCases;
  AdviserCubit({required this.adviceUseCases}) : super(AdviserInitial());

  void adviceRequestedEvent() async {
    emit(AdviserStateLoading());
    final failureOrAdvice = await adviceUseCases.getAdvice();
    failureOrAdvice.fold(
      (failure) => emit(AdviserStateError(message: _mapFailureToMessage(failure))),
      (advice) => emit(AdviserStateLoaded(advice: advice.advice)),
    );
    // emit(AdviserStateError(message: 'fake error to test bloc!'));
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return serverFailureMessage;
      case CacheFailure:
        return cacheFailureMessage;
      default:
        return generalFailureMessage;
    }
  }

}
