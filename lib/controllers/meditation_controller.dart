import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:meditone/models/animation_model.dart';
import 'package:meditone/models/music_model.dart';

class MeditationController extends GetxController {
  // Audio player
  final AudioPlayer audioPlayer = AudioPlayer();

  // Selected animation and music
  final Rx<AnimationModel?> selectedAnimation = Rx<AnimationModel?>(null);
  final Rx<MusicModel?> selectedMusic = Rx<MusicModel?>(null);

  // Meditation state
  final RxBool isPlaying = false.obs;
  final RxBool isCompleted = false.obs;
  final RxDouble progress = 0.0.obs;
  final RxInt currentDuration = 0.obs;
  final RxInt totalDuration = 0.obs;
  final RxBool animationPaused = false.obs;

  @override
  void onInit() {
    super.onInit();

    // Listen to player state changes
    audioPlayer.playerStateStream.listen((state) {
      isPlaying.value = state.playing;
      if (state.processingState == ProcessingState.completed) {
        isCompleted.value = true;
        progress.value = 1.0;
        animationPaused.value = true;
      }
      update(); // Update UI when player state changes
    });

    // Listen to position changes
    audioPlayer.positionStream.listen((position) {
      currentDuration.value = position.inSeconds;
      if (totalDuration.value > 0) {
        progress.value = position.inSeconds / totalDuration.value;
      }
      update(); // Update UI when position changes
    });

    // Listen to duration changes
    audioPlayer.durationStream.listen((duration) {
      if (duration != null) {
        totalDuration.value = duration.inSeconds;
        update(); // Update UI when duration changes
      }
    });
  }

  // Set selected animation
  void setAnimation(AnimationModel animation) {
    // Force update by setting to null first and then to the new value
    selectedAnimation.value = null;
    Future.delayed(const Duration(milliseconds: 50), () {
      selectedAnimation.value = animation;
      update(); // Force UI update
    });
  }

  // Set selected music
  void setMusic(MusicModel music) async {
    final wasPlaying = isPlaying.value;

    // If currently playing, pause first
    if (wasPlaying) {
      await audioPlayer.pause();
    }

    // Update the selected music
    selectedMusic.value = music;

    // Load the new music
    await audioPlayer.setAsset(music.path);
    totalDuration.value = (await audioPlayer.duration)?.inSeconds ?? 0;

    // If was playing before, resume with new music
    if (wasPlaying) {
      await audioPlayer.play();
    }

    update(); // Force UI update
  }

  // Start meditation
  void startMeditation() async {
    if (selectedMusic.value != null) {
      isPlaying.value = true;
      isCompleted.value = false;
      animationPaused.value = false;
      update(); // Update UI immediately

      await audioPlayer.play();
      update(); // Update UI after play starts
    }
  }

  // Pause meditation
  void pauseMeditation() async {
    await audioPlayer.pause();
    isPlaying.value = false;
    animationPaused.value = true;
    update(); // Force UI update
  }

  // Resume meditation
  void resumeMeditation() async {
    isPlaying.value = true;
    animationPaused.value = false;
    update(); // Update UI immediately

    await audioPlayer.play();
    update(); // Update UI after play starts
  }

  // Stop meditation
  void stopMeditation() async {
    await audioPlayer.stop();
    isPlaying.value = false;
    isCompleted.value = true;
    progress.value = 0.0;
    currentDuration.value = 0;
    animationPaused.value = true;

    // Reset position to beginning
    await audioPlayer.seek(Duration.zero);
    update(); // Force UI update
  }

  // Toggle play/pause
  void togglePlayPause() {
    if (isPlaying.value) {
      pauseMeditation();
    } else {
      resumeMeditation();
    }
  }

  // Format duration to mm:ss
  String formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void onClose() {
    audioPlayer.dispose();
    super.onClose();
  }
}
