class ClaspCl < Formula
  desc "Common Lisp implementation that brings Common Lisp and C++ together"
  homepage "https://github.com/clasp-developers/clasp"
  url "https://github.com/clasp-developers/clasp.git",
      using:    :git,
      revision: "ea5c624d93fe5b7c38dd9e90f64fd26d91f2c805"
  version "1.0.0-313-gea5c624d9"
  license "GPL-2.0-or-later"
  head "https://github.com/clasp-developers/clasp.git",
       using:  :git,
       branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/clasp-developers/clasp"
    sha256 monterey: "99556ce7d5d68def12ee8140cb442681c0d1dffec4f64e9c1d04297a90601318"
    sha256 big_sur:  "7aab29b40c9da23ad5ed77d7098304ccf57b97d8125403aa86465121a07a076d"
    sha256 catalina: "434d81af1267b643a1059748fabbe42814b9a3a4ca3a294a64b9c6f95f975eed"
  end

  depends_on "boost" => :build
  depends_on "libunwind-headers" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "sbcl" => :build
  depends_on "fmt"
  depends_on "gmp"
  depends_on "llvm@13"
  uses_from_macos "libffi"

  conflicts_with "cando", because: "both install `clasp` binaries"

  def install
    ENV.deparallelize
    system "./koga", "--bin-path=#{bin}", "--share-path=#{share}/clasp/", "--lib-path=#{lib}/clasp/"
    system "ninja", "-C", "build", "install"
  end

  test do
    assert_match "clasp-boehmprecise", shell_output("#{bin}/clasp --version")
  end
end
