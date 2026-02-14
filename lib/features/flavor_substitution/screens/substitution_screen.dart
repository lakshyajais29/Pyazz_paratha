import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../controller/substitution_controller.dart';
import '../../../core/services/flavordb_service.dart';

class SubstitutionScreen extends StatefulWidget {
  const SubstitutionScreen({super.key});

  @override
  State<SubstitutionScreen> createState() => _SubstitutionScreenState();
}

class _SubstitutionScreenState extends State<SubstitutionScreen> {
  final SubstitutionController _controller = SubstitutionController();
  final TextEditingController _searchController = TextEditingController();
  List<FlavorCompound> _results = [];
  bool _isLoading = false;
  String? _errorMsg;
  String _searchType = 'taste'; // 'taste' or 'aroma'

  Future<void> _search() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
      _errorMsg = null;
    });

    List<FlavorCompound> results;
    if (_searchType == 'taste') {
      results = await _controller.searchByTaste(query);
    } else {
      results = await _controller.searchByAroma(query);
    }

    if (mounted) {
      setState(() {
        _results = results;
        _errorMsg = _controller.errorMessage;
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.only(left: 16),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.primary, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: const Text(
          'Flavor Explorer',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Type Toggle
            Row(
              children: [
                _buildToggle('Taste', 'taste'),
                const SizedBox(width: 12),
                _buildToggle('Aroma', 'aroma'),
              ],
            ),
            const SizedBox(height: 16),

            // Search Bar
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                onSubmitted: (_) => _search(),
                decoration: InputDecoration(
                  hintText: _searchType == 'taste'
                      ? 'Search by taste (e.g., fruity, sweet, bitter)'
                      : 'Search by aroma (e.g., floral, herbal)',
                  hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                  prefixIcon: const Icon(Icons.search, color: AppColors.primary),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.send, color: AppColors.primary),
                    onPressed: _search,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Quick Tags
            Wrap(
              spacing: 8,
              children: ['fruity', 'sweet', 'bitter', 'spicy', 'floral']
                  .map((tag) => ActionChip(
                        label: Text(tag, style: const TextStyle(fontSize: 12)),
                        onPressed: () {
                          _searchController.text = tag;
                          _search();
                        },
                        backgroundColor: Colors.orange[50],
                        side: BorderSide.none,
                      ))
                  .toList(),
            ),
            const SizedBox(height: 16),

            // Results
            if (_isLoading)
              const Expanded(
                child: Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
              )
            else if (_errorMsg != null && _results.isEmpty)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_off, size: 48, color: Colors.grey[300]),
                      const SizedBox(height: 12),
                      Text(_errorMsg!, style: TextStyle(color: Colors.grey[500])),
                    ],
                  ),
                ),
              )
            else if (_results.isEmpty)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.science, size: 48, color: Colors.grey[300]),
                      const SizedBox(height: 12),
                      Text(
                        'Search for flavor compounds\nby taste or aroma',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey[500]),
                      ),
                    ],
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: _results.length,
                  itemBuilder: (context, index) {
                    final compound = _results[index];
                    return _buildCompoundCard(compound);
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggle(String label, String type) {
    final isActive = _searchType == type;
    return GestureDetector(
      onTap: () => setState(() => _searchType = type),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? AppColors.primary : Colors.grey[300]!,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.grey,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildCompoundCard(FlavorCompound compound) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.science, color: AppColors.primary, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  compound.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          if (compound.naturalOccurrence != null && compound.naturalOccurrence!.isNotEmpty) ...[
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.eco, size: 14, color: Colors.green),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    compound.naturalOccurrence!,
                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
          if (compound.tasteDescription != null && compound.tasteDescription!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.language, size: 14, color: Colors.orange),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Taste: ${compound.tasteDescription!}',
                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                ),
              ],
            ),
          ],
          if (compound.empiricalFormula != null && compound.empiricalFormula!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              compound.empiricalFormula!,
              style: TextStyle(fontSize: 11, color: Colors.grey[400], fontStyle: FontStyle.italic),
            ),
          ],
        ],
      ),
    );
  }
}
