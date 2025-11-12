import 'package:flutter/material.dart';

class SearchBarWidget extends StatefulWidget {
  final ValueChanged<String> onSearch;
  final VoidCallback? onClear;

  const SearchBarWidget({super.key, required this.onSearch, this.onClear});

  @override
  State<SearchBarWidget> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBarWidget> {
  final _searchController = TextEditingController();

  void _performSearch() {
    final filter = _searchController.text.trim();
    widget.onSearch(filter);
  }

  void _clearSearch() {
    _searchController.clear();
    widget.onClear?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              onSubmitted: (_) => _performSearch(),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search, color: Colors.white70),
                suffixIcon: _searchController.text.isNotEmpty
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.clear,
                              color: Colors.white70,
                            ),
                            onPressed: _clearSearch,
                          ),
                          IconButton(
                            onPressed: _performSearch,
                            icon: Icon(Icons.search),
                          ),
                        ],
                      )
                    : IconButton(
                        onPressed: _performSearch,
                        icon: Icon(Icons.search),
                      ),
                hintText: 'Buscar por plataforma...',
                filled: true,
                fillColor: const Color(0xFF2A3350),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
