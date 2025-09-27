import 'dart:convert';
import 'package:http/http.dart' as http;

/// Service class for handling educational institution data from backend
class EducationalInstitutionService {
  static const String _baseUrl = 'YOUR_BACKEND_API_URL';

  /// Fetch all available student types from backend
  Future<List<String>> getStudentTypes() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/api/student-types'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List<String>.from(data['student_types']);
      }
      return ['College', 'School', 'Coaching']; // Fallback
    } catch (e) {
      print('Error fetching student types: $e');
      return ['College', 'School', 'Coaching']; // Fallback
    }
  }

  /// Fetch institutions by student type from backend
  Future<List<Map<String, dynamic>>> getInstitutions(String studentType) async {
    try {
      final response = await http.get(
        Uri.parse(
            '$_baseUrl/api/institutions?type=${studentType.toLowerCase()}'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data['institutions']);
      }
      return []; // Empty list if failed
    } catch (e) {
      print('Error fetching institutions: $e');
      return []; // Empty list if failed
    }
  }

  /// Fetch campus branches for a specific institution from backend
  Future<List<Map<String, dynamic>>> getCampusBranches(
      String institutionId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/api/institutions/$institutionId/branches'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data['branches']);
      }
      return []; // Empty list if failed
    } catch (e) {
      print('Error fetching campus branches: $e');
      return []; // Empty list if failed
    }
  }

  /// Search institutions by query from backend
  Future<List<Map<String, dynamic>>> searchInstitutions(
      String studentType, String query) async {
    try {
      final response = await http.get(
        Uri.parse(
            '$_baseUrl/api/institutions/search?type=${studentType.toLowerCase()}&q=${Uri.encodeComponent(query)}'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data['institutions']);
      }
      return []; // Empty list if failed
    } catch (e) {
      print('Error searching institutions: $e');
      return []; // Empty list if failed
    }
  }

  /// Submit request to add new institution to backend
  Future<bool> requestNewInstitution({
    required String name,
    required String studentType,
    required String requestedBy,
    String? description,
    String? location,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/institutions/request'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': name,
          'student_type': studentType.toLowerCase(),
          'requested_by': requestedBy,
          'description': description,
          'location': location,
          'status': 'pending',
          'created_at': DateTime.now().toIso8601String(),
        }),
      );

      return response.statusCode == 201 || response.statusCode == 200;
    } catch (e) {
      print('Error requesting new institution: $e');
      return false;
    }
  }

  /// Submit user's onboarding data to backend
  Future<bool> submitOnboardingData({
    required String userId,
    required String studentType,
    required String institutionId,
    String? campusBranchId,
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/users/$userId/onboarding'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'student_type': studentType,
          'institution_id': institutionId,
          'campus_branch_id': campusBranchId,
          'additional_data': additionalData,
          'completed_at': DateTime.now().toIso8601String(),
        }),
      );

      return response.statusCode == 201 || response.statusCode == 200;
    } catch (e) {
      print('Error submitting onboarding data: $e');
      return false;
    }
  }
}

/// Model classes for backend data structures

class Institution {
  final String id;
  final String name;
  final String studentType;
  final String? description;
  final String? logoUrl;
  final List<CampusBranch> branches;
  final DateTime createdAt;
  final DateTime updatedAt;

  Institution({
    required this.id,
    required this.name,
    required this.studentType,
    this.description,
    this.logoUrl,
    required this.branches,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Institution.fromJson(Map<String, dynamic> json) {
    return Institution(
      id: json['id'],
      name: json['name'],
      studentType: json['student_type'],
      description: json['description'],
      logoUrl: json['logo_url'],
      branches: (json['branches'] as List)
          .map((branch) => CampusBranch.fromJson(branch))
          .toList(),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'student_type': studentType,
      'description': description,
      'logo_url': logoUrl,
      'branches': branches.map((branch) => branch.toJson()).toList(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class CampusBranch {
  final String id;
  final String name;
  final String institutionId;
  final String? address;
  final String? city;
  final String? state;
  final String? country;
  final double? latitude;
  final double? longitude;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  CampusBranch({
    required this.id,
    required this.name,
    required this.institutionId,
    this.address,
    this.city,
    this.state,
    this.country,
    this.latitude,
    this.longitude,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CampusBranch.fromJson(Map<String, dynamic> json) {
    return CampusBranch(
      id: json['id'],
      name: json['name'],
      institutionId: json['institution_id'],
      address: json['address'],
      city: json['city'],
      state: json['state'],
      country: json['country'],
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      isActive: json['is_active'] ?? true,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'institution_id': institutionId,
      'address': address,
      'city': city,
      'state': state,
      'country': country,
      'latitude': latitude,
      'longitude': longitude,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class InstitutionRequest {
  final String id;
  final String name;
  final String studentType;
  final String requestedBy;
  final String? description;
  final String? location;
  final String status; // pending, approved, rejected
  final String? adminNotes;
  final DateTime createdAt;
  final DateTime? processedAt;

  InstitutionRequest({
    required this.id,
    required this.name,
    required this.studentType,
    required this.requestedBy,
    this.description,
    this.location,
    required this.status,
    this.adminNotes,
    required this.createdAt,
    this.processedAt,
  });

  factory InstitutionRequest.fromJson(Map<String, dynamic> json) {
    return InstitutionRequest(
      id: json['id'],
      name: json['name'],
      studentType: json['student_type'],
      requestedBy: json['requested_by'],
      description: json['description'],
      location: json['location'],
      status: json['status'],
      adminNotes: json['admin_notes'],
      createdAt: DateTime.parse(json['created_at']),
      processedAt: json['processed_at'] != null
          ? DateTime.parse(json['processed_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'student_type': studentType,
      'requested_by': requestedBy,
      'description': description,
      'location': location,
      'status': status,
      'admin_notes': adminNotes,
      'created_at': createdAt.toIso8601String(),
      'processed_at': processedAt?.toIso8601String(),
    };
  }
}

/*
BACKEND DATABASE SCHEMA SUGGESTION:

-- Institutions table
CREATE TABLE institutions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(255) NOT NULL,
  student_type VARCHAR(50) NOT NULL CHECK (student_type IN ('college', 'school', 'coaching')),
  description TEXT,
  logo_url VARCHAR(500),
  website_url VARCHAR(500),
  is_active BOOLEAN DEFAULT true,
  is_verified BOOLEAN DEFAULT false,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Campus branches table  
CREATE TABLE campus_branches (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(255) NOT NULL,
  institution_id UUID NOT NULL REFERENCES institutions(id) ON DELETE CASCADE,
  address TEXT,
  city VARCHAR(100),
  state VARCHAR(100),
  country VARCHAR(100) DEFAULT 'India',
  postal_code VARCHAR(20),
  latitude DECIMAL(10, 8),
  longitude DECIMAL(11, 8),
  phone VARCHAR(20),
  email VARCHAR(255),
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Institution requests table
CREATE TABLE institution_requests (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(255) NOT NULL,
  student_type VARCHAR(50) NOT NULL CHECK (student_type IN ('college', 'school', 'coaching')),
  requested_by UUID NOT NULL, -- References users table
  description TEXT,
  location VARCHAR(255),
  website_url VARCHAR(500),
  status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'rejected')),
  admin_notes TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  processed_at TIMESTAMP WITH TIME ZONE,
  processed_by UUID -- References admin users table
);

-- User onboarding data table
CREATE TABLE user_onboarding (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL, -- References users table
  student_type VARCHAR(50) NOT NULL,
  institution_id UUID REFERENCES institutions(id),
  campus_branch_id UUID REFERENCES campus_branches(id),
  additional_data JSONB,
  completed_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes for performance
CREATE INDEX idx_institutions_student_type ON institutions(student_type);
CREATE INDEX idx_institutions_name ON institutions USING GIN(name gin_trgm_ops);
CREATE INDEX idx_campus_branches_institution ON campus_branches(institution_id);
CREATE INDEX idx_institution_requests_status ON institution_requests(status);
CREATE INDEX idx_user_onboarding_user_id ON user_onboarding(user_id);
*/
