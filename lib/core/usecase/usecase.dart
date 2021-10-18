abstract class UseCase<Type, Param> {
  Future<Type> call(Param param);
}

class NoParam {}
