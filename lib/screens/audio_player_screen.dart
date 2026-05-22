import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import '../data/audio_lessons.dart';
import '../utils/app_colors.dart';

class AudioPlayerScreen extends StatefulWidget {
  final String chapterTitle;
  final String chapterSubtitle;
  final List<AudioLesson> lessons;

  const AudioPlayerScreen({
    super.key,
    required this.chapterTitle,
    required this.chapterSubtitle,
    required this.lessons,
  });

  @override
  State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  final Map<int, AudioPlayer> _players = {};
  final Map<int, bool> _isPlaying = {};
  final Map<int, Duration> _durations = {};
  final Map<int, Duration> _positions = {};
  final Map<int, double> _speeds = {};

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.lessons.length; i++) {
      _setupPlayer(i);
    }
  }

  void _setupPlayer(int index) {
    final player = AudioPlayer();
    _players[index] = player;
    _isPlaying[index] = false;
    _durations[index] = Duration.zero;
    _positions[index] = Duration.zero;
    _speeds[index] = 1.0;

    final assetPath =
        widget.lessons[index].assetPath.replaceFirst('assets/', '');

    // Davomiylikni oldindan olish
    player.setSource(AssetSource(assetPath)).catchError((e) {
      debugPrint('Audio yuklashda xato (${widget.lessons[index].assetPath}): $e');
    });

    player.onDurationChanged.listen((d) {
      if (mounted) setState(() => _durations[index] = d);
    });

    player.onPositionChanged.listen((p) {
      if (mounted) setState(() => _positions[index] = p);
    });

    player.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() {
          _isPlaying[index] = false;
          _positions[index] = Duration.zero;
        });
      }
    });
  }

  Future<void> _togglePlay(int index) async {
    final player = _players[index];
    if (player == null) return;

    // Boshqa audiolarni to'xtatish
    for (final entry in _isPlaying.entries) {
      if (entry.key != index && entry.value) {
        await _players[entry.key]?.pause();
        if (mounted) setState(() => _isPlaying[entry.key] = false);
      }
    }

    if (_isPlaying[index] == true) {
      await player.pause();
      if (mounted) setState(() => _isPlaying[index] = false);
    } else {
      final assetPath =
          widget.lessons[index].assetPath.replaceFirst('assets/', '');
      await player.play(AssetSource(assetPath));
      await player.setPlaybackRate(_speeds[index] ?? 1.0);
      if (mounted) setState(() => _isPlaying[index] = true);
    }
  }

  Future<void> _seek(int index, Duration position) async {
    await _players[index]?.seek(position);
  }

  Future<void> _changeSpeed(int index) async {
    final current = _speeds[index] ?? 1.0;
    final speeds = [1.0, 1.25, 1.5, 1.75, 2.0, 0.75, 0.5];
    final currentIdx = speeds.indexOf(current);
    final nextIdx = (currentIdx + 1) % speeds.length;
    final newSpeed = speeds[nextIdx];

    await _players[index]?.setPlaybackRate(newSpeed);
    if (mounted) setState(() => _speeds[index] = newSpeed);
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    final hours = d.inHours;
    if (hours > 0) {
      return '$hours:$minutes:$seconds';
    }
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    for (final player in _players.values) {
      player.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBg(context),
      appBar: AppBar(
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.chapterTitle,
              textScaler: const TextScaler.linear(1.0),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              widget.chapterSubtitle,
              textScaler: const TextScaler.linear(1.0),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 24),
        itemCount: widget.lessons.length,
        separatorBuilder: (context, index) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
          child: Divider(
            height: 1,
            thickness: 1,
            color: AppColors.primaryGreen.withValues(alpha: 0.4),
          ),
        ),
        itemBuilder: (context, index) {
          return _LessonCard(
            lesson: widget.lessons[index],
            isPlaying: _isPlaying[index] ?? false,
            duration: _durations[index] ?? Duration.zero,
            position: _positions[index] ?? Duration.zero,
            speed: _speeds[index] ?? 1.0,
            onPlayPause: () => _togglePlay(index),
            onSeek: (pos) => _seek(index, pos),
            onSpeedChange: () => _changeSpeed(index),
            formatDuration: _formatDuration,
          );
        },
      ),
    );
  }
}

class _LessonCard extends StatelessWidget {
  final AudioLesson lesson;
  final bool isPlaying;
  final Duration duration;
  final Duration position;
  final double speed;
  final VoidCallback onPlayPause;
  final ValueChanged<Duration> onSeek;
  final VoidCallback onSpeedChange;
  final String Function(Duration) formatDuration;

  const _LessonCard({
    required this.lesson,
    required this.isPlaying,
    required this.duration,
    required this.position,
    required this.speed,
    required this.onPlayPause,
    required this.onSeek,
    required this.onSpeedChange,
    required this.formatDuration,
  });

  @override
  Widget build(BuildContext context) {
    final maxMs = duration.inMilliseconds.toDouble();
    final posMs = position.inMilliseconds.toDouble().clamp(0.0, maxMs);

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
      decoration: BoxDecoration(
        color: AppColors.panelBg(context),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isPlaying
              ? AppColors.primaryGreen
              : AppColors.stroke(context).withValues(alpha: 0.4),
          width: isPlaying ? 1.8 : 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.stroke(context).withValues(alpha: 0.15),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Audio dars ${lesson.number}',
                  textScaler: const TextScaler.linear(1.0),
                  style: const TextStyle(
                    color: AppColors.primaryGreen,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Mavzu: ${lesson.topic}',
            textScaler: const TextScaler.linear(1.0),
            style: TextStyle(
              color: AppColors.mainText(context),
              fontSize: 14,
              height: 1.4,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          SliderTheme(
            data: SliderThemeData(
              trackHeight: 3,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
              activeTrackColor: AppColors.primaryGreen,
              inactiveTrackColor: AppColors.primaryGreen.withValues(alpha: 0.2),
              thumbColor: AppColors.primaryGreen,
              overlayColor: AppColors.primaryGreen.withValues(alpha: 0.2),
            ),
            child: Slider(
              min: 0,
              max: maxMs > 0 ? maxMs : 1,
              value: posMs,
              onChanged: (value) {
                onSeek(Duration(milliseconds: value.toInt()));
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Row(
              children: [
                GestureDetector(
                  onTap: onPlayPause,
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryGreen.withValues(alpha: 0.35),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      isPlaying ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  formatDuration(position),
                  textScaler: const TextScaler.linear(1.0),
                  style: TextStyle(
                    color: AppColors.mainText(context),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Text(
                  formatDuration(duration),
                  textScaler: const TextScaler.linear(1.0),
                  style: TextStyle(
                    color: AppColors.secondaryText(context),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: onSpeedChange,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 7),
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppColors.primaryGreen.withValues(alpha: 0.4),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      '${speed}x',
                      textScaler: const TextScaler.linear(1.0),
                      style: const TextStyle(
                        color: AppColors.primaryGreen,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}