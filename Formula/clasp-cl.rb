class ClaspCl < Formula
  desc "Common Lisp implementation that brings Common Lisp and C++ together"
  homepage "https://github.com/clasp-developers/clasp"
  url "https://github.com/clasp-developers/clasp.git",
      using:    :git,
      revision: "5fe99b970aa2132b04178f8f2e82b607525d695e"
  version "2.6.0-160-g5fe99b970"
  license "GPL-2.0-or-later"
  head "https://github.com/clasp-developers/clasp.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/clasp-developers/clasp"
    sha256 ventura: "c87a321b45f5eb9f0e16299100bae573aca9d893ac6e63decb4e3673d1f23449"
  end

  depends_on "boost" => :build
  depends_on "libunwind-headers" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "sbcl" => :build
  depends_on arch: :x86_64
  depends_on "fmt"
  depends_on "gmp"
  depends_on "llvm@17"

  conflicts_with "cando", because: "both install `clasp` binaries"

  def install
    ENV.deparallelize
    system "./koga", "--reproducible-build", "--bin-path=#{bin}", "--share-path=#{share}/clasp/",
      "--lib-path=#{lib}/clasp/", "--llvm-config=#{Formula["llvm@17"].opt_bin}/llvm-config",
      "--pkg-config=#{Formula["pkg-config"].opt_bin}/pkg-config",
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
