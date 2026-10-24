class IncidentFilter {
  final String? status;
  final String? category;
  final String? searchQuery;
  final bool showOnlyMine;

  const IncidentFilter({
    this.status,
    this.category,
    this.searchQuery,
    this.showOnlyMine = false,
  });

  IncidentFilter copyWith({
    String? status,
    String? category,
    String? searchQuery,
    bool? showOnlyMine,
  }) {
    return IncidentFilter(
      status: status ?? this.status,
      category: category ?? this.category,
      searchQuery: searchQuery ?? this.searchQuery,
      showOnlyMine: showOnlyMine ?? this.showOnlyMine,
    );
  }

  bool get hasActiveFilters =>
      status != null || category != null || (searchQuery?.isNotEmpty ?? false);

  IncidentFilter clearFilters() => IncidentFilter(showOnlyMine: showOnlyMine);
}
