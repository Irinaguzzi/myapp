import 'package:myapp/domain/class.dart';
import 'package:myapp/screens/song_detail.dart';


// clase para pasar datos de song + modo juntos en el router
class SongDetailArgs {
  final Song? song;
  final SongDetailMode mode;


  SongDetailArgs({this.song, required this.mode});
}
