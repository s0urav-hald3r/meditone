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
        description: 'Peaceful forest sounds with gentle piano',
      ),
      MusicModel(
        id: '2',
        name: 'Ocean Waves',
        path: 'assets/music/meditation-music-2.mp3',
        description: 'Calming ocean waves with ambient sounds',
      ),
      MusicModel(
        id: '3',
        name: 'Zen Garden',
        path: 'assets/music/meditation-music-3.mp3',
        description: 'Traditional Japanese instruments with water sounds',
      ),
      MusicModel(
        id: '4',
        name: 'Deep Meditation',
        path: 'assets/music/meditation-music-4.mp3',
        description: 'Deep resonant bowls and ambient tones',
      ),
      MusicModel(
        id: '5',
        name: 'Mountain Breeze',
        path: 'assets/music/meditation-music-5.mp3',
        description: 'Fresh mountain air with wind chimes',
      ),
      MusicModel(
        id: '6',
        name: 'Celestial Harmony',
        path: 'assets/music/meditation-music-6.mp3',
        description: 'Ethereal sounds with cosmic frequencies',
      ),
      MusicModel(
        id: '7',
        name: 'Gentle Rain',
        path: 'assets/music/meditation-music-7.mp3',
        description: 'Soft rain drops with distant thunder',
      ),
      MusicModel(
        id: '8',
        name: 'Sacred Space',
        path: 'assets/music/meditation-music-8.mp3',
        description: 'Sacred chants with temple bells',
      ),
      MusicModel(
        id: '9',
        name: 'Inner Peace',
        path: 'assets/music/meditation-music-9.mp3',
        description: 'Deep breathing with nature sounds',
      ),
    ]);
  }
}
