import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/data_service.dart';
import '../widgets/navigation_drawer.dart';
import '../widgets/custom_card.dart';
import '../widgets/custom_button.dart';
import '../widgets/modal_dialog.dart';
import '../utils/validators.dart';

class TeacherDashboard extends StatefulWidget {
  const TeacherDashboard({super.key});

  @override
  State<TeacherDashboard> createState() => _TeacherDashboardState();
}

class _TeacherDashboardState extends State<TeacherDashboard> {
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
            items: NavigationItems.getTeacherItems(),
            selectedItem: _selectedSection,
            onItemSelected: (section) {
              setState(() {
                _selectedSection = section;
              });
            },
            userRole: user.role,
          ),
          body: _buildContent(context, dataService),
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
        
        // Profile
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: GestureDetector(
            onTap: () => _showProfileMenu(context),
            child: CircleAvatar(
              backgroundColor: const Color(0xFF10B981),
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
      case 'attendance':
        return _buildAttendance(context, dataService);
      case 'results':
        return _buildResults(context, dataService);
      case 'ptm':
        return _buildPTM(context, dataService);
      case 'notices':
        return _buildNotices(context, dataService);
      default:
        return _buildDashboard(context, dataService);
    }
  }

  Widget _buildDashboard(BuildContext context, DataService dataService) {
    final user = dataService.currentUser!;
    final teachingClasses = user.additionalData['teachingClasses'] as List? ?? ['Grade 11A', 'Grade 11B', 'Grade 12A'];
    final classTeacherOf = user.additionalData['classTeacherOf'] ?? 'Grade 11A';
    
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
                colors: [Color(0xFF10B981), Color(0xFF059669)],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${AppHelpers.getGreeting()}, ${user.name}! 👩‍🏫',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Subject: ${user.additionalData['subjects']?.join(', ') ?? 'Mathematics'} | Classes: ${teachingClasses.join(', ')}',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star, color: Colors.white, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        'Class Teacher: $classTeacherOf',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    CustomButton(
                      text: 'Mark Attendance',
                      backgroundColor: Colors.white.withOpacity(0.2),
                      onPressed: () {
                        setState(() {
                          _selectedSection = 'attendance';
                        });
                      },
                    ),
                    const SizedBox(width: 12),
                    CustomButton(
                      text: 'Upload Results',
                      backgroundColor: Colors.white.withOpacity(0.2),
                      onPressed: () {
                        setState(() {
                          _selectedSection = 'results';
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
                title: 'Total Students',
                value: _getTotalStudents(dataService, teachingClasses).toString(),
                subtitle: 'Across ${teachingClasses.length} classes',
                emoji: '👨‍🎓',
                color: const Color(0xFF3B82F6),
              ),
              StatCard(
                title: "Today's Attendance",
                value: _getTodayAttendance(dataService, teachingClasses).toString(),
                subtitle: '${_getAttendancePercentage(dataService, teachingClasses)}% Present',
                emoji: '📅',
                color: const Color(0xFF10B981),
              ),
              StatCard(
                title: 'Upcoming PTMs',
                value: dataService.ptmSchedules.where((ptm) => DateTime.parse(ptm.date).isAfter(DateTime.now())).length.toString(),
                subtitle: 'This month',
                emoji: '👥',
                color: const Color(0xFF8B5CF6),
              ),
              StatCard(
                title: 'Notices Sent',
                value: dataService.notices.length.toString(),
                subtitle: 'This month',
                emoji: '📢',
                color: const Color(0xFFF59E0B),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Quick Actions & Class Overview
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: CustomCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Quick Actions',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 1.5,
                        children: [
                          QuickActionCard(
                            title: 'Mark Attendance',
                            emoji: '📋',
                            color: const Color(0xFF3B82F6),
                            onTap: () {
                              setState(() {
                                _selectedSection = 'attendance';
                              });
                            },
                          ),
                          QuickActionCard(
                            title: 'Upload Results',
                            emoji: '📊',
                            color: const Color(0xFF10B981),
                            onTap: () {
                              setState(() {
                                _selectedSection = 'results';
                              });
                            },
                          ),
                          QuickActionCard(
                            title: 'Schedule PTM',
                            emoji: '📅',
                            color: const Color(0xFF8B5CF6),
                            onTap: () {
                              setState(() {
                                _selectedSection = 'ptm';
                              });
                            },
                          ),
                          QuickActionCard(
                            title: 'Send Notice',
                            emoji: '📢',
                            color: const Color(0xFFF59E0B),
                            onTap: () {
                              setState(() {
                                _selectedSection = 'notices';
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'My Classes Overview',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...teachingClasses.map((className) => _buildClassOverviewCard(
                        context,
                        dataService,
                        className,
                        className == classTeacherOf,
                      )),
                    ],
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Recent Activities
          CustomCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Recent Activities',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ActivityCard(
                  title: 'Attendance Marked',
                  subtitle: 'Grade 11A - Mathematics (Today)',
                  color: const Color(0xFF3B82F6),
                  time: '2 hours ago',
                ),
                const SizedBox(height: 12),
                ActivityCard(
                  title: 'Results Uploaded',
                  subtitle: 'Grade 12A - Unit Test 2 (Yesterday)',
                  color: const Color(0xFF10B981),
                  time: '1 day ago',
                ),
                const SizedBox(height: 12),
                ActivityCard(
                  title: 'PTM Scheduled',
                  subtitle: 'Grade 11B - Parent Meeting',
                  color: const Color(0xFF8B5CF6),
                  time: '2 days ago',
                ),
                const SizedBox(height: 12),
                ActivityCard(
                  title: 'Notice Sent',
                  subtitle: 'Assignment Deadline - All Classes',
                  color: const Color(0xFFF59E0B),
                  time: '3 days ago',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClassOverviewCard(BuildContext context, DataService dataService, String className, bool isClassTeacher) {
    final students = dataService.getStudentsByClass(className);
    final todayDate = AppHelpers.getCurrentDateString();
    final todayPresent = students.where((s) => s.attendance[todayDate] == 'present').length;
    final attendancePercentage = students.isNotEmpty ? (todayPresent / students.length * 100).round() : 0;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[200]!),
        borderRadius: BorderRadius.circular(12),
        color: isClassTeacher ? const Color(0xFFF59E0B).withOpacity(0.05) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    className,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (isClassTeacher) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF59E0B).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star, size: 12, color: Color(0xFFF59E0B)),
                          SizedBox(width: 2),
                          Text(
                            'Class Teacher',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFF59E0B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF3B82F6).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${students.length} Students',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3B82F6),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Today's Attendance:",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                '$todayPresent/${students.length}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: students.isNotEmpty ? todayPresent / students.length : 0,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(
              attendancePercentage >= 90 ? const Color(0xFF10B981) : 
              attendancePercentage >= 75 ? const Color(0xFFF59E0B) : 
              const Color(0xFFEF4444),
            ),
            minHeight: 6,
          ),
          const SizedBox(height: 12),
          CustomButton(
            text: 'Mark Attendance',
            backgroundColor: const Color(0xFF3B82F6),
            onPressed: () => _showAttendanceForm(context, dataService, className),
            height: 32,
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
                  backgroundColor: const Color(0xFF10B981),
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
                        color: const Color(0xFF10B981).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'TEACHER',
                        style: TextStyle(
                          color: Color(0xFF10B981),
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
                _buildProfileField('Email', user.email),
                _buildProfileField('Phone', user.mobile),
                _buildProfileField('Subject', user.additionalData['subjects']?.join(', ') ?? 'Mathematics'),
                _buildProfileField('Teaching Classes', (user.additionalData['teachingClasses'] as List?)?.join(', ') ?? 'Grade 11A, Grade 11B'),
                _buildProfileField('Class Teacher Of', user.additionalData['classTeacherOf'] ?? 'Grade 11A'),
                _buildProfileField('Employee ID', 'TEA001'),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Change Password
          CustomCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Change Password',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                CustomButton(
                  text: 'Change Password',
                  backgroundColor: const Color(0xFFEF4444),
                  icon: const Icon(Icons.lock, size: 20),
                  onPressed: () => _showChangePassword(context),
                ),
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
            width: 140,
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

  Widget _buildAttendance(BuildContext context, DataService dataService) {
    final user = dataService.currentUser!;
    final teachingClasses = user.additionalData['teachingClasses'] as List? ?? ['Grade 11A', 'Grade 11B', 'Grade 12A'];
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Class Selection
          CustomCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Select Class for Attendance',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.2,
                  ),
                  itemCount: teachingClasses.length,
                  itemBuilder: (context, index) {
                    final className = teachingClasses[index];
                    final students = dataService.getStudentsByClass(className);
                    final isClassTeacher = className == (user.additionalData['classTeacherOf'] ?? 'Grade 11A');
                    
                    return CustomCard(
                      onTap: () => _showAttendanceForm(context, dataService, className),
                      color: isClassTeacher ? const Color(0xFFF59E0B).withOpacity(0.05) : null,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: const Color(0xFF3B82F6).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Center(
                              child: Text('👥', style: TextStyle(fontSize: 28)),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            className,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (isClassTeacher) ...[
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF59E0B).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.star, size: 12, color: Color(0xFFF59E0B)),
                                  SizedBox(width: 2),
                                  Text(
                                    'Class Teacher',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFF59E0B),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          const SizedBox(height: 8),
                          Text(
                            '${students.length} Students',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Attendance History
          CustomCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Recent Attendance Records',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Date', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Class', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Present', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Absent', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Percentage', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold))),
                    ],
                    rows: [
                      DataRow(
                        cells: [
                          DataCell(Text(AppHelpers.formatDate(DateTime.now()))),
                          const DataCell(Text('Grade 11A')),
                          const DataCell(Text('7', style: TextStyle(color: Color(0xFF10B981), fontWeight: FontWeight.bold))),
                          const DataCell(Text('1', style: TextStyle(color: Color(0xFFEF4444), fontWeight: FontWeight.bold))),
                          DataCell(
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFF10B981).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                '87.5%',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF10B981),
                                ),
                              ),
                            ),
                          ),
                          DataCell(
                            IconButton(
                              onPressed: () => _showAttendanceForm(context, dataService, 'Grade 11A'),
                              icon: const Icon(Icons.edit, color: Color(0xFF3B82F6)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResults(BuildContext context, DataService dataService) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Upload Form
          CustomCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Upload Results',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildResultsUploadForm(context, dataService),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Recent Results
          CustomCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Recent Results Uploaded',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Date', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Class', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Subject', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Exam Type', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Students', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold))),
                    ],
                    rows: [
