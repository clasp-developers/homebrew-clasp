class ClaspCl < Formula
  desc "Common Lisp implementation that brings Common Lisp and C++ together"
  homepage "https://github.com/clasp-developers/clasp"
  url "https://github.com/clasp-developers/clasp.git",
      using:    :git,
      revision: "a072f7cd132f9dd6b9dc7c6f3c7a99641c7af72a"
  version "2.7.0-127-ga072f7cd1"
  license "GPL-2.0-or-later"
  head "https://github.com/clasp-developers/clasp.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/clasp-developers/clasp"
    sha256 arm64_sonoma: "ef57107616c552fc7ff7c1125ef49b0afef20b35d42965f90f5d84f1b5785ff6"
    sha256 ventura:      "68fc9090e926f8a59f75b467ca661e90e1b1f2954990e52825f0b172e9d2d01c"
  end

  depends_on "boost" => :build
  depends_on "libunwind-headers" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "sbcl" => :build
  depends_on "fmt"
  depends_on "gmp"
  depends_on "lld"
  depends_on "llvm@19"

  conflicts_with "cando", because: "both install `clasp` binaries"

  def install
    ENV.deparallelize
    system "./koga", "--reproducible-build", "--bin-path=#{bin}", "--share-path=#{share}/clasp/",
      "--lib-path=#{lib}/clasp/", "--llvm-config=#{Formula["llvm@19"].opt_bin}/llvm-config",
      "--pkg-config=#{Formula["pkg-config"].opt_bin}/pkg-config", "--dylib-path=#{lib}/",
      "--pkgconfig-path=#{lib}/pkgconfig/", "--cxxflags=-I#{Formula["boost"].include}/",
      "--cppflags=-I#{Formula["boost"].include}/", "--skip-sync=ansi-test,mps,cl-bench,cl-who"
    system "ninja", "-C", "build", "install"
  end

  test do
    (testpath/"simple.lisp").write <<~EOS
      (write-line "Hello, world!")
    EOS
    assert_match "Hello, world!",
      shell_output("DYLD_LIBRARY_PATH=#{lib} #{bin}/clasp --script #{testpath}/simple.lisp")
  end
end
