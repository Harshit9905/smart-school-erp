import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/data_service.dart';
import '../widgets/navigation_drawer.dart';
import '../widgets/custom_card.dart';
import '../widgets/custom_button.dart';
import '../widgets/modal_dialog.dart';
import '../utils/validators.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
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
            items: NavigationItems.getAdminItems(),
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
              backgroundColor: const Color(0xFFF59E0B),
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
      case 'students':
        return _buildStudents(context, dataService);
      case 'teachers':
        return _buildTeachers(context, dataService);
      case 'staff':
        return _buildStaff(context, dataService);
      case 'fees':
        return _buildFees(context, dataService);
      case 'attendance':
        return _buildAttendance(context, dataService);
      case 'results':
        return _buildResults(context, dataService);
      case 'transport':
        return _buildTransport(context, dataService);
      default:
        return _buildDashboard(context, dataService);
    }
  }

  Widget _buildDashboard(BuildContext context, DataService dataService) {
    final allStudents = dataService.getAllStudents();
    final allTeachers = dataService.getAllTeachers();
    final totalFeeCollection = 4520000.0; // Sample data
    final pendingIssues = 23; // Sample data
    
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
                colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${AppHelpers.getGreeting()}, ${dataService.currentUser!.name}! 👨‍💼',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Manage your school operations efficiently with comprehensive administrative tools.',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    CustomButton(
                      text: 'Manage Students',
                      backgroundColor: Colors.white.withOpacity(0.2),
                      onPressed: () {
                        setState(() {
                          _selectedSection = 'students';
                        });
                      },
                    ),
                    const SizedBox(width: 12),
                    CustomButton(
                      text: 'View Reports',
                      backgroundColor: Colors.white.withOpacity(0.2),
                      onPressed: () {
                        setState(() {
                          _selectedSection = 'fees';
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
                value: allStudents.length.toString(),
                subtitle: 'Active enrollment',
                emoji: '👨‍🎓',
                color: const Color(0xFF3B82F6),
                onTap: () {
                  setState(() {
                    _selectedSection = 'students';
                  });
                },
              ),
              StatCard(
                title: 'Teachers',
                value: allTeachers.length.toString(),
                subtitle: 'Faculty members',
                emoji: '👩‍🏫',
                color: const Color(0xFF10B981),
                onTap: () {
                  setState(() {
                    _selectedSection = 'teachers';
                  });
                },
              ),
              StatCard(
                title: 'Fee Collection',
                value: AppHelpers.formatCurrency(totalFeeCollection),
                subtitle: 'This academic year',
                emoji: '💰',
                color: const Color(0xFF8B5CF6),
                onTap: () {
                  setState(() {
                    _selectedSection = 'fees';
                  });
                },
              ),
              StatCard(
                title: 'Pending Issues',
                value: pendingIssues.toString(),
                subtitle: 'Requires attention',
                emoji: '⚠️',
                color: const Color(0xFFEF4444),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Quick Actions & Recent Activities
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
                            title: 'Students',
                            emoji: '👨‍🎓',
                            color: const Color(0xFF3B82F6),
                            onTap: () {
                              setState(() {
                                _selectedSection = 'students';
                              });
                            },
                          ),
                          QuickActionCard(
                            title: 'Teachers',
                            emoji: '👩‍🏫',
                            color: const Color(0xFF10B981),
                            onTap: () {
                              setState(() {
                                _selectedSection = 'teachers';
                              });
                            },
                          ),
                          QuickActionCard(
                            title: 'Fees',
                            emoji: '💰',
                            color: const Color(0xFF8B5CF6),
                            onTap: () {
                              setState(() {
                                _selectedSection = 'fees';
                              });
                            },
                          ),
                          QuickActionCard(
                            title: 'Results',
                            emoji: '📊',
                            color: const Color(0xFFF59E0B),
                            onTap: () {
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
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomCard(
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
                        title: 'New Student Admission',
                        subtitle: 'Rahul Kumar admitted to Grade 10A',
                        color: const Color(0xFF3B82F6),
                        time: '2 hours ago',
                      ),
                      const SizedBox(height: 12),
                      ActivityCard(
                        title: 'Fee Payment Received',
                        subtitle: '₹25,000 received from Grade 11B',
                        color: const Color(0xFF10B981),
                        time: '4 hours ago',
                      ),
                      const SizedBox(height: 12),
                      ActivityCard(
                        title: 'Results Published',
                        subtitle: 'Mid-term results for Grade 12',
                        color: const Color(0xFFF59E0B),
                        time: '1 day ago',
                      ),
                      const SizedBox(height: 12),
                      ActivityCard(
                        title: 'Teacher Salary Paid',
                        subtitle: 'Monthly salaries processed',
                        color: const Color(0xFF8B5CF6),
                        time: '2 days ago',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStudents(BuildContext context, DataService dataService) {
    final students = dataService.getAllStudents();
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: CustomCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Students Management',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 200,
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search students...',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    CustomButton(
                      text: 'Add Student',
                      backgroundColor: const Color(0xFF3B82F6),
                      icon: const Icon(Icons.add, size: 20),
                      onPressed: () => _showAddStudent(context, dataService),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Name', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Class', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Phone', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Attendance', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Fees', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Performance', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold))),
                ],
                rows: students.map((student) {
                  return DataRow(
                    cells: [
                      DataCell(Text(student.name)),
                      DataCell(Text(student.className)),
                      DataCell(Text(student.phone)),
                      DataCell(
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: student.attendanceRate >= 90 
                                ? const Color(0xFF10B981).withOpacity(0.1)
                                : const Color(0xFFEF4444).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${student.attendanceRate.toStringAsFixed(1)}%',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: student.attendanceRate >= 90 
                                  ? const Color(0xFF10B981)
                                  : const Color(0xFFEF4444),
                            ),
                          ),
                        ),
                      ),
                      DataCell(
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: student.feesStatus == 'Paid' 
                                ? const Color(0xFF10B981).withOpacity(0.1)
                                : const Color(0xFFEF4444).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            student.feesStatus,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: student.feesStatus == 'Paid' 
                                  ? const Color(0xFF10B981)
                                  : const Color(0xFFEF4444),
                            ),
                          ),
                        ),
                      ),
                      DataCell(
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 60,
                              child: LinearProgressIndicator(
                                value: student.performance / 100,
                                backgroundColor: Colors.grey[200],
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  student.performance >= 85 ? const Color(0xFF10B981) :
                                  student.performance >= 70 ? const Color(0xFFF59E0B) :
                                  const Color(0xFFEF4444),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${student.performance.toStringAsFixed(1)}%',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      DataCell(
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () => _editStudent(context, student, dataService),
                              icon: const Icon(Icons.edit, color: Color(0xFF3B82F6)),
                              tooltip: 'Edit Student',
                            ),
                            IconButton(
                              onPressed: () => _deleteStudent(context, student, dataService),
                              icon: const Icon(Icons.delete, color: Color(0xFFEF4444)),
                              tooltip: 'Delete Student',
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeachers(BuildContext context, DataService dataService) {
    final teachers = dataService.getAllTeachers();
    final totalPayroll = teachers.fold(0.0, (sum, teacher) => sum + teacher.salary);
    final paidThisMonth = teachers.where((t) => t.salaryStatus == 'Paid').fold(0.0, (sum, teacher) => sum + teacher.salary);
    final pendingPayments = teachers.where((t) => t.salaryStatus == 'Pending').fold(0.0, (sum, teacher) => sum + teacher.salary);
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Salary Overview
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1.5,
            children: [
              StatCard(
                title: 'Total Teachers',
                value: teachers.length.toString(),
                emoji: '👩‍🏫',
                color: const Color(0xFF3B82F6),
              ),
              StatCard(
                title: 'Monthly Payroll',
                value: AppHelpers.formatCurrency(totalPayroll),
                emoji: '💰',
                color: const Color(0xFF10B981),
              ),
              StatCard(
                title: 'Paid This Month',
                value: AppHelpers.formatCurrency(paidThisMonth),
                emoji: '✅',
                color: const Color(0xFF8B5CF6),
              ),
              StatCard(
                title: 'Pending Payments',
                value: AppHelpers.formatCurrency(pendingPayments),
                emoji: '⏳',
                color: const Color(0xFFEF4444),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Teachers Management
          CustomCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Teachers Management & Salary',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 200,
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Search teachers...',
                              prefixIcon: const Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        CustomButton(
                          text: 'Pay All Salaries',
                          backgroundColor: const Color(0xFF10B981),
                          icon: const Icon(Icons.payment, size: 20),
                          onPressed: () => _payAllSalaries(context, dataService, 'teachers'),
                        ),
                        const SizedBox(width: 8),
                        CustomButton(
                          text: 'Add Teacher',
                          backgroundColor: const Color(0xFF3B82F6),
                          icon: const Icon(Icons.add, size: 20),
                          onPressed: () => _showAddTeacher(context, dataService),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Name', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Subject', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Phone', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Monthly Salary', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Salary Status', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Last Paid', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold))),
                    ],
                    rows: teachers.map((teacher) {
                      return DataRow(
                        cells: [
                          DataCell(Text(teacher.name)),
                          DataCell(Text(teacher.subject)),
                          DataCell(Text(teacher.phone)),
                          DataCell(Text(AppHelpers.formatCurrency(teacher.salary))),
                          DataCell(
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: teacher.salaryStatus == 'Paid' 
                                    ? const Color(0xFF10B981).withOpacity(0.1)
                                    : const Color(0xFFEF4444).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                teacher.salaryStatus,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: teacher.salaryStatus == 'Paid' 
                                      ? const Color(0xFF10B981)
                                      : const Color(0xFFEF4444),
                                ),
                              ),
                            ),
                          ),
                          DataCell(Text(teacher.lastPaid, style: TextStyle(fontSize: 12, color: Colors.grey[600]))),
                          DataCell(
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: teacher.status == 'Active' 
                                    ? const Color(0xFF10B981).withOpacity(0.1)
                                    : const Color(0xFFEF4444).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                teacher.status,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: teacher.status == 'Active' 
                                      ? const Color(0xFF10B981)
                                      : const Color(0xFFEF4444),
                                ),
                              ),
                            ),
                          ),
                          DataCell(
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () => _paySalary(context, teacher, dataService),
                                  icon: const Icon(Icons.payment, color: Color(0xFF10B981)),
                                  tooltip: 'Pay Salary',
                                ),
                                IconButton(
                                  onPressed: () => _viewSalaryHistory(context, teacher, dataService),
                                  icon: const Icon(Icons.history, color: Color(0xFF8B5CF6)),
                                  tooltip: 'Salary History',
                                ),
                                IconButton(
                                  onPressed: () => _editTeacher(context, teacher, dataService),
                                  icon: const Icon(Icons.edit, color: Color(0xFF3B82F6)),
                                  tooltip: 'Edit Teacher',
                                ),
                                IconButton(
                                  onPressed: () => _deleteTeacher(context, teacher, dataService),
                                  icon: const Icon(Icons.delete, color: Color(0xFFEF4444)),
                                  tooltip: 'Delete Teacher',
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStaff(BuildContext context, DataService dataService) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: CustomCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Non-Teaching Staff Management',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    CustomButton(
                      text: 'Pay All Salaries',
                      backgroundColor: const Color(0xFF10B981),
                      icon: const Icon(Icons.payment, size: 20),
                      onPressed: () => _payAllSalaries(context, dataService, 'staff'),
                    ),
                    const SizedBox(width: 8),
                    CustomButton(
                      text: 'Add Staff',
                      backgroundColor: const Color(0xFF3B82F6),
                      icon: const Icon(Icons.add, size: 20),
                      onPressed: () => _showAddStaff(context, dataService),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Column(
                  children: [
                    Icon(Icons.people, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text('Staff management coming soon...', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFees(BuildContext context, DataService dataService) {
    final students = dataService.getAllStudents();
    final totalCollected = 4520000.0;
    final pending = 850000.0;
    final thisMonth = 1230000.0;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Fee Overview
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1.5,
            children: [
              StatCard(
                title: 'Total Collected',
                value: AppHelpers.formatCurrency(totalCollected),
                emoji: '💰',
                color: const Color(0xFF10B981),
              ),
              StatCard(
                title: 'Pending',
                value: AppHelpers.formatCurrency(pending),
                emoji: '⏳',
                color: const Color(0xFFEF4444),
              ),
              StatCard(
                title: 'This Month',
                value: AppHelpers.formatCurrency(thisMonth),
                emoji: '📅',
                color: const Color(0xFF3B82F6),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Fee Management
          CustomCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Fees Management',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Student Name', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Class', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Fee Amount', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Paid Amount', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Due Amount', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold))),
                    ],
                    rows: students.take(10).map((student) {
                      final feeAmount = 50000.0;
                      final paidAmount = student.feesStatus == 'Paid' ? feeAmount : 25000.0;
                      final dueAmount = feeAmount - paidAmount;
                      
                      return DataRow(
                        cells: [
                          DataCell(Text(student.name)),
                          DataCell(Text(student.
