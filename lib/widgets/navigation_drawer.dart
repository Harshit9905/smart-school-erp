import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/data_service.dart';
import '../utils/validators.dart';

class NavigationDrawer extends StatelessWidget {
  final List<NavigationItem> items;
  final String? selectedItem;
  final Function(String) onItemSelected;
  final String userRole;

  const NavigationDrawer({
    super.key,
    required this.items,
    this.selectedItem,
    required this.onItemSelected,
    required this.userRole,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          _buildHeader(context),
          _buildUserProfile(context),
          Expanded(
            child: _buildNavigationItems(context),
          ),
          _buildLogoutButton(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    String title;
    String subtitle;
    String emoji;
    
    switch (userRole) {
      case 'student':
        title = 'Greenwood High School';
        subtitle = 'Student Portal';
        emoji = '🎓';
        break;
      case 'teacher':
        title = 'Teacher Portal';
        subtitle = 'Greenwood High School';
        emoji = '👩‍🏫';
        break;
      case 'admin':
        title = 'School ERP';
        subtitle = 'Admin Panel';
        emoji = '👨‍💼';
        break;
      case 'parent':
        title = 'Greenwood High School';
        subtitle = 'Parent Portal';
        emoji = '👨‍👩‍👧‍👦';
        break;
      default:
        title = 'Smart School ERP';
        subtitle = 'Management System';
        emoji = '🏫';
    }

    return Container(
      height: 200,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    emoji,
                    style: const TextStyle(fontSize: 28),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserProfile(BuildContext context) {
    return Consumer<DataService>(
      builder: (context, dataService, child) {
        final user = dataService.currentUser;
        if (user == null) return const SizedBox.shrink();

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(color: Colors.grey[200]!),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    user.avatar,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user.className,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getRoleColor(user.role).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            user.role.toUpperCase(),
                            style: TextStyle(
                              color: _getRoleColor(user.role),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'ACTIVE',
                            style: TextStyle(
                              color: Color(0xFF10B981),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNavigationItems(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: items.map((item) => _buildNavigationItem(context, item)).toList(),
    );
  }

  Widget _buildNavigationItem(BuildContext context, NavigationItem item) {
    final isSelected = selectedItem == item.id;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            onItemSelected(item.id);
            Navigator.of(context).pop(); // Close drawer
          },
          borderRadius: BorderRadius.circular(12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected 
                  ? const Color(0xFF667eea).withOpacity(0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: isSelected
                  ? Border.all(color: const Color(0xFF667eea).withOpacity(0.3))
                  : null,
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isSelected 
                        ? const Color(0xFF667eea)
                        : Colors.grey[100],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: item.icon != null
                        ? Icon(
                            item.icon,
                            color: isSelected ? Colors.white : Colors.grey[600],
                            size: 20,
                          )
                        : Text(
                            item.emoji ?? '📄',
                            style: const TextStyle(fontSize: 20),
                          ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    item.label,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isSelected 
                          ? const Color(0xFF667eea)
                          : const Color(0xFF374151),
                    ),
                  ),
                ),
                if (item.badge != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: item.badgeColor ?? const Color(0xFFEF4444),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      item.badge!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () => _handleLogout(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFEF4444),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.logout, size: 20),
              SizedBox(width: 8),
              Text(
                'Logout',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getRoleColor(String role) {
    switch (role.toLowerCase()) {
      case 'student':
        return const Color(0xFF3B82F6);
      case 'teacher':
        return const Color(0xFF10B981);
      case 'parent':
        return const Color(0xFF8B5CF6);
      case 'admin':
        return const Color(0xFFF59E0B);
      default:
        return const Color(0xFF6B7280);
    }
  }

  Future<void> _handleLogout(BuildContext context) async {
    final confirmed = await AppHelpers.showConfirmDialog(
      context,
      'Logout',
      'Are you sure you want to logout?',
    );

    if (confirmed) {
      final dataService = Provider.of<DataService>(context, listen: false);
      dataService.logout();
      
      if (context.mounted) {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    }
  }
}

class NavigationItem {
  final String id;
  final String label;
  final IconData? icon;
  final String? emoji;
  final String? badge;
  final Color? badgeColor;

  NavigationItem({
    required this.id,
    required this.label,
    this.icon,
    this.emoji,
    this.badge,
    this.badgeColor,
  });
}

// Predefined navigation items for different roles
class NavigationItems {
  static List<NavigationItem> getStudentItems() {
    return [
      NavigationItem(
        id: 'dashboard',
        label: 'Dashboard',
        icon: Icons.home,
      ),
      NavigationItem(
        id: 'profile',
        label: 'My Profile',
        icon: Icons.person,
      ),
      NavigationItem(
        id: 'homework',
        label: 'Homework',
        icon: Icons.assignment,
        badge: '3',
        badgeColor: const Color(0xFFEF4444),
      ),
      NavigationItem(
        id: 'results',
        label: 'Results',
        icon: Icons.bar_chart,
        badge: '85%',
        badgeColor: const Color(0xFF10B981),
      ),
      NavigationItem(
        id: 'fees',
        label: 'Fees',
        icon: Icons.payment,
      ),
      NavigationItem(
        id: 'timetable',
        label: 'Time Table',
        icon: Icons.schedule,
      ),
      NavigationItem(
        id: 'shop',
        label: 'School Shop',
        icon: Icons.shopping_cart,
      ),
    ];
  }

  static List<NavigationItem> getTeacherItems() {
    return [
      NavigationItem(
        id: 'dashboard',
        label: 'Dashboard',
        icon: Icons.home,
      ),
      NavigationItem(
        id: 'profile',
        label: 'My Profile',
        icon: Icons.person,
      ),
      NavigationItem(
        id: 'attendance',
        label: 'Attendance',
        icon: Icons.how_to_reg,
      ),
      NavigationItem(
        id: 'results',
        label: 'Results Upload',
        icon: Icons.upload_file,
      ),
      NavigationItem(
        id: 'ptm',
        label: 'PTM Scheduling',
        icon: Icons.event,
      ),
      NavigationItem(
        id: 'notices',
        label: 'Notices',
        icon: Icons.announcement,
      ),
    ];
  }

  static List<NavigationItem> getAdminItems() {
    return [
      NavigationItem(
        id: 'dashboard',
        label: 'Admin Dashboard',
        icon: Icons.dashboard,
      ),
      NavigationItem(
        id: 'students',
        label: 'Students',
        icon: Icons.school,
      ),
      NavigationItem(
        id: 'teachers',
        label: 'Teachers',
        icon: Icons.person_outline,
      ),
      NavigationItem(
        id: 'staff',
        label: 'Staff',
        icon: Icons.people,
      ),
      NavigationItem(
        id: 'fees',
        label: 'Fees',
        icon: Icons.payment,
      ),
      NavigationItem(
        id: 'attendance',
        label: 'Attendance',
        icon: Icons.how_to_reg,
      ),
      NavigationItem(
        id: 'results',
        label: 'Results',
        icon: Icons.bar_chart,
      ),
      NavigationItem(
        id: 'transport',
        label: 'Transport',
        icon: Icons.directions_bus,
      ),
    ];
  }

  static List<NavigationItem> getParentItems() {
    return [
      NavigationItem(
        id: 'dashboard',
        label: 'Dashboard',
        icon: Icons.home,
      ),
      NavigationItem(
        id: 'profile',
        label: 'My Profile',
        icon: Icons.person,
      ),
      NavigationItem(
        id: 'homework',
        label: "Child's Homework",
        icon: Icons.assignment,
      ),
      NavigationItem(
        id: 'results',
        label: "Child's Results",
        icon: Icons.bar_chart,
      ),
      NavigationItem(
        id: 'fees',
        label: "Child's Fees",
        icon: Icons.payment,
      ),
      NavigationItem(
        id: 'shop',
        label: 'School Shop',
        icon: Icons.shopping_cart,
      ),
    ];
  }
}
