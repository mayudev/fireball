import std/unittest
import ../src/path

test "properly trims tar paths":
    assert trimExtensionFromPath("/a/archive.tar.bz2") == "archive"
    assert trimExtensionFromPath("/a/s/d/.hidden/archive.tar") == "archive"
    assert trimExtensionFromPath("/archive.tar.gz") == "archive"
    assert trimExtensionFromPath("archive.tar.gz") == "archive"
