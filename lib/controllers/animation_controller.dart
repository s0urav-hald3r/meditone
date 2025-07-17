import 'package:get/get.dart';
import 'package:meditone/models/animation_model.dart';

class AnimationsController extends GetxController {
  final RxList<AnimationModel> animations = <AnimationModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadAnimations();
  }

  void loadAnimations() {
    // Load animations from assets
    animations.assignAll([
      AnimationModel(
        id: '1',
        name: 'Floating Lotus',
        path: 'assets/animation/animation-1.json',
        description: 'Calming lotus flower animation',
      ),
      AnimationModel(
        id: '2',
        name: 'Breathing Circle',
        path: 'assets/animation/animation-2.json',
        description: 'Breathing exercise animation',
      ),
      AnimationModel(
        id: '3',
        name: 'Peaceful Waves',
        path: 'assets/animation/animation-3.json',
        description: 'Ocean waves animation',
      ),
      AnimationModel(
        id: '4',
        name: 'Zen Garden',
        path: 'assets/animation/animation-4.json',
        description: 'Zen garden animation',
      ),
      AnimationModel(
        id: '5',
        name: 'Floating Particles',
        path: 'assets/animation/animation-5.json',
        description: 'Floating particles animation',
      ),
      AnimationModel(
        id: '6',
        name: 'Mindful Breathing',
        path: 'assets/animation/animation-6.json',
        description: 'Mindful breathing animation',
      ),
      AnimationModel(
        id: '7',
        name: 'Nature Flow',
        path: 'assets/animation/animation-7.json',
        description: 'Nature flow animation',
      ),
      AnimationModel(
        id: '8',
        name: 'Cosmic Energy',
        path: 'assets/animation/animation-8.json',
        description: 'Cosmic energy animation',
      ),
    ]);
  }
}
