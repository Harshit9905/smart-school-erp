// Complete methods for teacher_dashboard.dart
// These methods should be added to the _TeacherDashboardState class

import 'package:flutter/material.dart';
import '../services/data_service.dart';
import '../widgets/custom_card.dart';
import '../widgets/custom_button.dart';
import '../widgets/modal_dialog.dart';
import '../utils/validators.dart';

// Complete the DataTable rows for recent results
DataRow(
  cells: [
    DataCell(Text(AppHelpers.formatDate(DateTime.now()))),
    const DataCell(Text('Grade 11A')),
    const DataCell(Text('Mathematics')),
    const DataCell(Text('Unit Test 2')),
    const DataCell(Text('8 Students')),
    DataCell(
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.visibility, color: Color(0xFF3B82F6)),
            tooltip: 'View Results',
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.edit, color: Color(0xFF10B981)),
            tooltip: 'Edit Results',
          ),
        ],
      ),
    ),
  ],
),

Widget _buildResultsUploadForm(BuildContext context, DataService dataService) {
  final user = dataService.currentUser!;
  final teachingClasses = user.additionalData['teachingClasses'] as List? ?? ['Grade 11A', 'Grade 11B', 'Grade 12A'];
  
  return Column(
    children: [
      Row(
        children: [
          Expanded(
            child: DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Select Class',
                border: OutlineInputBorder(),
              ),
              items: teachingClasses.map((className) {
                return DropdownMenuItem(
                  value: className,
                  child: Text(className),
                );
              }).toList(),
              onChanged: (value) {},
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: TextFormField(
              decoration: InputDecoration(
                labelText: 'Subject',
                border: const OutlineInputBorder(),
                hintText: user.additionalData['subjects']?.first ?? 'Mathematics',
              ),
              initialValue: user.additionalData['subjects']?.first ?? 'Mathematics',
              readOnly: true,
            ),
          ),
        ],
      ),
      const SizedBox(height: 16),
      Row(
        children: [
          Expanded(
            child: DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Exam Type',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'Unit Test 1', child: Text('Unit Test 1')),
                DropdownMenuItem(value: 'Unit Test 2', child: Text('Unit Test 2')),
                DropdownMenuItem(value: 'Mid Term', child: Text('Mid Term Exam')),
                DropdownMenuItem(value: 'Final Term', child: Text('Final Term Exam')),
                DropdownMenuItem(value: 'Assignment', child: Text('Assignment')),
              ],
              onChanged: (value) {},
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: TextFormField(
              decoration: const InputDecoration(
                labelText: 'Maximum Marks',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) => Validators.validateNumber(value, min: 1, max: 1000),
            ),
          ),
        ],
      ),
      const SizedBox(height: 24),
      SizedBox(
        width: double.infinity,
        child: CustomButton(
          text: 'Proceed to Enter Marks',
          backgroundColor: const Color(0xFF10B981),
          icon: const Icon(Icons.arrow_forward, size: 20),
          onPressed: () => _showMarksEntryForm(context, dataService),
        ),
      ),
    ],
  );
}

Widget _buildPTM(BuildContext context, DataService dataService) {
  return SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: Column(
      children: [
        // Create PTM Schedule
        CustomCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Schedule Parent-Teacher Meeting',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildPTMForm(context, dataService),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Scheduled PTMs
        CustomCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Scheduled PTMs',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      CustomButton(
                        text: 'Upcoming',
                        backgroundColor: const Color(0xFF3B82F6),
                        onPressed: () {},
                        height: 32,
                      ),
                      const SizedBox(width: 8),
                      OutlineButton(
                        text: 'Past',
                        onPressed: () {},
                        height: 32,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (dataService.ptmSchedules.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Column(
                      children: [
                        Icon(Icons.event_busy, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text('No PTMs scheduled yet', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                )
              else
                ...dataService.ptmSchedules.map((ptm) => _buildPTMCard(context, ptm, dataService)),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _buildPTMForm(BuildContext context, DataService dataService) {
  final user = dataService.currentUser!;
  final teachingClasses = user.additionalData['teachingClasses'] as List? ?? ['Grade 11A', 'Grade 11B', 'Grade 12A'];
  final formKey = GlobalKey<FormState>();
  
  String? selectedClass;
  final dateController = TextEditingController();
  final startTimeController = TextEditingController();
  final endTimeController = TextEditingController();
  final purposeController = TextEditingController();
  final locationController = TextEditingController();
  
  return Form(
    key: formKey,
    child: Column(
      children: [
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Select Class',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => Validators.validateRequired(value, 'Class'),
                items: teachingClasses.map((className) {
                  return DropdownMenuItem(
                    value: className,
                    child: Text(className),
                  );
                }).toList(),
                onChanged: (value) {
                  selectedClass = value;
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: dateController,
                decoration: const InputDecoration(
                  labelText: 'Meeting Date',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                validator: Validators.validateDate,
                readOnly: true,
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now().add(const Duration(days: 1)),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) {
                    dateController.text = date.toIso8601String().split('T')[0];
                  }
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: startTimeController,
                decoration: const InputDecoration(
                  labelText: 'Start Time',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.access_time),
                ),
                validator: Validators.validateTime,
                readOnly: true,
                onTap: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (time != null) {
                    startTimeController.text = time.format(context);
                  }
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: endTimeController,
                decoration: const InputDecoration(
                  labelText: 'End Time',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.access_time),
                ),
                validator: Validators.validateTime,
                readOnly: true,
                onTap: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (time != null) {
                    endTimeController.text = time.format(context);
                  }
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: purposeController,
          decoration: const InputDecoration(
            labelText: 'Meeting Purpose',
            border: OutlineInputBorder(),
          ),
          validator: (value) => Validators.validateRequired(value, 'Purpose'),
          maxLines: 3,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: locationController,
          decoration: const InputDecoration(
            labelText: 'Meeting Location',
            border: OutlineInputBorder(),
            hintText: 'e.g., Classroom 11A, School Hall',
          ),
          validator: (value) => Validators.validateRequired(value, 'Location'),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: CustomButton(
            text: 'Schedule PTM',
            backgroundColor: const Color(0xFF8B5CF6),
            icon: const Icon(Icons.event, size: 20),
            onPressed: () {
              if (formKey.currentState!.validate() && selectedClass != null) {
                final ptm = PTMSchedule(
                  id: dataService.ptmSchedules.length + 1,
                  className: selectedClass!,
                  date: dateController.text,
                  startTime: startTimeController.text,
                  endTime: endTimeController.text,
                  purpose: purposeController.text,
                  location: locationController.text,
                  createdAt: DateTime.now(),
                );
                
                dataService.addPTMSchedule(ptm);
                _showPTMSuccess(context, ptm, dataService);
                
                // Clear form
                formKey.currentState!.reset();
                dateController.clear();
                startTimeController.clear();
                endTimeController.clear();
                purposeController.clear();
                locationController.clear();
              }
            },
          ),
        ),
      ],
    ),
  );
}

Widget _buildPTMCard(BuildContext context, PTMSchedule ptm, DataService dataService) {
  final isUpcoming = DateTime.parse(ptm.date).isAfter(DateTime.now());
  
  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey[200]!),
      borderRadius: BorderRadius.circular(12),
      color: isUpcoming ? Colors.green.withOpacity(0.05) : Colors.grey.withOpacity(0.05),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${ptm.className} - PTM',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: isUpcoming ? const Color(0xFF10B981).withOpacity(0.1) : Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                isUpcoming ? 'Upcoming' : 'Completed',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isUpcoming ? const Color(0xFF10B981) : Colors.grey[600],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          ptm.purpose,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
            const SizedBox(width: 4),
            Text(
              AppHelpers.formatDate(DateTime.parse(ptm.date)),
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            const SizedBox(width: 16),
            Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
            const SizedBox(width: 4),
            Text(
              '${ptm.startTime} - ${ptm.endTime}',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            const SizedBox(width: 16),
            Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
            const SizedBox(width: 4),
            Text(
              ptm.location,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              onPressed: () => _editPTM(context, ptm, dataService),
              icon: const Icon(Icons.edit, color: Color(0xFF3B82F6)),
              tooltip: 'Edit PTM',
            ),
            IconButton(
              onPressed: () => _deletePTM(context, ptm, dataService),
              icon: const Icon(Icons.delete, color: Color(0xFFEF4444)),
              tooltip: 'Delete PTM',
            ),
          ],
        ),
      ],
    ),
  );
}

Widget _buildNotices(BuildContext context, DataService dataService) {
  return SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: Column(
      children: [
        // Create Notice
        CustomCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Create New Notice',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildNoticeForm(context, dataService),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Sent Notices
        CustomCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Sent Notices',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              if (dataService.notices.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Column(
                      children: [
                        Icon(Icons.announcement, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text('No notices sent yet', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                )
              else
                ...dataService.notices.map((notice) => _buildNoticeCard(context, notice, dataService)),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _buildNoticeForm(BuildContext context, DataService dataService) {
  final user = dataService.currentUser!;
  final teachingClasses = user.additionalData['teachingClasses'] as List? ?? ['Grade 11A', 'Grade 11B', 'Grade 12A'];
  final formKey = GlobalKey<FormState>();
  
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  String? selectedRecipients;
  String selectedPriority = 'normal';
  bool sendSMS = false;
  bool sendEmail = false;
  
  return Form(
    key: formKey,
    child: Column(
      children: [
        TextFormField(
          controller: titleController,
          decoration: const InputDecoration(
            labelText: 'Notice Title',
            border: OutlineInputBorder(),
          ),
          validator: Validators.validateNoticeTitle,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: contentController,
          decoration: const InputDecoration(
            labelText: 'Notice Content',
            border: OutlineInputBorder(),
          ),
          validator: Validators.validateNoticeContent,
          maxLines: 4,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Select Recipients',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => Validators.validateRequired(value, 'Recipients'),
                items: [
                  const DropdownMenuItem(value: 'all', child: Text('All My Classes')),
                  ...teachingClasses.map((className) {
                    return DropdownMenuItem(
                      value: className,
                      child: Text(className),
                    );
                  }),
                ],
                onChanged: (value) {
                  selectedRecipients = value;
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Priority',
                  border: OutlineInputBorder(),
                ),
                value: selectedPriority,
                items: const [
                  DropdownMenuItem(value: 'normal', child: Text('Normal')),
                  DropdownMenuItem(value: 'high', child: Text('High')),
                  DropdownMenuItem(value: 'urgent', child: Text('Urgent')),
                ],
                onChanged: (value) {
                  selectedPriority = value!;
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: CheckboxListTile(
                title: const Text('Send SMS to Parents'),
                value: sendSMS,
                onChanged: (value) {
                  setState(() {
                    sendSMS = value!;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),
            ),
            Expanded(
              child: CheckboxListTile(
                title: const Text('Send Email Notification'),
                value: sendEmail,
                onChanged: (value) {
                  setState(() {
                    sendEmail = value!;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: CustomButton(
            text: 'Send Notice',
            backgroundColor: const Color(0xFFF59E0B),
            icon: const Icon(Icons.send, size: 20),
            onPressed: () {
              if (formKey.currentState!.validate() && selectedRecipients != null) {
                final notice = Notice(
                  id: dataService.notices.length + 1,
                  title: titleController.text,
                  content: contentController.text,
                  recipients: selectedRecipients!,
                  priority: selectedPriority,
                  sendSMS: sendSMS,
                  sendEmail: sendEmail,
                  date: DateTime.now(),
                );
                
                dataService.addNotice(notice);
                _showNoticeSuccess(context, notice, dataService);
                
                // Clear form
                formKey.currentState!.reset();
                titleController.clear();
                contentController.clear();
                setState(() {
                  sendSMS = false;
                  sendEmail = false;
                });
              }
            },
          ),
        ),
      ],
    ),
  );
}

Widget _buildNoticeCard(BuildContext context, Notice notice, DataService dataService) {
  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: AppHelpers.getPriorityColor(notice.priority).withOpacity(0.05),
      borderRadius: BorderRadius.circular(12),
      border: Border(
        left: BorderSide(
          color: AppHelpers.getPriorityColor(notice.priority),
          width: 4,
        ),
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      notice.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppHelpers.getPriorityColor(notice.priority).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      notice.priority.toUpperCase(),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: AppHelpers.getPriorityColor(notice.priority),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (notice.sendSMS)
                  const Icon(Icons.sms, color: Color(0xFF10B981), size: 16),
                if (notice.sendEmail)
                  const Icon(Icons.email, color: Color(0xFF3B82F6), size: 16),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () => _editNotice(context, notice, dataService),
                  icon: const Icon(Icons.edit, color: Color(0xFF3B82F6), size: 20),
                ),
                IconButton(
                  onPressed: () => _deleteNotice(context, notice, dataService),
                  icon: const Icon(Icons.delete, color: Color(0xFFEF4444), size: 20),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          notice.content,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Icon(Icons.people, size: 16, color: Colors.grey[600]),
            const SizedBox(width: 4),
            Text(
              notice.recipients == 'all' ? 'All Classes' : notice.recipients,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            const SizedBox(width: 16),
            Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
            const SizedBox(width: 4),
            Text(
              AppHelpers.formatDate(notice.date),
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            const SizedBox(width: 16),
            Icon(Icons.visibility, size: 16, color: Colors.grey[600]),
            const SizedBox(width: 4),
            Text(
              '${notice.views} views',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
      ],
    ),
  );
}

// Helper methods
int _getTotalStudents(DataService dataService, List<String> teachingClasses) {
  return teachingClasses.fold(0, (total, className) {
    return total + dataService.getStudentsByClass(className).length;
  });
}

int _getTodayAttendance(DataService dataService, List<String> teachingClasses) {
  final todayDate = AppHelpers.getCurrentDateString();
  return teachingClasses.fold(0, (total, className) {
    final students = dataService.getStudentsByClass(className);
    return total + students.where((s) => s.attendance[todayDate] == 'present').length;
  });
}

int _getAttendancePercentage(DataService dataService, List<String> teachingClasses) {
  final totalStudents = _getTotalStudents(dataService, teachingClasses);
  final todayPresent = _getTodayAttendance(dataService, teachingClasses);
  return totalStudents > 0 ? (todayPresent / totalStudents * 100).round() : 0;
}

String _getSectionTitle() {
  switch (_selectedSection) {
    case 'dashboard':
      return 'Teacher Dashboard';
    case 'profile':
      return 'My Profile';
    case 'attendance':
      return 'Attendance Management';
    case 'results':
      return 'Results Upload';
    case 'ptm':
      return 'PTM Scheduling';
    case 'notices':
      return 'Notices & Announcements';
    default:
      return 'Teacher Dashboard';
  }
}

// Modal and dialog methods
void _showNotifications(BuildContext context) {
  ModalDialog.show(
    context: context,
    title: 'Notifications',
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildNotificationItem(
          'New PTM Request',
          'Parent of Akash Singh requested meeting',
          '2 hours ago',
          true,
        ),
        _buildNotificationItem(
          'Assignment Submission',
          'Grade 11A - 5 new submissions received',
          '4 hours ago',
          true,
        ),
        _buildNotificationItem(
          'System Update',
          'New features added to teacher portal',
          '1 day ago',
          false,
        ),
      ],
    ),
    actions: [
      OutlineButton(
        text: 'Mark All Read',
        onPressed: () => Navigator.of(context).pop(),
      ),
      const SizedBox(width: 8),
      CustomButton(
        text: 'Close',
        onPressed: () => Navigator.of(context).pop(),
      ),
    ],
  );
}

Widget _buildNotificationItem(String title, String subtitle, String time, bool isUnread) {
  return Container(
    padding: const EdgeInsets.all(12),
    margin: const EdgeInsets.only(bottom: 8),
    decoration: BoxDecoration(
      color: isUnread ? Colors.blue.withOpacity(0.05) : Colors.grey.withOpacity(0.05),
      borderRadius: BorderRadius.circular(8),
      border: isUnread ? Border.all(color: Colors.blue.withOpacity(0.2)) : null,
    ),
    child: Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: isUnread ? Colors.blue : Colors.grey,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isUnread ? FontWeight.bold : FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                time,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

void _showProfileMenu(BuildContext context) {
  // Implementation for profile menu
}

void _showEditProfile(BuildContext context, user) {
  // Implementation for edit profile
}

void _showChangePassword(BuildContext context) {
  // Implementation for change password
}

void _showAttendanceForm(BuildContext context, DataService dataService, String className) {
  final students = dataService.getStudentsByClass(className);
  final todayDate = AppHelpers.getCurrentDateString();
  
  ModalDialog.show(
    context: context,
    title: 'Mark Attendance - $className',
    width: 600,
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF3B82F6).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    className,
                    style: const TextStyle
