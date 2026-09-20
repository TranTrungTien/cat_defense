import 'package:flutter/material.dart';
import 'package:cat_defense/managers/player_data_manager.dart';
import 'package:cat_defense/screens/tabs/home_tab.dart';
import 'package:cat_defense/screens/tabs/upgrade_tab.dart';
import 'package:cat_defense/screens/tabs/extra_tab.dart';
import 'package:cat_defense/screens/tabs/shop_tab.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() => _selectedIndex = _tabController.index);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onSidebarTap(int index) {
    _tabController.animateTo(index);
  }

  @override
  Widget build(BuildContext context) {
    final playerManager = PlayerDataManager.instance;

    return Scaffold(
      body: Row(
        children: [
          Container(
            width: 100,
            color: Colors.grey.shade900,
            child: Column(
              children: [
                const SizedBox(height: 40),
                _sidebarButton(
                  icon: Icons.card_giftcard,
                  label: 'Daily',
                  isSelected: false,
                  onTap: () {},
                  color: Colors.orange,
                ),
                const SizedBox(height: 20),
                _sidebarButton(
                  icon: Icons.home,
                  label: 'Home',
                  isSelected: _selectedIndex == 0,
                  onTap: () => _onSidebarTap(0),
                ),
                _sidebarButton(
                  icon: Icons.pets,
                  label: 'Upgrade',
                  isSelected: _selectedIndex == 1,
                  onTap: () => _onSidebarTap(1),
                ),
                _sidebarButton(
                  icon: Icons.extension,
                  label: 'Extra',
                  isSelected: _selectedIndex == 2,
                  onTap: () => _onSidebarTap(2),
                ),
                _sidebarButton(
                  icon: Icons.shopping_cart,
                  label: 'Shop',
                  isSelected: _selectedIndex == 3,
                  onTap: () => _onSidebarTap(3),
                ),
              ],
            ),
          ),

          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: Container(color: const Color(0xFF3E4A3D)),
                ),

                Positioned(
                  top: 20,
                  right: 20,
                  child: ListenableBuilder(
                    listenable: playerManager,
                    builder: (context, _) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.greenAccent,
                            width: 2,
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.diamond,
                              color: Colors.greenAccent,
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${playerManager.data.gems}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.add_circle,
                              color: Colors.white70,
                              size: 20,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                TabBarView(
                  controller: _tabController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: const [
                    HomeTab(),
                    UpgradeTab(),
                    ExtraTab(),
                    ShopTab(),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sidebarButton({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    Color? color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        height: 80,
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.teal : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: isSelected ? Border.all(color: Colors.white, width: 2) : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: color ?? (isSelected ? Colors.white : Colors.white54),
              size: 32,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white54,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
