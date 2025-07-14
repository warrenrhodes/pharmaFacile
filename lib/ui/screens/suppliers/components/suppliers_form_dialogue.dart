import 'package:flutter/material.dart';
import 'package:pharmacie_stock/models/supplier.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class SupplierFormDialog extends StatefulWidget {
  final Supplier? supplier;

  const SupplierFormDialog({super.key, this.supplier});

  @override
  State<SupplierFormDialog> createState() => _SupplierFormDialogState();
}

class _SupplierFormDialogState extends State<SupplierFormDialog> {
  final _formKey = GlobalKey<ShadFormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _notesController = TextEditingController();
  var _isActive = false;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.supplier != null) {
      _nameController.text = widget.supplier!.name;
      _phoneController.text = widget.supplier!.phone;
      _emailController.text = widget.supplier!.email ?? '';
      _addressController.text = widget.supplier!.address ?? '';
      _notesController.text = widget.supplier!.notes ?? '';
      _isActive = widget.supplier!.isActive;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ShadDialog(
      title: Text(
        widget.supplier == null ? 'Add New Supplier' : 'Edit Supplier',
      ),
      child: SizedBox(
        width: 600,
        child: SingleChildScrollView(
          child: ShadForm(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.supplier == null
                      ? 'Enter the details for the new supplier'
                      : 'Update supplier information',
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 20),

                // Company Name and Contact Person
                Row(
                  children: [
                    Expanded(
                      child: ShadInputFormField(
                        id: 'name',
                        label: const Text('Company Name *'),
                        controller: _nameController,
                        placeholder: const Text('Enter company name'),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Company name is required';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ShadSwitchFormField(
                        label: const Text('Is Active *'),
                        initialValue: _isActive,
                        onChanged: (value) => _isActive = value,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: ShadInputFormField(
                        id: 'phone',
                        label: const Text('Phone Number *'),
                        controller: _phoneController,
                        placeholder: const Text('Enter phone number'),
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Phone number is required';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ShadInputFormField(
                        id: 'email',
                        label: const Text('Email Address'),
                        controller: _emailController,
                        placeholder: const Text('Enter email address'),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value.isNotEmpty) {
                            if (!RegExp(
                              r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                            ).hasMatch(value)) {
                              return 'Please enter a valid email address';
                            }
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Address
                ShadInputFormField(
                  id: 'address',
                  label: const Text('Address *'),
                  controller: _addressController,
                  placeholder: const Text('Enter complete address'),
                  maxLines: 3,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Address is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Notes
                ShadInputFormField(
                  id: 'notes',
                  label: const Text('Notes'),
                  controller: _notesController,
                  placeholder: const Text(
                    'Additional notes about the supplier (optional)',
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 24),

                // Supplier Info Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        LucideIcons.info400,
                        color: Colors.blue.shade600,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Supplier Information',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.blue.shade800,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Make sure all contact information is accurate. This will be used for purchase orders and communications.',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.blue.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ShadButton.outline(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 12),
                    ShadButton(
                      onPressed: _isLoading ? null : _saveSupplier,
                      child: _isLoading
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(
                              widget.supplier == null
                                  ? 'Add Supplier'
                                  : 'Update Supplier',
                            ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _saveSupplier() async {
    if (!_formKey.currentState!.saveAndValidate()) return;

    setState(() => _isLoading = true);

    try {
      final supplier = Supplier(
        id:
            widget.supplier?.id ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        email: _emailController.text.trim(),
        address: _addressController.text.trim(),
        notes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
        isActive: widget.supplier?.isActive ?? true,
        createdAtInUtc: widget.supplier?.createdAtInUtc ?? DateTime.now(),
      );

      // final inventoryProvider = context.read<InventoryProvider>();

      if (widget.supplier == null) {
        // await inventoryProvider.addSupplier(supplier);
      } else {
        // await inventoryProvider.updateSupplier(supplier);
      }

      if (mounted) {
        Navigator.of(context).pop(true); // Return true to indicate success
        ShadToaster.of(context).show(
          ShadToast(
            title: const Text('Success'),
            description: Text(
              widget.supplier == null
                  ? 'Supplier added successfully'
                  : 'Supplier updated successfully',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ShadToaster.of(context).show(
          ShadToast.destructive(
            title: const Text('Error'),
            description: Text('Failed to save supplier: $e'),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
