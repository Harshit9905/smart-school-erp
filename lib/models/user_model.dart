class User {
  final String id;
  final String name;
  final String role;
  final String className;
  final String avatar;
  final String mobile;
  final String email;
  final Map<String, dynamic> additionalData;

  User({
    required this.id,
    required this.name,
    required this.role,
    required this.className,
    required this.avatar,
    required this.mobile,
    required this.email,
    this.additionalData = const {},
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      role: map['role'] ?? '',
      className: map['class'] ?? '',
      avatar: map['avatar'] ?? '',
      mobile: map['mobile'] ?? '',
      email: map['email'] ?? '',
      additionalData: Map<String, dynamic>.from(map)..removeWhere((key, value) => 
        ['id', 'name', 'role', 'class', 'avatar', 'mobile', 'email'].contains(key)),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'role': role,
      'class': className,
      'avatar': avatar,
      'mobile': mobile,
      'email': email,
      ...additionalData,
    };
  }
}

class Student {
  final int id;
  final String name;
  final String rollNo;
  final String className;
  final Map<String, String> attendance;
  final double attendanceRate;
  final String feesStatus;
  final double performance;
  final String phone;

  Student({
    required this.id,
    required this.name,
    required this.rollNo,
    required this.className,
    this.attendance = const {},
    this.attendanceRate = 0.0,
    this.feesStatus = 'Pending',
    this.performance = 0.0,
    required this.phone,
  });

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      rollNo: map['rollNo'] ?? '',
      className: map['class'] ?? '',
      attendance: Map<String, String>.from(map['attendance'] ?? {}),
      attendanceRate: (map['attendanceRate'] ?? 0.0).toDouble(),
      feesStatus: map['fees'] ?? 'Pending',
      performance: (map['performance'] ?? 0.0).toDouble(),
      phone: map['phone'] ?? '',
    );
  }
}

class Teacher {
  final int id;
  final String name;
  final String subject;
  final String phone;
  final double salary;
  final String status;
  final String salaryStatus;
  final String lastPaid;

  Teacher({
    required this.id,
    required this.name,
    required this.subject,
    required this.phone,
    required this.salary,
    this.status = 'Active',
    this.salaryStatus = 'Pending',
    required this.lastPaid,
  });

  factory Teacher.fromMap(Map<String, dynamic> map) {
    return Teacher(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      subject: map['subject'] ?? '',
      phone: map['phone'] ?? '',
      salary: (map['salary'] ?? 0.0).toDouble(),
      status: map['status'] ?? 'Active',
      salaryStatus: map['salaryStatus'] ?? 'Pending',
      lastPaid: map['lastPaid'] ?? '',
    );
  }
}

class PTMSchedule {
  final int id;
  final String className;
  final String date;
  final String startTime;
  final String endTime;
  final String purpose;
  final String location;
  final DateTime createdAt;

  PTMSchedule({
    required this.id,
    required this.className,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.purpose,
    required this.location,
    required this.createdAt,
  });
}

class Notice {
  final int id;
  final String title;
  final String content;
  final String recipients;
  final String priority;
  final bool sendSMS;
  final bool sendEmail;
  final DateTime date;
  final int views;

  Notice({
    required this.id,
    required this.title,
    required this.content,
    required this.recipients,
    required this.priority,
    this.sendSMS = false,
    this.sendEmail = false,
    required this.date,
    this.views = 0,
  });
}

class Product {
  final int id;
  final String name;
  final String category;
  final double price;
  final String imageIcon;
  final double rating;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.imageIcon,
    required this.rating,
  });
}

class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });

  double get totalPrice => product.price * quantity;
}
