// This file contains the remaining methods for student_dashboard.dart
// These methods should be added to the _StudentDashboardState class

import 'package:flutter/material.dart';
import '../services/data_service.dart';
import '../widgets/custom_card.dart';
import '../widgets/custom_button.dart';
import '../widgets/modal_dialog.dart';
import '../utils/validators.dart';

// Add these methods to _StudentDashboardState class:

Widget _buildFeeItem(String title, double amount, String status, Color statusColor) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Infrastructure & Facilities',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              AppHelpers.formatCurrency(amount),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                status,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: statusColor,
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget _buildTimetable(BuildContext context, DataService dataService) {
  return SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Weekly Time Table - Grade 11 Science',
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
                DataColumn(label: Text('Time', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Monday', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Tuesday', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Wednesday', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Thursday', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Friday', style: TextStyle(fontWeight: FontWeight.bold))),
              ],
              rows: [
                _buildTimetableRow('09:00 - 10:00', [
                  'Mathematics\nDr. Priya Sharma',
                  'Physics\nProf. Amit Kumar',
                  'Chemistry\nDr. Neha Gupta',
                  'English\nMr. David Wilson',
                  'Biology\nMs. Ritu Verma',
                ], [
                  const Color(0xFF3B82F6),
                  const Color(0xFF10B981),
                  const Color(0xFF8B5CF6),
                  const Color(0xFFF59E0B),
                  const Color(0xFFEF4444),
                ]),
                _buildTimetableRow('10:00 - 11:00', [
                  'Physics\nProf. Amit Kumar',
                  'Mathematics\nDr. Priya Sharma',
                  'English\nMr. David Wilson',
                  'Biology\nMs. Ritu Verma',
                  'Chemistry\nDr. Neha Gupta',
                ], [
                  const Color(0xFF10B981),
                  const Color(0xFF3B82F6),
                  const Color(0xFFF59E0B),
                  const Color(0xFFEF4444),
                  const Color(0xFF8B5CF6),
                ]),
                DataRow(
                  cells: [
                    const DataCell(Text('11:00 - 11:30', style: TextStyle(fontWeight: FontWeight.w600))),
                    DataCell(Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF59E0B).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text('BREAK TIME', style: TextStyle(fontWeight: FontWeight.bold)),
                    )),
                    const DataCell(Text('')),
                    const DataCell(Text('')),
                    const DataCell(Text('')),
                    const DataCell(Text('')),
                  ],
                ),
                _buildTimetableRow('11:30 - 12:30', [
                  'Chemistry Lab\nDr. Neha Gupta',
                  'Biology\nMs. Ritu Verma',
                  'Physics Lab\nProf. Amit Kumar',
                  'Mathematics\nDr. Priya Sharma',
                  'English\nMr. David Wilson',
                ], [
                  const Color(0xFF8B5CF6),
                  const Color(0xFFEF4444),
                  const Color(0xFF10B981),
                  const Color(0xFF3B82F6),
                  const Color(0xFFF59E0B),
                ]),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

DataRow _buildTimetableRow(String time, List<String> subjects, List<Color> colors) {
  return DataRow(
    cells: [
      DataCell(Text(time, style: const TextStyle(fontWeight: FontWeight.w600))),
      ...subjects.asMap().entries.map((entry) {
        final index = entry.key;
        final subject = entry.value;
        final color = colors[index];
        
        return DataCell(
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              subject,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        );
      }).toList(),
    ],
  );
}

Widget _buildShop(BuildContext context, DataService dataService) {
  final products = dataService.getAllProducts();
  
  return SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Shop Header
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF8B5CF6), Color(0xFFEC4899)],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '🛍️ Greenwood School Store',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Everything you need for your academic journey - books, uniforms, stationery & more!',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.local_shipping, color: Colors.white, size: 16),
                        SizedBox(width: 4),
                        Text('Free delivery on campus', style: TextStyle(color: Colors.white, fontSize: 12)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.verified, color: Colors.white, size: 16),
                        SizedBox(width: 4),
                        Text('Quality guaranteed', style: TextStyle(color: Colors.white, fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Category Filters
        CustomCard(
          child: Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildCategoryButton('All Items', 'all', true),
                    const SizedBox(width: 8),
                    _buildCategoryButton('📚 Books', 'books', false),
                    const SizedBox(width: 8),
                    _buildCategoryButton('👔 Uniforms', 'uniform', false),
                    const SizedBox(width: 8),
                    _buildCategoryButton('✏️ Stationery', 'stationery', false),
                    const SizedBox(width: 8),
                    _buildCategoryButton('🎒 Accessories', 'accessories', false),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search products...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Products Grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 0.75,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return _buildProductCard(context, product, dataService);
          },
        ),
      ],
    ),
  );
}

Widget _buildCategoryButton(String text, String category, bool isSelected) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    decoration: BoxDecoration(
      color: isSelected ? const Color(0xFF8B5CF6) : Colors.grey[100],
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      text,
      style: TextStyle(
        color: isSelected ? Colors.white : Colors.grey[700],
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}

Widget _buildProductCard(BuildContext context, Product product, DataService dataService) {
  return CustomCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 120,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                _getProductColor(product.category),
                _getProductColor(product.category).withOpacity(0.7),
              ],
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: Center(
            child: Text(
              product.imageIcon,
              style: const TextStyle(fontSize: 48),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    ...List.generate(5, (index) {
                      return Icon(
                        index < product.rating.floor() ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                        size: 16,
                      );
                    }),
                    const SizedBox(width: 4),
                    Text(
                      '(${(product.rating * 20).toInt()})',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppHelpers.formatCurrency(product.price),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF8B5CF6),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'In Stock',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF10B981),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    text: 'Add to Cart',
                    backgroundColor: const Color(0xFF8B5CF6),
                    onPressed: () {
                      dataService.addToCart(product);
                      AppHelpers.showSnackBar(context, '${product.name} added to cart!');
                    },
                    height: 36,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

Color _getProductColor(String category) {
  switch (category) {
    case 'books':
      return const Color(0xFF3B82F6);
    case 'uniform':
      return const Color(0xFF6366F1);
    case 'stationery':
      return const Color(0xFFF59E0B);
    case 'accessories':
      return const Color(0xFF14B8A6);
    default:
      return const Color(0xFF6B7280);
  }
}

Widget? _buildFloatingActionButton(BuildContext context) {
  return FloatingActionButton(
    onPressed: () => _showQuickActions(context),
    backgroundColor: const Color(0xFF667eea),
    child: const Icon(Icons.add, color: Colors.white),
  );
}

String _getSectionTitle() {
  switch (_selectedSection) {
    case 'dashboard':
      return 'Dashboard';
    case 'profile':
      return 'My Profile';
    case 'homework':
      return 'Homework';
    case 'results':
      return 'Results';
    case 'fees':
      return 'Fees';
    case 'timetable':
      return 'Time Table';
    case 'shop':
      return 'School Shop';
    default:
      return 'Dashboard';
  }
}

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
          'New features added to student portal',
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

void _showCart(BuildContext context, DataService dataService) {
  ModalDialog.show(
    context: context,
    title: 'Shopping Cart',
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (dataService.cart.isEmpty)
          const Padding(
            padding: EdgeInsets.all(32),
            child: Column(
              children: [
                Icon(Icons.shopping_cart_outlined, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text('Your cart is empty', style: TextStyle(color: Colors.grey)),
              ],
            ),
          )
        else
          ...dataService.cart.map((item) => _buildCartItem(context, item, dataService)),
        if (dataService.cart.isNotEmpty) ...[
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                AppHelpers.formatCurrency(dataService.cartTotal),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF8B5CF6),
                ),
              ),
            ],
          ),
        ],
      ],
    ),
    actions: [
      if (dataService.cart.isNotEmpty) ...[
        OutlineButton(
          text: 'Clear Cart',
          onPressed: () {
            dataService.clearCart();
            Navigator.of(context).pop();
          },
        ),
        const SizedBox(width: 8),
        CustomButton(
          text: 'Checkout',
          backgroundColor: const Color(0xFF10B981),
          onPressed: () {
            Navigator.of(context).pop();
            _showCheckout(context, dataService);
          },
        ),
      ] else
        CustomButton(
          text: 'Close',
          onPressed: () => Navigator.of(context).pop(),
        ),
    ],
  );
}

Widget _buildCartItem(BuildContext context, CartItem item, DataService dataService) {
  return Container(
    padding: const EdgeInsets.all(12),
    margin: const EdgeInsets.only(bottom: 8),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey[300]!),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: _getProductColor(item.product.category).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(item.product.imageIcon, style: const TextStyle(fontSize: 20)),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.product.name,
                style: const TextStyle(fontWeight: FontWeight.w600),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                '${AppHelpers.formatCurrency(item.product.price)} × ${item.quantity}',
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ],
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () => dataService.updateCartQuantity(item.product.id, item.quantity - 1),
              icon: const Icon(Icons.remove_circle_outline),
              iconSize: 20,
            ),
            Text('${item.quantity}', style: const TextStyle(fontWeight: FontWeight.bold)),
            IconButton(
              onPressed: () => dataService.updateCartQuantity(item.product.id, item.quantity + 1),
              icon: const Icon(Icons.add_circle_outline),
              iconSize: 20,
            ),
          ],
        ),
      ],
    ),
  );
}

void _showCheckout(BuildContext context, DataService dataService) {
  ModalDialog.show(
    context: context,
    title: 'Checkout',
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Order Summary',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ...dataService.cart.map((item) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  '${item.product.name} × ${item.quantity}',
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              Text(
                AppHelpers.formatCurrency(item.totalPrice),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        )),
        const Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Total:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              AppHelpers.formatCurrency(dataService.cartTotal),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF8B5CF6),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Row(
            children: [
              Icon(Icons.local_shipping, color: Color(0xFF10B981)),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Free delivery to your classroom within 2-3 working days',
                  style: TextStyle(color: Color(0xFF10B981), fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
    actions: [
      OutlineButton(
        text: 'Cancel',
        onPressed: () => Navigator.of(context).pop(),
      ),
      const SizedBox(width: 8),
      CustomButton(
        text: 'Place Order',
        backgroundColor: const Color(0xFF10B981),
        onPressed: () {
          Navigator.of(context).pop();
          _processOrder(context, dataService);
        },
      ),
    ],
  );
}

void _processOrder(BuildContext context, DataService dataService) {
  LoadingDialog.show(context: context, message: 'Processing your order...');
  
  Future.delayed(const Duration(seconds: 2), () {
    LoadingDialog.hide(context);
    dataService.clearCart();
    
    SuccessDialog.show(
      context: context,
      title: 'Order Placed Successfully!',
      message: 'Your order has been placed and will be delivered to your classroom within 2-3 working days.',
      buttonText: 'Continue Shopping',
      onPressed: () {
        setState(() {
          _selectedSection = 'shop';
        });
      },
    );
  });
}

void _showProfileMenu(BuildContext context) {
  // Implementation for profile menu
}

void _showEditProfile(BuildContext context, user) {
  // Implementation for edit profile
}

void _showFileUpload(BuildContext context) {
  ModalDialog.show(
    context: context,
    title: 'Upload Assignment',
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: double.infinity,
          height: 150,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!, style: BorderStyle.solid, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.cloud_upload, size: 48, color: Colors.grey),
              SizedBox(height: 8),
              Text('Drag and drop your file here or click to browse'),
              SizedBox(height: 4),
              Text('Supported formats: PDF, DOC, DOCX, JPG, PNG', style: TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ),
      ],
    ),
    actions: [
      OutlineButton(
        text: 'Cancel',
        onPressed: () => Navigator.of(context).pop(),
      ),
      const SizedBox(width: 8),
      CustomButton(
        text: 'Upload',
        backgroundColor: const Color(0xFF10B981),
        onPressed: () {
          Navigator.of(context).pop();
          AppHelpers.showSnackBar(context, 'Assignment uploaded successfully!');
        },
      ),
    ],
  );
}

void _showPaymentDialog(BuildContext context, double amount, String description) {
  ModalDialog.show(
    context: context,
    title: 'Fee Payment',
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: const Color(0xFF3B82F6).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: Icon(Icons.payment, color: Color(0xFF3B82F6), size: 40),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          description,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          AppHelpers.formatCurrency(amount),
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Color(0xFF8B5CF6),
          ),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Column(
            children: [
              Text('Payment Methods:', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('• UPI Payment (Google Pay, PhonePe, Paytm)'),
              Text('• Credit/Debit Card'),
              Text('• Net Banking'),
            ],
          ),
        ),
      ],
    ),
    actions: [
      OutlineButton(
        text: 'Cancel',
        onPressed: () => Navigator.of(context).pop(),
      ),
      const SizedBox(width: 8),
      CustomButton(
        text: 'Pay Now',
        backgroundColor: const Color(0xFF10B981),
        onPressed: () {
          Navigator.of(context).pop();
          _processPayment(context, amount, description);
        },
      ),
    ],
  );
}

void _processPayment(BuildContext context, double amount, String description) {
  LoadingDialog.show(context: context, message: 'Processing payment...');
  
  Future.delaye
