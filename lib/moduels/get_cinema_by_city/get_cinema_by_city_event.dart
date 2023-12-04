
abstract class GetCinemaEvent{}

class GetCinemasByCityEvent extends GetCinemaEvent{
  String cityName;

  GetCinemasByCityEvent({required this.cityName});
}