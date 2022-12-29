class ClaspCl < Formula
  desc "Common Lisp implementation that brings Common Lisp and C++ together"
  homepage "https://github.com/clasp-developers/clasp"
  url "https://github.com/clasp-developers/clasp.git",
      using:    :git,
      revision: "8debf0b083aaad064bb50ec4c1b8076e124a6644"
  version "2.0.0-118-g8debf0b08"
  license "GPL-2.0-or-later"
  head "https://github.com/clasp-developers/clasp.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/clasp-developers/clasp"
    sha256 monterey:     "6b6af7bf14855309d3389294d00c8f4c857a3085d67fc427ebda07b4ae551e1d"
    sha256 big_sur:      "bf1a8e995c132f9540389f7f90fa8c1762fb461311afe76f094d6cae49508f05"
    sha256 x86_64_linux: "a0132266301b138b30dd49c7d51e819a7ea7473defd8410e8119e7e314f39bfc"
  end

  depends_on "boost" => :build
  depends_on "libunwind-headers" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "sbcl" => :build
  depends_on arch: :x86_64
  depends_on "fmt"
  depends_on "gmp"
  depends_on "llvm@14"

  conflicts_with "cando", because: "both install `clasp` binaries"

  def install
    ENV.deparallelize
    system "./koga", "--reproducible-build", "--bin-path=#{bin}", "--share-path=#{share}/clasp/",
      "--lib-path=#{lib}/clasp/", "--llvm-config=#{Formula["llvm@14"].opt_bin}/llvm-config",
      "--pkg-config=#{Formula["pkg-config"].opt_bin}/pkg-config", "--broken-stdlib",
      "--cxxflags=-I#{Formula["boost"].include}/", "--cppflags=-I#{Formula["boost"].include}/",
      "--skip-sync=ansi-test,mps,cl-bench,cl-who"
    system "ninja", "-C", "build", "install"
  end

  test do
    (testpath/"simple.lisp").write <<~EOS
      (write-line "Hello, world!")
    EOS
    assert_match "Hello, world!", shell_output("#{bin}/clasp --script #{testpath}/simple.lisp")
  end
end
