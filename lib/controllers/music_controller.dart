import 'package:get/get.dart';
import 'package:meditone/models/music_model.dart';

class MusicController extends GetxController {
  final RxList<MusicModel> musicTracks = <MusicModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadMusicTracks();
  }

  void loadMusicTracks() {
    // Load music tracks from assets
    musicTracks.assignAll([
      MusicModel(
        id: '1',
        name: 'Tranquil Forest',
        path: 'assets/music/meditation-music-1.mp3',
        duration: '5:30',
        description: 'Peaceful forest sounds with gentle piano',
      ),
      MusicModel(
        id: '2',
        name: 'Ocean Waves',
        path: 'assets/music/meditation-music-2.mp3',
        duration: '6:15',
        description: 'Calming ocean waves with ambient sounds',
      ),
      MusicModel(
        id: '3',
        name: 'Zen Garden',
        path: 'assets/music/meditation-music-3.mp3',
        duration: '4:45',
        description: 'Traditional Japanese instruments with water sounds',
      ),
      MusicModel(
        id: '4',
        name: 'Deep Meditation',
        path: 'assets/music/meditation-music-4.mp3',
        duration: '7:20',
        description: 'Deep resonant bowls and ambient tones',
      ),
    ]);
  }
}
