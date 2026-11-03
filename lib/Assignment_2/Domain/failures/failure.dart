abstract class Failure {
  final String message;
  const Failure(this.message);
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'server error occurred. please try again.']); //jab server fail ho
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'no internet connection. please check your network.']); //jab mertwork fail ho widi nahi araha
}