import 'package:flutter/foundation.dart';
import '../models/user_model.dart';

class DataService extends ChangeNotifier {
  User? _currentUser;
  String? _selectedRole;
  List<CartItem> _cart = [];
  List<PTMSchedule> _ptmSchedules = [];
  List<Notice> _notices = [];

  User? get currentUser => _currentUser;
  String? get selectedRole => _selectedRole;
  List<CartItem> get cart => _cart;
  List<PTMSchedule> get ptmSchedules => _ptmSchedules;
  List<Notice> get notices => _notices;

  // Sample user data
  final Map<String, Map<String, dynamic>> _users = {
    'STU001': {
      'name': 'Akash Singh',
      'role': 'student',
      'class': 'Grade 11 - Science',
      'avatar': 'AS',
      'mobile': '+91 9876543210',
      'email': 'akash.singh@student.greenwood.edu',
      'parentName': 'Rajesh Singh',
      'parentMobile': '+91 9876543212',
      'subjects': ['Mathematics', 'Physics', 'Chemistry', 'Biology', 'English'],
      'assignedTeachers': {
        'Mathematics': 'Dr. Priya Sharma',
        'Physics': 'Prof. Amit Kumar',
        'Chemistry': 'Dr. Neha Gupta',
        'Biology': 'Ms. Ritu Verma',
        'English': 'Mr. David Wilson'
      },
    },
    'TEA001': {
      'name': 'Dr. Priya Sharma',
      'role': 'teacher',
      'class': 'Mathematics Teacher',
      'avatar': 'PS',
      'mobile': '+91 9876543211',
      'email': 'priya.sharma@greenwood.edu',
      'subjects': ['Mathematics', 'Statistics'],
      'teachingClasses': ['Grade 11A', 'Grade 11B', 'Grade 12A'],
      'classTeacherOf': 'Grade 11A',
    },
    'PAR001': {
      'name': 'Rajesh Kumar',
      'role': 'parent',
      'class': 'Parent of Akash Singh',
      'avatar': 'RK',
      'mobile': '+91 9876543212',
      'email': 'rajesh.kumar@gmail.com',
      'childName': 'Akash Singh',
      'childClass': 'Grade 11 - Science',
      'childId': 'STU001'
    },
    'ADM001': {
      'name': 'Principal Johnson',
      'role': 'admin',
      'class': 'School Administrator',
      'avatar': 'PJ',
      'mobile': '+91 9876543213',
      'email': 'principal@greenwood.edu'
    }
  };

  // Sample students data
  final Map<String, List<Student>> _studentsData = {
    'Grade 11A': [
      Student(id: 1, name: 'Akash Singh', rollNo: '11A001', className: 'Grade 11A', attendanceRate: 95.2, feesStatus: 'Paid', performance: 85.4, phone: '9876543210'),
      Student(id: 2, name: 'Priya Patel', rollNo: '11A002', className: 'Grade 11A', attendanceRate: 92.8, feesStatus: 'Pending', performance: 88.7, phone: '9876543211'),
      Student(id: 3, name: 'Rahul Sharma', rollNo: '11A003', className: 'Grade 11A', attendanceRate: 89.5, feesStatus: 'Paid', performance: 82.1, phone: '9876543212'),
      Student(id: 4, name: 'Sneha Gupta', rollNo: '11A004', className: 'Grade 11A', attendanceRate: 96.3, feesStatus: 'Paid', performance: 91.2, phone: '9876543213'),
      Student(id: 5, name: 'Arjun Kumar', rollNo: '11A005', className: 'Grade 11A', attendanceRate: 87.2, feesStatus: 'Pending', performance: 79.8, phone: '9876543214'),
      Student(id: 6, name: 'Kavya Singh', rollNo: '11A006', className: 'Grade 11A', attendanceRate: 94.1, feesStatus: 'Paid', performance: 86.5, phone: '9876543215'),
      Student(id: 7, name: 'Rohit Verma', rollNo: '11A007', className: 'Grade 11A', attendanceRate: 91.7, feesStatus: 'Paid', performance: 83.9, phone: '9876543216'),
      Student(id: 8, name: 'Anita Yadav', rollNo: '11A008', className: 'Grade 11A', attendanceRate: 88.3, feesStatus: 'Pending', performance: 80.2, phone: '9876543217'),
    ],
    'Grade 11B': [
      Student(id: 9, name: 'Vikram Das', rollNo: '11B001', className: 'Grade 11B', attendanceRate: 93.5, feesStatus: 'Paid', performance: 84.6, phone: '9876543218'),
      Student(id: 10, name: 'Pooja Kumari', rollNo: '11B002', className: 'Grade 11B', attendanceRate: 90.2, feesStatus: 'Pending', performance: 87.3, phone: '9876543219'),
      Student(id: 11, name: 'Amit Gupta', rollNo: '11B003', className: 'Grade 11B', attendanceRate: 95.8, feesStatus: 'Paid', performance: 89.1, phone: '9876543220'),
      Student(id: 12, name: 'Riya Sharma', rollNo: '11B004', className: 'Grade 11B', attendanceRate: 87.9, feesStatus: 'Paid', performance: 81.7, phone: '9876543221'),
      Student(id: 13, name: 'Deepak Singh', rollNo: '11B005', className: 'Grade 11B', attendanceRate: 92.4, feesStatus: 'Pending', performance: 85.8, phone: '9876543222'),
      Student(id: 14, name: 'Neha Patel', rollNo: '11B006', className: 'Grade 11B', attendanceRate: 89.6, feesStatus: 'Paid', performance: 83.4, phone: '9876543223'),
    ],
    'Grade 12A': [
      Student(id: 15, name: 'Sanjay Kumar', rollNo: '12A001', className: 'Grade 12A', attendanceRate: 94.7, feesStatus: 'Paid', performance: 88.9, phone: '9876543224'),
      Student(id: 16, name: 'Meera Singh', rollNo: '12A002', className: 'Grade 12A', attendanceRate: 91.3, feesStatus: 'Pending', performance: 86.2, phone: '9876543225'),
      Student(id: 17, name: 'Rajesh Yadav', rollNo: '12A003', className: 'Grade 12A', attendanceRate: 96.1, feesStatus: 'Paid', performance: 90.5, phone: '9876543226'),
      Student(id: 18, name: 'Sunita Devi', rollNo: '12A004', className: 'Grade 12A', attendanceRate: 88.7, feesStatus: 'Paid', performance: 82.8, phone: '9876543227'),
      Student(id: 19, name: 'Kiran Gupta', rollNo: '12A005', className: 'Grade 12A', attendanceRate: 93.2, feesStatus: 'Pending', performance: 87.6, phone: '9876543228'),
    ],
  };

  // Sample teachers data
  final List<Teacher> _teachersData = [
    Teacher(id: 1, name: 'Dr. Priya Sharma', subject: 'Mathematics', phone: '9876543220', salary: 65000, status: 'Active', salaryStatus: 'Paid', lastPaid: '15 Dec 2024'),
    Teacher(id: 2, name: 'Mr. Rajesh Kumar', subject: 'Physics', phone: '9876543221', salary: 58000, status: 'Active', salaryStatus: 'Pending', lastPaid: '15 Nov 2024'),
    Teacher(id: 3, name: 'Ms. Anita Singh', subject: 'Chemistry', phone: '9876543222', salary: 62000, status: 'Active', salaryStatus: 'Paid', lastPaid: '15 Dec 2024'),
    Teacher(id: 4, name: 'Mr. Suresh Patel', subject: 'English', phone: '9876543223', salary: 55000, status: 'Inactive', salaryStatus: 'Pending', lastPaid: '15 Oct 2024'),
    Teacher(id: 5, name: 'Ms. Kavita Gupta', subject: 'Biology', phone: '9876543224', salary: 60000, status: 'Active', salaryStatus: 'Pending', lastPaid: '15 Nov 2024'),
  ];

  // Sample products for school shop
  final List<Product> _products = [
    Product(id: 1, name: 'Mathematics Textbook Grade 11', category: 'books', price: 450, imageIcon: '📚', rating: 4.8),
    Product(id: 2, name: 'Physics Textbook Grade 11', category: 'books', price: 520, imageIcon: '📖', rating: 4.7),
    Product(id: 3, name: 'School Uniform Shirt', category: 'uniform', price: 650, imageIcon: '👔', rating: 4.8),
    Product(id: 4, name: 'School Uniform Trousers', category: 'uniform', price: 850, imageIcon: '👖', rating: 4.7),
    Product(id: 5, name: 'Premium Pen Set (Pack of 10)', category: 'stationery', price: 120, imageIcon: '✏️', rating: 4.4),
    Product(id: 6, name: 'Pencil Set (Pack of 12)', category: 'stationery', price: 80, imageIcon: '✏️', rating: 4.6),
    Product(id: 7, name: 'Complete Geometry Box Set', category: 'stationery', price: 280, imageIcon: '📐', rating: 4.8),
    Product(id: 8, name: 'School Backpack', category: 'accessories', price: 1500, imageIcon: '🎒', rating: 4.8),
  ];

  // Authentication
  Future<bool> login(String loginId, String password, String role) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate API call
    
    if (_users.containsKey(loginId) && _users[loginId]!['role'] == role) {
      _currentUser = User.fromMap({
        'id': loginId,
        ..._users[loginId]!,
      });
      _selectedRole = role;
      notifyListeners();
      return true;
    }
    return false;
  }

  void logout() {
    _currentUser = null;
    _selectedRole = null;
    _cart.clear();
    notifyListeners();
  }

  // Students data
  List<Student> getStudentsByClass(String className) {
    return _studentsData[className] ?? [];
  }

  List<Student> getAllStudents() {
    return _studentsData.values.expand((students) => students).toList();
  }

  // Teachers data
  List<Teacher> getAllTeachers() {
    return _teachersData;
  }

  // Products data
  List<Product> getAllProducts() {
    return _products;
  }

  List<Product> getProductsByCategory(String category) {
    if (category == 'all') return _products;
    return _products.where((product) => product.category == category).toList();
  }

  // Cart management
  void addToCart(Product product) {
    final existingIndex = _cart.indexWhere((item) => item.product.id == product.id);
    if (existingIndex >= 0) {
      _cart[existingIndex].quantity++;
    } else {
      _cart.add(CartItem(product: product));
    }
    notifyListeners();
  }

  void removeFromCart(int productId) {
    _cart.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  void updateCartQuantity(int productId, int quantity) {
    final index = _cart.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      if (quantity <= 0) {
        _cart.removeAt(index);
      } else {
        _cart[index].quantity = quantity;
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  double get cartTotal {
    return _cart.fold(0.0, (total, item) => total + item.totalPrice);
  }

  int get cartItemCount {
    return _cart.fold(0, (total, item) => total + item.quantity);
  }

  // PTM management
  void addPTMSchedule(PTMSchedule schedule) {
    _ptmSchedules.add(schedule);
    notifyListeners();
  }

  void removePTMSchedule(int id) {
    _ptmSchedules.removeWhere((schedule) => schedule.id == id);
    notifyListeners();
  }

  // Notice management
  void addNotice(Notice notice) {
    _notices.add(notice);
    notifyListeners();
  }

  void removeNotice(int id) {
    _notices.removeWhere((notice) => notice.id == id);
    notifyListeners();
  }

  // Attendance management
  Future<void> markAttendance(String className, int studentId, String status, String date) async {
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate API call
    
    final students = _studentsData[className];
    if (students != null) {
      final studentIndex = students.indexWhere((s) => s.id == studentId);
      if (studentIndex >= 0) {
        students[studentIndex].attendance[date] = status;
        notifyListeners();
      }
    }
  }

  // Get attendance for a specific date and class
  Map<int, String> getAttendanceForDate(String className, String date) {
    final students = _studentsData[className] ?? [];
    final attendance = <int, String>{};
    
    for (final student in students) {
      attendance[student.id] = student.attendance[date] ?? '';
    }
    
    return attendance;
  }

  // Salary management
  Future<void> paySalary(int teacherId) async {
    await Future.delayed(const Duration(seconds: 2)); // Simulate payment processing
    
    final teacherIndex = _teachersData.indexWhere((t) => t.id == teacherId);
    if (teacherIndex >= 0) {
      // In a real app, you would update the teacher's salary status
      // For now, we'll just simulate the payment
      notifyListeners();
    }
  }
}
