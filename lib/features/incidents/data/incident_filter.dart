class IncidentFilter {
  final String? status;
  final String? category;
  final String? priority;
  final String? searchQuery;
  final bool showOnlyMine;
  final SortField sortBy;

  const IncidentFilter({
    this.status,
    this.category,
    this.priority,
    this.searchQuery,
    this.showOnlyMine = false,
    this.sortBy = SortField.newest,
  });

  IncidentFilter copyWith({
    String? status,
    String? category,
    String? priority,
    String? searchQuery,
    bool? showOnlyMine,
    SortField? sortBy,
  }) {
    return IncidentFilter(
      status: status ?? this.status,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      searchQuery: searchQuery ?? this.searchQuery,
      showOnlyMine: showOnlyMine ?? this.showOnlyMine,
      sortBy: sortBy ?? this.sortBy,
    );
  }

  bool get hasActiveFilters =>
      status != null ||
      category != null ||
      priority != null ||
      (searchQuery?.isNotEmpty ?? false);

  int get activeFilterCount =>
      (status != null ? 1 : 0) +
      (category != null ? 1 : 0) +
      (priority != null ? 1 : 0);

  IncidentFilter clearFilters() =>
      IncidentFilter(showOnlyMine: showOnlyMine, sortBy: sortBy);
}

enum SortField {
  newest,
  oldest,
  priority,
}
