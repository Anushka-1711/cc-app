import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import '../../core/utils/platform_utils.dart';

class CreatePostScreen extends StatefulWidget {
  final String? preSelectedCommunityId;

  const CreatePostScreen({
    super.key,
    this.preSelectedCommunityId,
  });

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController _textController = TextEditingController();
  bool _isAnonymous = true;
  String? _selectedCommunity;
  final int _maxLength = 500;

  final List<String> _communities = [
    'General Confessions',
    'Academic Stress',
    'Relationships',
    'Mental Health',
    'Social Life',
    'Dorm Life',
    'Career Anxiety',
    'Family Issues',
    'Financial Struggles',
    'Personal Growth',
  ];

  @override
  void initState() {
    super.initState();
    _selectedCommunity = widget.preSelectedCommunityId ?? _communities[0];
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          _isAnonymous ? 'Anonymous Confession' : 'Public Post',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            PlatformUtils.isIOS ? CupertinoIcons.xmark : Icons.close,
            color: Colors.black,
          ),
        ),
        actions: [
          TextButton(
            onPressed:
                _textController.text.trim().isNotEmpty ? _sharePost : null,
            child: Text(
              'Share',
              style: TextStyle(
                color: _textController.text.trim().isNotEmpty
                    ? const Color(0xFF0095F6)
                    : const Color(0xFF8E8E8E),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPostTypeToggle(),
                  const SizedBox(height: 20),
                  _buildCommunitySelection(),
                  const SizedBox(height: 20),
                  _buildTextInput(),
                  const SizedBox(height: 16),
                  _buildCharacterCounter(),
                  const SizedBox(height: 20),
                  _buildGuidelinesCard(),
                ],
              ),
            ),
          ),
          _buildBottomActions(),
        ],
      ),
    );
  }

  Widget _buildPostTypeToggle() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _isAnonymous = true),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: _isAnonymous
                      ? const Color(0xFF262626)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      PlatformUtils.isIOS ? CupertinoIcons.lock_shield : Icons.lock,
                      color:
                          _isAnonymous ? Colors.white : const Color(0xFF8E8E8E),
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Anonymous',
                      style: TextStyle(
                        color: _isAnonymous
                            ? Colors.white
                            : const Color(0xFF8E8E8E),
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _isAnonymous = false),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: !_isAnonymous
                      ? const Color(0xFF0095F6)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      PlatformUtils.isIOS ? CupertinoIcons.globe : Icons.public,
                      color: !_isAnonymous
                          ? Colors.white
                          : const Color(0xFF8E8E8E),
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Public',
                      style: TextStyle(
                        color: !_isAnonymous
                            ? Colors.white
                            : const Color(0xFF8E8E8E),
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommunitySelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Community',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF262626),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE1E1E1)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedCommunity,
              isExpanded: true,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCommunity = newValue;
                });
              },
              items: _communities.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF262626),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _isAnonymous ? 'What\'s on your mind?' : 'Share your experience',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF262626),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE1E1E1)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: _textController,
            maxLines: 8,
            maxLength: _maxLength,
            onChanged: (value) => setState(() {}),
            decoration: InputDecoration(
              hintText: _isAnonymous
                  ? 'Share your thoughts anonymously. This is a safe space...'
                  : 'Share what\'s happening in your college life...',
              hintStyle: const TextStyle(
                color: Color(0xFF8E8E8E),
                fontSize: 16,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
              counterText: '',
            ),
            style: const TextStyle(
              fontSize: 16,
              height: 1.5,
              color: Color(0xFF262626),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCharacterCounter() {
    final currentLength = _textController.text.length;
    final percentage = currentLength / _maxLength;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          '$currentLength/$_maxLength',
          style: TextStyle(
            color: percentage > 0.9 ? Colors.red : const Color(0xFF8E8E8E),
            fontSize: 12,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: const Color(0xFFE1E1E1),
            borderRadius: BorderRadius.circular(2),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: percentage.clamp(0.0, 1.0),
            child: Container(
              decoration: BoxDecoration(
                color: percentage > 0.9 ? Colors.red : const Color(0xFF0095F6),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGuidelinesCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F8FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF0095F6).withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.info_outline, color: Color(0xFF0095F6), size: 20),
              SizedBox(width: 8),
              Text(
                'Community Guidelines',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0095F6),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            ' Be respectful and supportive\n No hate speech or discrimination\n No personal information sharing\n Keep it college-related',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF262626),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Color(0xFFE1E1E1), width: 1),
        ),
      ),
      child: Row(
        children: [
          if (_isAnonymous) ...[
            const Icon(Icons.lock, color: Color(0xFF8E8E8E), size: 16),
            const SizedBox(width: 4),
            const Text(
              'Your identity is protected',
              style: TextStyle(
                color: Color(0xFF8E8E8E),
                fontSize: 12,
              ),
            ),
          ] else ...[
            const Icon(Icons.public, color: Color(0xFF8E8E8E), size: 16),
            const SizedBox(width: 4),
            const Text(
              'Visible to everyone',
              style: TextStyle(
                color: Color(0xFF8E8E8E),
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _sharePost() {
    if (_textController.text.trim().isEmpty) return;

    HapticFeedback.lightImpact();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isAnonymous
              ? 'Anonymous confession shared successfully!'
              : 'Public post shared successfully!',
        ),
        backgroundColor: const Color(0xFF0095F6),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );

    _textController.clear();
    Navigator.of(context).pop();
  }
}
