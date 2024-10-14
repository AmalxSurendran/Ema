class EntityState<T> {
  T? data;
  bool loading = false;
  String? error;

  EntityState() {
    loading = false;
  }

  EntityState.withData(T mData) {
    data = mData;
    loading = false;
    error = null;
  }

  EntityState.withError(String error) {
    data = null;
    loading = false;
    error = error;
  }

  EntityState.withLoading() {
    loading = true;
    error = null;
  }
}