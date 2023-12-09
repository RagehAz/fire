part of super_fire;
// -----------------------------------------------------------------------------

/// PAGINATION

// --------------------
/// TESTED : WORKS PERFECT
bool canPaginate({
  required ScrollController scrollController,
  required double paginationHeight,
  required bool isPaginating,
  required bool canKeepReading,
}) {

  if (isPaginating == true) {
    return false;
  }

  else if (canKeepReading == false) {
    return false;
  }

  else {
    final double max = scrollController.position.maxScrollExtent;
    final double current = scrollController.position.pixels;

    return max - current <= paginationHeight;
  }

}
// --------------------
/// TESTED : WORKS PERFECT
Future<void> paginationListener({
  required ScrollController controller,
  required ValueNotifier<bool> isPaginating,
  required ValueNotifier<bool> canKeepReading,
  required Function onPaginate,
  required bool mounted,
}) async {

  final bool _canPaginate = canPaginate(
    scrollController: controller,
    isPaginating: isPaginating.value,
    canKeepReading: canKeepReading.value,
    paginationHeight: 100,
  );

  // blog('_canPaginate : $_canPaginate');

  // Sliders.blogScrolling(
  //   scrollController: controller,
  //   isPaginating: isPaginating.value,
  //   canKeepReading: canKeepReading.value,
  //   paginationHeight: 100,
  // );

  if (_canPaginate == true) {
    setNotifier(
      notifier: isPaginating,
      mounted: mounted,
      value: true,
    );

    await onPaginate();

    setNotifier(
      notifier: isPaginating,
      mounted: mounted,
      value: false,
    );
  }

}
// -----------------------------------------------------------------------------
