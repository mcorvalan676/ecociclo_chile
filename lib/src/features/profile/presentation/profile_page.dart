import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/themes/app_theme.dart';

class Achievement {
  final String title;
  final String date;
  final IconData icon;
  final Color color;

  const Achievement({required this.title, required this.date, required this.icon, required this.color});
}

class ProfileStats {
  final int objectsRecycled;
  final double materialSavedKg;
  final double co2AvoidedKg;
  final int treesEquivalent;

  const ProfileStats({
    this.objectsRecycled = 128,
    this.materialSavedKg = 24.7,
    this.co2AvoidedKg = 18.3,
    this.treesEquivalent = 12,
  });
}

class ProfileState {
  final String name;
  final String subtitle;
  final String location;
  final int level;
  final int currentXp;
  final int nextLevelXp;
  final ProfileStats stats;
  final List<Achievement> achievements;

  const ProfileState({
    this.name = 'EcoCaminante',
    this.subtitle = 'Juntos por un mañana más limpio. 🌿',
    this.location = 'Santiago, Chile',
    this.level = 24,
    this.currentXp = 3260,
    this.nextLevelXp = 4000,
    this.stats = const ProfileStats(),
    this.achievements = const [
      Achievement(title: 'Novato del Reciclaje', date: '01/05/2026', icon: Icons.recycling, color: AppColors.accentPlastic),
      Achievement(title: 'Campeón Reutilizador', date: '15/05/2026', icon: Icons.replay_circle_filled, color: AppColors.accentPaper),
      Achievement(title: 'Guardián de la Tierra', date: '01/06/2026', icon: Icons.public, color: AppColors.accentGlass),
      Achievement(title: 'Guerrero Ecológico', date: '20/06/2026', icon: Icons.eco, color: AppColors.accentTrees),
    ],
  });

  double get xpProgress => (currentXp / nextLevelXp).clamp(0, 1);
  int get xpToNextLevel => nextLevelXp - currentXp;
}

final profileProvider = Provider<ProfileState>((ref) => const ProfileState());

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _ProfileHeader(profile: profile),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _XpCard(profile: profile),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Mis Estadísticas', style: Theme.of(context).textTheme.headlineMedium),
                      const Text('Ver todo', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const SizedBox(height: 14),
                  _StatsGrid(stats: profile.stats),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Logros', style: Theme.of(context).textTheme.headlineMedium),
                      const Text('Ver insignias', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const SizedBox(height: 14),
                  _AchievementsRow(achievements: profile.achievements),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final ProfileState profile;
  const _ProfileHeader({required this.profile});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          height: 190,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: AppColors.primaryDark,
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(Icons.arrow_back, color: Colors.white),
                  const Icon(Icons.more_vert, color: Colors.white),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -44,
          child: Container(
            width: 92,
            height: 92,
            padding: const EdgeInsets.all(3),
            decoration: const BoxDecoration(color: AppColors.background, shape: BoxShape.circle),
            child: Container(
              decoration: BoxDecoration(color: AppColors.secondary, shape: BoxShape.circle),
              child: const Icon(Icons.person, size: 44, color: AppColors.primaryDark),
            ),
          ),
        ),
        Positioned(
          bottom: -128,
          child: Column(
            children: [
              Text(profile.name, style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontSize: 22)),
              const SizedBox(height: 4),
              Text(profile.subtitle, style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center),
              const SizedBox(height: 6),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.location_on_outlined, size: 14, color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Text(profile.location, style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(color: AppColors.secondary, borderRadius: BorderRadius.circular(100)),
                child: Text('Nivel Eco ${profile.level}',
                    style: const TextStyle(color: AppColors.primaryDark, fontSize: 12, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 190),
        const SizedBox(height: 150),
      ],
    );
  }
}

class _XpCard extends StatelessWidget {
  final ProfileState profile;
  const _XpCard({required this.profile});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.card),
          boxShadow: AppShadows.card,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Experiencia (XP)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                Text('${profile.currentXp} / ${profile.nextLevelXp} XP',
                    style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: LinearProgressIndicator(
                value: profile.xpProgress,
                minHeight: 10,
                backgroundColor: AppColors.secondary.withValues(alpha: 0.4),
                valueColor: const AlwaysStoppedAnimation(AppColors.primary),
              ),
            ),
            const SizedBox(height: 8),
            Text('${profile.xpToNextLevel} XP para el siguiente nivel', style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  final ProfileStats stats;
  const _StatsGrid({required this.stats});

  @override
  Widget build(BuildContext context) {
    final items = [
      (icon: Icons.recycling, value: '${stats.objectsRecycled}', unit: '', label: 'Objetos reciclados\nEste mes', color: AppColors.accentPlastic),
      (icon: Icons.shopping_bag_outlined, value: '${stats.materialSavedKg}', unit: 'kg', label: 'Material ahorrado\nEste mes', color: AppColors.accentGlass),
      (icon: Icons.air, value: '${stats.co2AvoidedKg}', unit: 'kg', label: 'CO2 evitado\nEste mes', color: AppColors.accentPaper),
      (icon: Icons.park_outlined, value: '${stats.treesEquivalent}', unit: '', label: 'Equiv. en árboles\nHistórico', color: AppColors.accentTrees),
    ];

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.6,
      children: items
          .map((item) => Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: item.color, borderRadius: BorderRadius.circular(AppRadius.card)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(item.icon, color: AppColors.textPrimary, size: 20),
                    const Spacer(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(item.value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                        if (item.unit.isNotEmpty) ...[
                          const SizedBox(width: 3),
                          Text(item.unit, style: const TextStyle(fontSize: 13, color: AppColors.textPrimary)),
                        ],
                      ],
                    ),
                    Text(item.label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                  ],
                ),
              ))
          .toList(),
    );
  }
}

class _AchievementsRow extends StatelessWidget {
  final List<Achievement> achievements;
  const _AchievementsRow({required this.achievements});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: achievements.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final a = achievements[index];
          return SizedBox(
            width: 90,
            child: Column(
              children: [
                ClipPath(
                  clipper: _HexagonClipper(),
                  child: Container(
                    width: 72,
                    height: 72,
                    color: a.color,
                    child: Padding(
                      padding: const EdgeInsets.all(3),
                      child: ClipPath(
                        clipper: _HexagonClipper(),
                        child: Container(
                          color: AppColors.primary,
                          child: Icon(a.icon, color: Colors.white, size: 28),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(a.title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                Text(a.date, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _HexagonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final w = size.width;
    final h = size.height;
    final path = Path();
    path.moveTo(w * 0.5, 0);
    path.lineTo(w, h * 0.25);
    path.lineTo(w, h * 0.75);
    path.lineTo(w * 0.5, h);
    path.lineTo(0, h * 0.75);
    path.lineTo(0, h * 0.25);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}