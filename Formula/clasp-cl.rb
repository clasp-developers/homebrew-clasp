class ClaspCl < Formula
  desc "Common Lisp implementation that brings Common Lisp and C++ together"
  homepage "https://github.com/clasp-developers/clasp"
  url "https://github.com/clasp-developers/clasp.git",
      using:    :git,
      revision: "ba564e0564ecc21df405b32443e59f370cdf50ff"
  version "2.2.0-169-gba564e056"
  license "GPL-2.0-or-later"
  head "https://github.com/clasp-developers/clasp.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/clasp-developers/clasp"
    sha256 monterey: "56817c356980feab6b7035347bc0e39df41c89f7ff1b68b4434f6fbf2d6d2c43"
    sha256 big_sur:  "83101a83bcd5fa9bd5262e848852efb2ca3fe71eb14306d2b43a7b29ec6146a7"
  end

  depends_on "boost" => :build
  depends_on "libunwind-headers" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "sbcl" => :build
  depends_on arch: :x86_64
  depends_on "fmt"
  depends_on "gmp"
  depends_on "llvm@15"

  conflicts_with "cando", because: "both install `clasp` binaries"

  def install
    ENV.deparallelize
    system "./koga", "--reproducible-build", "--bin-path=#{bin}", "--share-path=#{share}/clasp/",
      "--lib-path=#{lib}/clasp/", "--llvm-config=#{Formula["llvm@15"].opt_bin}/llvm-config",
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
