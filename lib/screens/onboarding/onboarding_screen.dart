import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../main_app_screen.dart';

/*
BACKEND INTEGRATION NOTES:
========================

This onboarding screen currently uses hardcoded data for educational institutions
and campus branches. To integrate with your backend database:

1. REPLACE HARDCODED DATA:
   - Replace _studentTypes list with EducationalInstitutionService.getStudentTypes()
   - Replace _institutions map with EducationalInstitutionService.getInstitutions()  
   - Replace _campusBranches map with EducationalInstitutionService.getCampusBranches()

2. IMPLEMENT DYNAMIC LOADING:
   - Load student types on screen initialization
   - Load institutions when student type is selected
   - Load campus branches when institution is selected
   - Implement search functionality using EducationalInstitutionService.searchInstitutions()

3. HANDLE NEW INSTITUTION REQUESTS:
   - Use EducationalInstitutionService.requestNewInstitution() when user requests new institution
   - Show confirmation dialog and handle approval workflow

4. SUBMIT ONBOARDING DATA:
   - Use EducationalInstitutionService.submitOnboardingData() to save user selections
   - Store user's educational profile in backend

5. DATABASE SCHEMA:
   - See educational_institution_service.dart for complete database schema
   - Implements institutions, campus_branches, institution_requests, and user_onboarding tables

6. API ENDPOINTS NEEDED:
   - GET /api/student-types
   - GET /api/institutions?type={type}
   - GET /api/institutions/{id}/branches  
   - GET /api/institutions/search?type={type}&q={query}
   - POST /api/institutions/request
   - POST /api/users/{id}/onboarding

Current implementation uses mock data for demonstration.
Replace with actual API calls before production deployment.
*/

/// Educational institution onboarding flow
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _requestController = TextEditingController();

  int _currentPage = 0;
  String _selectedStudentType = '';
  String _selectedInstitution = '';
  String _selectedCampusBranch = '';
  List<String> _filteredInstitutions = [];
  List<String> _filteredCampusBranches = [];

  // Mock data - In real app, this would come from API
  final Map<String, List<String>> _institutions = {
    'College': [
      'Delhi University',
      'Mumbai University',
      'Bangalore University',
      'Pune University',
      'Chennai University',
      'IIT Delhi',
      'IIT Bombay',
      'IIT Bangalore',
      'IIT Madras',
      'IIT Kanpur',
      'NIT Trichy',
      'NIT Warangal',
      'BITS Pilani',
      'VIT Vellore',
      'SRM University',
      'Manipal University',
      'Lovely Professional University',
      'Amity University',
      'Christ University',
      'Jadavpur University',
    ],
    'School': [
      'DPS Delhi',
      'DPS Bangalore',
      'Ryan International School',
      'Kendriya Vidyalaya',
      'DAV Public School',
      'St. Xaviers School',
      'Modern School',
      'Sanskriti School',
      'The Shri Ram School',
      'Bal Bharati Public School',
      'Cambridge School',
      'Delhi Public School',
      'La Martiniere College',
      'Bishop Cotton School',
      'The Doon School',
    ],
    'Coaching': [
      'FIITJEE',
      'Allen Career Institute',
      'Aakash Institute',
      'Resonance',
      'Narayana',
      'Sri Chaitanya',
      'Bansal Classes',
      'Career Point',
      'Motion Education',
      'Unacademy Centers',
      'Byjus Classes',
      'Vedantu Centers',
      'Physics Wallah',
      'Triumph Institute',
      'TIME Institute',
    ],
  };

  // Campus branches/locations for different institutions
  final Map<String, List<String>> _campusBranches = {
    'Delhi University': [
      'Delhi University - North Campus',
      'Delhi University - South Campus',
      'Delhi University - East Campus',
      'Delhi University - Ramjas College',
      'Delhi University - Hindu College',
      'Delhi University - St. Stephens College',
      'Delhi University - Lady Shri Ram College',
    ],
    'Mumbai University': [
      'Mumbai University - Kalina Campus',
      'Mumbai University - Fort Campus',
      'Mumbai University - Thane Campus',
      'Mumbai University - VJTI Campus',
      'Mumbai University - ICT Campus',
    ],
    'IIT Delhi': [
      'IIT Delhi - Hauz Khas Campus',
      'IIT Delhi - Sonipat Extension',
    ],
    'IIT Bombay': [
      'IIT Bombay - Powai Campus',
      'IIT Bombay - Downtown Campus',
    ],
    'IIT Bangalore': [
      'IIT Bangalore - Bengaluru Campus',
    ],
    'BITS Pilani': [
      'BITS Pilani - Pilani Campus',
      'BITS Pilani - Goa Campus',
      'BITS Pilani - Hyderabad Campus',
      'BITS Pilani - Dubai Campus',
    ],
    'VIT Vellore': [
      'VIT Vellore - Main Campus',
      'VIT Bhopal Campus',
      'VIT Chennai Campus',
      'VIT AP - Amaravati Campus',
    ],
    'SRM University': [
      'SRM Kattankulathur Campus',
      'SRM Ramapuram Campus',
      'SRM Vadapalani Campus',
      'SRM NCR Campus',
      'SRM Amaravati Campus',
      'SRM Sikkim Campus',
    ],
    'DPS Delhi': [
      'DPS RK Puram',
      'DPS Vasant Kunj',
      'DPS Dwarka',
      'DPS Ghaziabad',
      'DPS Noida',
      'DPS Gurgaon',
    ],
    'DPS Bangalore': [
      'DPS Bangalore North',
      'DPS Bangalore South',
      'DPS Bangalore East',
    ],
    'Kendriya Vidyalaya': [
      'KV Delhi Cantt',
      'KV Andrews Ganj',
      'KV JNU',
      'KV IIT Delhi',
      'KV Pusa',
      'KV AFS Hindon',
    ],
    'FIITJEE': [
      'FIITJEE South Delhi',
      'FIITJEE East Delhi',
      'FIITJEE West Delhi',
      'FIITJEE Gurgaon',
      'FIITJEE Noida',
      'FIITJEE Faridabad',
    ],
    'Allen Career Institute': [
      'Allen Kota - Main Center',
      'Allen Delhi',
      'Allen Mumbai',
      'Allen Bangalore',
      'Allen Pune',
      'Allen Chennai',
    ],
  };

  @override
  void initState() {
    super.initState();
    _filteredInstitutions = [];
    // TODO: Replace hardcoded data with EducationalInstitutionService API calls
    // Initialize services and load data from backend:
    // _loadStudentTypes();
    // _loadInstitutions();
    // _loadCampusBranches();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _searchController.dispose();
    _requestController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),

            // Page content
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                children: [
                  _buildWelcomePage(),
                  _buildStudentTypePage(),
                  _buildInstitutionSelectionPage(),
                  if (_selectedStudentType == 'College')
                    _buildCampusBranchSelectionPage(),
                  _buildCompletionPage(),
                ],
              ),
            ),

            // Navigation
            _buildNavigation(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF0095F6),
                  Color(0xFF8E44AD),
                  Color(0xFFE91E63)
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Text('C',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomePage() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: const Color(0xFF0095F6).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.school,
              size: 60,
              color: Color(0xFF0095F6),
            ),
          ),
          const SizedBox(height: 48),
          const Text(
            'Welcome to Confess',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF262626),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const Text(
            'Connect anonymously with your educational community. Share thoughts, experiences, and get support.',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF8E8E8E),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStudentTypePage() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'I am a',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF262626),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const Text(
            'Select your current education level',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF8E8E8E),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          _buildStudentTypeCard(
            title: 'College Student',
            subtitle: 'University, College, or Institute',
            icon: Icons.school,
            color: const Color(0xFF0095F6),
            type: 'College',
          ),
          const SizedBox(height: 16),
          _buildStudentTypeCard(
            title: 'School Student',
            subtitle: 'High School or Secondary School',
            icon: Icons.menu_book,
            color: const Color(0xFF8E44AD),
            type: 'School',
          ),
          const SizedBox(height: 16),
          _buildStudentTypeCard(
            title: 'Coaching Student',
            subtitle: 'Preparation Institutes or Coaching Centers',
            icon: Icons.psychology,
            color: const Color(0xFFE91E63),
            type: 'Coaching',
          ),
        ],
      ),
    );
  }

  Widget _buildStudentTypeCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required String type,
  }) {
    final bool isSelected = _selectedStudentType == type;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedStudentType = type;
          _selectedInstitution = '';
          _selectedCampusBranch = '';
          _filteredInstitutions = _institutions[type] ?? [];
        });
        HapticFeedback.lightImpact();
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.white,
          border: Border.all(
            color: isSelected ? color : const Color(0xFFE0E0E0),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? color : const Color(0xFF262626),
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF8E8E8E),
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected) Icon(Icons.check_circle, color: color, size: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildInstitutionSelectionPage() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text(
            'Select your ${_selectedStudentType.toLowerCase()}',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF262626),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Search and select from the list below',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF8E8E8E),
            ),
          ),
          const SizedBox(height: 24),

          // Search field
          TextField(
            controller: _searchController,
            onChanged: _filterInstitutions,
            decoration: InputDecoration(
              hintText: 'Search ${_selectedStudentType.toLowerCase()}...',
              prefixIcon: const Icon(Icons.search, color: Color(0xFF8E8E8E)),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF0095F6)),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Institution list
          Expanded(
            child: _filteredInstitutions.isEmpty
                ? _buildNoResultsFound()
                : ListView.builder(
                    itemCount: _filteredInstitutions.length,
                    itemBuilder: (context, index) {
                      final institution = _filteredInstitutions[index];
                      final isSelected = _selectedInstitution == institution;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          onTap: () {
                            setState(() {
                              _selectedInstitution = institution;
                            });
                            HapticFeedback.lightImpact();
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          tileColor: isSelected
                              ? const Color(0xFF0095F6).withOpacity(0.1)
                              : Colors.white,
                          leading: Icon(
                            Icons.school,
                            color: isSelected
                                ? const Color(0xFF0095F6)
                                : const Color(0xFF8E8E8E),
                          ),
                          title: Text(
                            institution,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: isSelected
                                  ? const Color(0xFF0095F6)
                                  : const Color(0xFF262626),
                            ),
                          ),
                          trailing: isSelected
                              ? const Icon(Icons.check,
                                  color: Color(0xFF0095F6))
                              : null,
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResultsFound() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.search_off,
            size: 64,
            color: Color(0xFF8E8E8E),
          ),
          const SizedBox(height: 16),
          const Text(
            'No results found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Color(0xFF262626),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Can\'t find your institution?',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF8E8E8E),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _showRequestDialog,
            icon: const Icon(Icons.add),
            label: const Text('Request to Add'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0095F6),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCampusBranchSelectionPage() {
    final branches = _campusBranches[_selectedInstitution] ?? [];
    _filteredCampusBranches = branches;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const Text(
            'Select your campus branch',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF262626),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Choose the specific campus/location of $_selectedInstitution',
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF8E8E8E),
            ),
          ),
          const SizedBox(height: 24),

          // Campus branch list
          Expanded(
            child: ListView.builder(
              itemCount: _filteredCampusBranches.length,
              itemBuilder: (context, index) {
                final branch = _filteredCampusBranches[index];
                final isSelected = _selectedCampusBranch == branch;

                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    onTap: () {
                      setState(() {
                        _selectedCampusBranch = branch;
                      });
                      HapticFeedback.lightImpact();
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    tileColor: isSelected
                        ? const Color(0xFF0095F6).withOpacity(0.1)
                        : Colors.white,
                    leading: Icon(
                      Icons.location_on,
                      color: isSelected
                          ? const Color(0xFF0095F6)
                          : const Color(0xFF8E8E8E),
                    ),
                    title: Text(
                      branch,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: isSelected
                            ? const Color(0xFF0095F6)
                            : const Color(0xFF262626),
                      ),
                    ),
                    trailing: isSelected
                        ? const Icon(Icons.check, color: Color(0xFF0095F6))
                        : null,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletionPage() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: const Color(0xFF00C853).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle,
              size: 60,
              color: Color(0xFF00C853),
            ),
          ),
          const SizedBox(height: 48),
          const Text(
            'All Set!',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF262626),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'You\'re now part of the ${_selectedInstitution.isNotEmpty ? _selectedInstitution : _selectedStudentType} community. Start connecting anonymously!',
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF8E8E8E),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNavigation() {
    final totalPages = _selectedStudentType == 'College' ? 5 : 4;
    final canProceed = _canProceedToNextPage();

    return Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          // Back button
          if (_currentPage > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: _previousPage,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF0095F6)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  'Back',
                  style: TextStyle(
                      color: Color(0xFF0095F6),
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
              ),
            )
          else
            const Expanded(child: SizedBox()),

          const SizedBox(width: 16),

          // Next/Complete button
          Expanded(
            child: ElevatedButton(
              onPressed: canProceed ? _nextPage : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0095F6),
                disabledBackgroundColor: const Color(0xFFE0E0E0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: Text(
                _currentPage == totalPages - 1 ? 'Get Started' : 'Next',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _canProceedToNextPage() {
    switch (_currentPage) {
      case 0:
        return true;
      case 1:
        return _selectedStudentType.isNotEmpty;
      case 2:
        return _selectedInstitution.isNotEmpty;
      case 3:
        return _selectedStudentType != 'College' ||
            _selectedCampusBranch.isNotEmpty;
      case 4:
        return true;
      default:
        return false;
    }
  }

  void _filterInstitutions(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredInstitutions = _institutions[_selectedStudentType] ?? [];
      } else {
        _filteredInstitutions = (_institutions[_selectedStudentType] ?? [])
            .where((institution) =>
                institution.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _nextPage() {
    final totalPages = _selectedStudentType == 'College' ? 5 : 4;
    if (_currentPage < totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _completeOnboarding() {
    HapticFeedback.lightImpact();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const MainAppScreen()),
    );
  }

  void _showRequestDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Request Institution'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Please provide the name of your institution:'),
            const SizedBox(height: 16),
            TextField(
              controller: _requestController,
              decoration: const InputDecoration(
                hintText: 'Enter institution name',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Send request to add institution
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                      'Request submitted! We\'ll review and add your institution soon.'),
                  backgroundColor: Color(0xFF0095F6),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0095F6)),
            child: const Text('Submit Request',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
