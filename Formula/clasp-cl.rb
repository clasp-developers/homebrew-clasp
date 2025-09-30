class ClaspCl < Formula
  desc "Common Lisp implementation that brings Common Lisp and C++ together"
  homepage "https://github.com/clasp-developers/clasp"
  url "https://github.com/clasp-developers/clasp.git",
      using:    :git,
      revision: "e776b282101eddc4aa514f653139c33a598bbcb2"
  version "2.7.0-245-ge776b2821"
  license "GPL-2.0-or-later"
  head "https://github.com/clasp-developers/clasp.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/clasp-developers/clasp"
    sha256 arm64_sequoia: "3871a535f039c57b86927e74eed2f6fe4e25017c693fb044a81cdb7d83f2c035"
    sha256 arm64_sonoma:  "eef67644dab4b75658c9fe993d0081c13234e0901c5027f2a58285a55955373a"
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
      "--cppflags=-I#{Formula["boost"].include}/", "--skip-sync=ansi-test,mps,cl-bench,cl-who",
      "--no-compile-file-parallel"
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
