import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/themes/app_theme.dart';
import '../../../core/widgets/main_navigation_shell.dart';
import '../../accessibility/presentation/accessibility_page.dart';
import '../../guide/presentation/guide_page.dart';
import '../../map/presentation/map_page.dart';

enum ActivityMaterial { paper, plastic, glass }

class RecentActivity {
  final String title;
  final String timeLabel;
  final double kg;
  final ActivityMaterial material;

  const RecentActivity({
    required this.title,
    required this.timeLabel,
    required this.kg,
    required this.material,
  });

  Color get color {
    switch (material) {
      case ActivityMaterial.paper:
        return AppColors.accentPaper;
      case ActivityMaterial.plastic:
        return AppColors.accentPlastic;
      case ActivityMaterial.glass:
        return AppColors.accentGlass;
    }
  }
}

class HomeImpactState {
  final double recycledKg;
  final int treesSaved;
  final double monthlyGoalKg;
  final String challengeTitle;
  final int challengePoints;
  final int challengeProgress;
  final int challengeTarget;
  final List<RecentActivity> recentActivity;

  const HomeImpactState({
    this.recycledKg = 12.4,
    this.treesSaved = 5,
    this.monthlyGoalKg = 20,
    this.challengeTitle = 'Recicla 10 artículos de plástico',
    this.challengePoints = 50,
    this.challengeProgress = 3,
    this.challengeTarget = 10,
    this.recentActivity = const [
      RecentActivity(title: 'Cartón y papel', timeLabel: 'Hoy, 10:30', kg: 2.1, material: ActivityMaterial.paper),
      RecentActivity(title: 'Plásticos PET', timeLabel: 'Ayer, 16:00', kg: 0.8, material: ActivityMaterial.plastic),
      RecentActivity(title: 'Vidrio', timeLabel: '21 jul', kg: 1.4, material: ActivityMaterial.glass),
    ],
  });

  double get goalProgress => (recycledKg / monthlyGoalKg).clamp(0, 1);
  double get challengeProgressRatio => (challengeProgress / challengeTarget).clamp(0, 1);
}

final homeImpactProvider = Provider<HomeImpactState>((ref) => const HomeImpactState());

void _showComingSoon(BuildContext context, String feature) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('$feature estará disponible próximamente 🚧'),
      backgroundColor: AppColors.primary,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
}

void _openMenu(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: AppColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.bottomSheet)),
    ),
    builder: (context) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.menu_book_outlined, color: AppColors.primary),
                title: const Text('Guía de Residuos'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const GuidePage()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.accessibility_new_outlined, color: AppColors.primary),
                title: const Text('Accesibilidad'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const AccessibilityPage()));
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final impact = ref.watch(homeImpactProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _TopBar()),
            SliverToBoxAdapter(child: _HeroIllustration()),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('¡Buenos días,', style: Theme.of(context).textTheme.headlineLarge),
                    Text('vamos a reciclar!', style: Theme.of(context).textTheme.headlineLarge),
                    const SizedBox(height: 8),
                    Text('Cada pequeña acción marca una gran diferencia. 🌱',
                        style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 20),
                    _ImpactCard(impact: impact),
                    const SizedBox(height: 24),
                    Text('¿Qué te gustaría hacer hoy?', style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(height: 14),
                    const _QuickActionsGrid(),
                    const SizedBox(height: 20),
                    _WeeklyChallengeCard(impact: impact),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Actividad reciente', style: Theme.of(context).textTheme.headlineMedium),
                        GestureDetector(
                          onTap: () => _showComingSoon(context, 'El historial completo'),
                          child: const Text('Ver todo',
                              style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                  child: _ActivityTile(activity: impact.recentActivity[index]),
                ),
                childCount: impact.recentActivity.length,
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => _openMenu(context),
            child: const Icon(Icons.menu_rounded, size: 26, color: AppColors.textPrimary),
          ),
          GestureDetector(
            onTap: () => _showComingSoon(context, 'Las notificaciones'),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.notifications_none_rounded, size: 26, color: AppColors.textPrimary),
                Positioned(
                  right: -1,
                  top: -1,
                  child: Container(
                    width: 9,
                    height: 9,
                    decoration: const BoxDecoration(color: AppColors.primaryDark, shape: BoxShape.circle),
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

class _HeroIllustration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      height: 220,
      decoration: BoxDecoration(
        color: AppColors.accentPlastic.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(28),
      ),
      child: const Center(child: Icon(Icons.recycling, size: 72, color: AppColors.primary)),
    );
  }
}

class _ImpactCard extends StatelessWidget {
  final HomeImpactState impact;
  const _ImpactCard({required this.impact});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(AppRadius.card)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ESTE MES',
                      style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.6)),
                  const SizedBox(height: 2),
                  const Text('Tu impacto',
                      style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                ],
              ),
              GestureDetector(
                onTap: () => _showComingSoon(context, 'El detalle de estadísticas'),
                child: CircleAvatar(
                  backgroundColor: Colors.white.withValues(alpha: 0.15),
                  child: const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                  child: _StatChip(
                      icon: Icons.arrow_upward_rounded, label: 'reciclados', value: '${impact.recycledKg}', unit: 'kg')),
              const SizedBox(width: 12),
              Expanded(
                  child: _StatChip(
                      icon: Icons.park_rounded, label: 'salvados', value: '${impact.treesSaved}', unit: 'árboles')),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Meta mensual', style: TextStyle(color: Colors.white.withValues(alpha: 0.75), fontSize: 12)),
              Text('${impact.recycledKg} / ${impact.monthlyGoalKg.toStringAsFixed(0)} kg',
                  style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: LinearProgressIndicator(
              value: impact.goalProgress,
              minHeight: 8,
              backgroundColor: Colors.white.withValues(alpha: 0.2),
              valueColor: const AlwaysStoppedAnimation(AppColors.secondaryAlt),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String unit;
  const _StatChip({required this.icon, required this.label, required this.value, required this.unit});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(18)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.secondaryAlt, size: 16),
              const SizedBox(width: 6),
              Text(label, style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 12)),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(value, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(width: 4),
              Text(unit, style: TextStyle(color: Colors.white.withValues(alpha: 0.75), fontSize: 13)),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickActionsGrid extends ConsumerWidget {
  const _QuickActionsGrid();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actions = [
      (
        icon: Icons.location_on_outlined,
        label: 'Buscar Puntos\nLimpios',
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MapPage())),
      ),
      (
        icon: Icons.calendar_today_outlined,
        label: 'Agendar\nRecogida',
        onTap: () => _showComingSoon(context, 'Agendar recogida'),
      ),
      (
        icon: Icons.menu_book_outlined,
        label: 'Consejos y\nTips',
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const GuidePage())),
      ),
      (
        icon: Icons.card_giftcard_outlined,
        label: 'Recompensas',
        onTap: () => ref.read(navigationIndexProvider.notifier).state = 2,
      ),
    ];

    return Row(
      children: actions
          .map((a) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: InkWell(
                    onTap: a.onTap,
                    borderRadius: BorderRadius.circular(18),
                    child: Column(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: AppShadows.card,
                          ),
                          child: Icon(a.icon, color: AppColors.primary, size: 24),
                        ),
                        const SizedBox(height: 8),
                        Text(a.label,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 11, color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ),
              ))
          .toList(),
    );
  }
}

class _WeeklyChallengeCard extends StatelessWidget {
  final HomeImpactState impact;
  const _WeeklyChallengeCard({required this.impact});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showComingSoon(context, 'El detalle del reto'),
      borderRadius: BorderRadius.circular(AppRadius.card),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.card),
          boxShadow: AppShadows.card,
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(color: AppColors.secondary, shape: BoxShape.circle),
              child: const Icon(Icons.recycling, color: AppColors.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('RETO DE LA SEMANA',
                      style: TextStyle(color: AppColors.primary, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 0.4)),
                  const SizedBox(height: 2),
                  Text(impact.challengeTitle, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  Text('Gana ${impact.challengePoints} puntos al completarlo', style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: LinearProgressIndicator(
                            value: impact.challengeProgressRatio,
                            minHeight: 6,
                            backgroundColor: AppColors.secondary.withValues(alpha: 0.4),
                            valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text('${impact.challengeProgress}/${impact.challengeTarget}', style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const CircleAvatar(
              radius: 20,
              backgroundColor: AppColors.primary,
              child: Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActivityTile extends StatelessWidget {
  final RecentActivity activity;
  const _ActivityTile({required this.activity});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showComingSoon(context, 'El detalle de esta actividad'),
      borderRadius: BorderRadius.circular(AppRadius.card),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.card),
          boxShadow: AppShadows.card,
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(color: activity.color, shape: BoxShape.circle),
              child: const Icon(Icons.recycling, color: AppColors.textPrimary, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(activity.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  Text(activity.timeLabel, style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
            Text('${activity.kg} kg', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          ],
        ),
      ),
    );
  }
}