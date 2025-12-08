class LocationState {
  final bool isLoading;
  final String location;
  final String? error;

  LocationState({this.isLoading = false, this.location = '', this.error});

  LocationState copyWith({bool? isLoading, String? location, String? error}) {
    return LocationState(
      isLoading: isLoading ?? this.isLoading,
      location: location ?? this.location,
      error: error,
    );
  }
}
