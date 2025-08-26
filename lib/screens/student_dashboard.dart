import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/data_service.dart';
import '../widgets/navigation_drawer.dart';
import '../widgets/custom_card.dart';
import '../widgets/custom_button.dart';
import '../widgets/modal_dialog.dart';
import '../utils/validators.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  String _selectedSection = 'dashboard';

  @override
  Widget build(BuildContext context) {
    return Consumer<DataService>(
      builder: (context, dataService, child) {
        final user = dataService.currentUser;
        if (user == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          appBar: _buildAppBar(context, dataService),
          drawer: NavigationDrawer(
            items: user.role == 'parent' 
                ? NavigationItems.getParentItems()
                : NavigationItems.getStudentItems(),
            selectedItem: _selectedSection,
            onItemSelected: (section) {
              setState(() {
                _selectedSection = section;
              });
            },
            userRole: user.role,
          ),
          body: _buildContent(context, dataService),
          floatingActionButton: _buildFloatingActionButton(context),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, DataService dataService) {
    final user = dataService.currentUser!;
    
    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _getSectionTitle(),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '${AppHelpers.getGreeting()}, ${user.name.split(' ')[0]}!',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
      actions: [
        // Search (desktop only)
        if (MediaQuery.of(context).size.width > 600)
          Container(
            width: 200,
            height: 40,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: const Icon(Icons.search, size: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),
        
        // Notifications
        IconButton(
          onPressed: () => _showNotifications(context),
          icon: Stack(
            children: [
              const Icon(Icons.notifications_outlined),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // Cart
        IconButton(
          onPressed: () => _showCart(context, dataService),
          icon: Stack(
            children: [
              const Icon(Icons.shopping_cart_outlined),
              if (dataService.cartItemCount > 0)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.purple,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '${dataService.cartItemCount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ),
        
        // Profile
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: GestureDetector(
            onTap: () => _showProfileMenu(context),
            child: CircleAvatar(
              backgroundColor: const Color(0xFF667eea),
              child: Text(
                user.avatar,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context, DataService dataService) {
    switch (_selectedSection) {
      case 'dashboard':
        return _buildDashboard(context, dataService);
      case 'profile':
        return _buildProfile(context, dataService);
      case 'homework':
        return _buildHomework(context, dataService);
      case 'results':
        return _buildResults(context, dataService);
      case 'fees':
        return _buildFees(context, dataService);
      case 'timetable':
        return _buildTimetable(context, dataService);
      case 'shop':
        return _buildShop(context, dataService);
      default:
        return _buildDashboard(context, dataService);
    }
  }

  Widget _buildDashboard(BuildContext context, DataService dataService) {
    final user = dataService.currentUser!;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF667eea), Color(0xFF764ba2)],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${AppHelpers.getGreeting()}, ${user.name}! 🌟',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  user.role == 'parent' 
                      ? 'Monitor your child\'s academic progress and stay connected with school activities.'
                      : 'You have 3 assignments due this week and 2 upcoming events.',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    CustomButton(
                      text: user.role == 'parent' ? 'View Progress' : 'View Homework',
                      backgroundColor: Colors.white.withOpacity(0.2),
                      onPressed: () {
                        setState(() {
                          _selectedSection = 'homework';
                        });
                      },
                    ),
                    const SizedBox(width: 12),
                    CustomButton(
                      text: 'Visit Store',
                      backgroundColor: Colors.white.withOpacity(0.2),
                      onPressed: () {
                        setState(() {
                          _selectedSection = 'shop';
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Stats Cards
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1.2,
            children: [
              StatCard(
                title: 'Attendance Rate',
                value: '95.2%',
                subtitle: '+2.5%',
                emoji: '📅',
                color: const Color(0xFF10B981),
                onTap: () {
                  setState(() {
                    _selectedSection = 'timetable';
                  });
                },
              ),
              StatCard(
                title: user.role == 'parent' ? "Child's Homework" : 'Total Homework',
                value: '12',
                subtitle: '3 Due',
                emoji: '📝',
                color: const Color(0xFF3B82F6),
                onTap: () {
                  setState(() {
                    _selectedSection = 'homework';
                  });
                },
              ),
              StatCard(
                title: 'Overall Results',
                value: '85.4%',
                subtitle: 'Excellent',
                emoji: '📊',
                color: const Color(0xFF8B5CF6),
                onTap: () {
                  setState(() {
                    _selectedSection = 'results';
                  });
                },
              ),
              StatCard(
                title: 'Class Ranking',
                value: '5th',
                subtitle: 'Top 10%',
                emoji: '🏆',
                color: const Color(0xFFF59E0B),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Recent Activity
          CustomCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Recent Activity',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ActivityCard(
                  title: 'Homework Submitted',
                  subtitle: 'Mathematics - Quadratic Equations',
                  color: const Color(0xFF10B981),
                  time: '2 hours ago',
                ),
                const SizedBox(height: 12),
                ActivityCard(
                  title: 'Result Published',
                  subtitle: 'Physics Test - 88%',
                  color: const Color(0xFF3B82F6),
                  time: '1 day ago',
                ),
                const SizedBox(height: 12),
                ActivityCard(
                  title: 'Fee Payment',
                  subtitle: 'Term 2 fees paid successfully',
                  color: const Color(0xFF8B5CF6),
                  time: '3 days ago',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfile(BuildContext context, DataService dataService) {
    final user = dataService.currentUser!;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Profile Card
          CustomCard(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: const Color(0xFF667eea),
                  child: Text(
                    user.avatar,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  user.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  user.className,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppHelpers.getStatusColor(user.role).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        user.role.toUpperCase(),
                        style: TextStyle(
                          color: AppHelpers.getStatusColor(user.role),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'ACTIVE',
                        style: TextStyle(
                          color: Color(0xFF10B981),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                CustomButton(
                  text: 'Edit Profile',
                  icon: const Icon(Icons.edit, size: 20),
                  onPressed: () => _showEditProfile(context, user),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Profile Details
          CustomCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Personal Information',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildProfileField('Full Name', user.name),
                _buildProfileField('Mobile Number', user.mobile),
                _buildProfileField('Email Address', user.email),
                _buildProfileField('Role', user.role.toUpperCase()),
                if (user.role == 'student') ...[
                  const SizedBox(height: 16),
                  const Text(
                    'Academic Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildProfileField('Class', user.className),
                  _buildProfileField('Student ID', 'STU001'),
                  if (user.additionalData['parentName'] != null)
                    _buildProfileField('Parent Name', user.additionalData['parentName']),
                  if (user.additionalData['subjects'] != null)
                    _buildProfileField('Subjects', (user.additionalData['subjects'] as List).join(', ')),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHomework(BuildContext context, DataService dataService) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Pending Homework
          CustomCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Pending Homework (3)',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildHomeworkItem(
                  'Mathematics - Quadratic Equations',
                  'Solve problems 1-15 from Chapter 4. Show all working steps clearly.',
                  'Due Tomorrow',
                  const Color(0xFFEF4444),
                  'March 10, 2024',
                ),
                const SizedBox(height: 12),
                _buildHomeworkItem(
                  'Physics - Laws of Motion',
                  'Write a comprehensive lab report on the experiment conducted in class.',
                  'Due in 3 days',
                  const Color(0xFFF59E0B),
                  'March 8, 2024',
                ),
                const SizedBox(height: 12),
                _buildHomeworkItem(
                  'English - Essay Writing',
                  'Write a 500-word essay on "The Impact of Technology on Education".',
                  'Due in 5 days',
                  const Color(0xFF3B82F6),
                  'March 6, 2024',
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Homework Stats
          CustomCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Homework Statistics',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem('Completed', '45', const Color(0xFF10B981)),
                    _buildStatItem('Pending', '3', const Color(0xFFEF4444)),
                    _buildStatItem('Rate', '93.8%', const Color(0xFF3B82F6)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHomeworkItem(String title, String description, String dueText, Color color, String assignedDate) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border(
          left: BorderSide(color: color, width: 4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  dueText,
                  style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Assigned: $assignedDate',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                ),
              ),
              CustomButton(
                text: 'Submit Work',
                backgroundColor: const Color(0xFF3B82F6),
                onPressed: () => _showFileUpload(context),
                height: 32,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildResults(BuildContext context, DataService dataService) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Overall Performance
          CustomCard(
            child: Column(
              children: [
                const Text(
                  'Overall Performance - Term 1, 2024',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF667eea).withOpacity(0.8),
                        const Color(0xFF764ba2).withOpacity(0.8),
                      ],
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      '85.4%',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Excellent Performance',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF10B981),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Class Rank: 5th out of 45 students',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Subject-wise Results
          CustomCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Subject-wise Performance',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildSubjectResult('Mathematics', 92, 78, 'A+', const Color(0xFF3B82F6)),
                _buildSubjectResult('Physics', 88, 75, 'A', const Color(0xFF10B981)),
                _buildSubjectResult('Chemistry', 85, 72, 'A', const Color(0xFF8B5CF6)),
                _buildSubjectResult('Biology', 82, 70, 'A', const Color(0xFFEF4444)),
                _buildSubjectResult('English', 80, 76, 'A', const Color(0xFFF59E0B)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectResult(String subject, int marks, int classAvg, String grade, Color color) {
    final percentage = marks / 100;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  subject,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '$marks%',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: percentage,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 6,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Class Average: $classAvg%',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Grade: $grade',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFees(BuildContext context, DataService dataService) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Fee Summary
          CustomCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Fee Structure - Academic Year 2024-25',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildFeeItem('Tuition Fee (Annual)', 45000, 'Paid', const Color(0xFF10B981)),
                _buildFeeItem('Development Fee', 8000, 'Paid', const Color(0xFF10B981)),
                _buildFeeItem('Lab Fee', 5500, 'Paid', const Color(0xFF10B981)),
                _buildFeeItem('Library Fee', 2000, 'Paid', const Color(0xFF10B981)),
                _buildFeeItem('Examination Fee', 1500, 'Due March 25', const Color(0xFFEF4444)),
                const Divider(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Annual Fee',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      AppHelpers.formatCurrency(62000),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3B82F6),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Amount Paid',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      AppHelpers.formatCurrency(60500),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF10B981),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Outstanding',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      AppHelpers.formatCurrency(1500),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFEF4444),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Payment Summary
          CustomCard(
            child: Column(
              children: [
                const Text(
                  'Payment Summary',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF10B981).withOpacity(0.1),
                  ),
                  child: const Center(
                    child: Text(
                      '97.6%',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF10B981),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Fees Paid',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF10B981),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    text: 'Pay Outstanding ₹1,500',
                    backgroundColor: const Color(0xFF3B82F6),
                    onPressed: () => _showPaymentDialog(context, 1500, 'Outstanding Amount'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeeItem(String title, double amount, String status, Color statusColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment
