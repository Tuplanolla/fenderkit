/// The invocation `mirror_copy(v)` yields two copies of its children:
/// one that is direct and another that has been mirrored through `v`.
module mirror_copy(v) {
  children();
  mirror(v)
    children();
}

/// The invocation `rotate_copy(v)` yields two copies of its children:
/// one that is direct and another that has been rotated through `v`.
module rotate_copy(v) {
  children();
  rotate(v)
    children();
}

/// The invocation `skip()` ignores its children.
/// It is useful for writing type-checked comments.
module skip() {}
