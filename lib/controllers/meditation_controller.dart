import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:meditone/models/animation_model.dart';
import 'package:meditone/models/music_model.dart';
import 'package:meditone/controllers/premium_controller.dart';
import 'package:meditone/controllers/animation_controller.dart';
import 'package:meditone/controllers/music_controller.dart';
import 'package:meditone/utils/local_storage.dart';

class MeditationController extends GetxController {
  // Audio player
  final AudioPlayer audioPlayer = AudioPlayer();

  // Selected animation and music
  final Rx<AnimationModel> selectedAnimation = AnimationModel().obs;
  final Rx<MusicModel> selectedMusic = MusicModel().obs;

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
    });

    // Listen to position changes
    audioPlayer.positionStream.listen((position) {
      currentDuration.value = position.inSeconds;
      if (totalDuration.value > 0) {
        progress.value = position.inSeconds / totalDuration.value;
      }
    });

    // Listen to duration changes
    audioPlayer.durationStream.listen((duration) {
      if (duration != null) {
        totalDuration.value = duration.inSeconds;
      }
    });

    // Restore saved selections
    _restoreSavedSelections();
  }

  // Restore saved music and animation selections
  void _restoreSavedSelections() {
    final savedMusicId = LocalStorage.getSelectedMusicId();
    final savedAnimationId = LocalStorage.getSelectedAnimationId();

    final musicController = Get.find<MusicController>();
    if (savedMusicId != null) {
      final savedMusic = musicController.musicTracks.firstWhere(
        (music) => music.id == savedMusicId,
      );

      selectedMusic.value = savedMusic;
      setMusic(selectedMusic.value);
    } else {
      selectedMusic.value = musicController.musicTracks.first;
      setMusic(selectedMusic.value);
    }

    final animationsController = Get.find<AnimationsController>();
    if (savedAnimationId != null) {
      final savedAnimation = animationsController.animations.firstWhere(
        (animation) => animation.id == savedAnimationId,
      );

      selectedAnimation.value = savedAnimation;
      setAnimation(selectedAnimation.value);
    } else {
      selectedAnimation.value = animationsController.animations.first;
      setAnimation(selectedAnimation.value);
    }
  }

  // Set selected animation
  void setAnimation(AnimationModel animation) {
    final premiumController = Get.find<PremiumController>();

    // Check if this is a premium animation (not the first one) and user is not premium
    final animationsController = Get.find<AnimationsController>();
    final animationIndex = animationsController.animations.indexOf(animation);
    final isPremiumAnimation = animationIndex > 0;
    final isPremiumUser = premiumController.isPremium;

    if (isPremiumAnimation && !isPremiumUser) {
      // Redirect to premium screen for free users
      Get.toNamed('/premium');
      return;
    }

    // Save the selected animation
    LocalStorage.setSelectedAnimationId(animation.id ?? '');

    selectedAnimation.value = animation;
  }

  // Set selected music
  void setMusic(MusicModel music) async {
    final premiumController = Get.find<PremiumController>();

    // Check if this is a premium music (not the first one) and user is not premium
    final musicController = Get.find<MusicController>();
    final musicIndex = musicController.musicTracks.indexOf(music);
    final isPremiumMusic = musicIndex > 0;
    final isPremiumUser = premiumController.isPremium;

    if (isPremiumMusic && !isPremiumUser) {
      // Redirect to premium screen for free users
      Get.toNamed('/premium');
      return;
    }

    // Save the selected music
    LocalStorage.setSelectedMusicId(music.id ?? '');

    final wasPlaying = isPlaying.value;

    // If currently playing, pause first
    if (wasPlaying) {
      await audioPlayer.pause();
    }

    // Update the selected music
    selectedMusic.value = music;

    // Load the new music
    await audioPlayer.setAsset(music.path ?? '');
    // Duration will be updated via the durationStream listener

    // If was playing before, resume with new music
    if (wasPlaying) {
      await audioPlayer.play();
    }
  }

  // Start meditation
  void startMeditation() async {
    if (selectedMusic.value.id != null) {
      isPlaying.value = true;
      isCompleted.value = false;
      animationPaused.value = false;

      await audioPlayer.play();
    }
  }

  // Pause meditation
  void pauseMeditation() async {
    await audioPlayer.pause();
    isPlaying.value = false;
    animationPaused.value = true;
  }

  // Resume meditation
  void resumeMeditation() async {
    isPlaying.value = true;
    animationPaused.value = false;

    await audioPlayer.play();
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
    audioPlayer.seek(Duration.zero);
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
