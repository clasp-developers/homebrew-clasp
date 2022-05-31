class ClaspCl < Formula
  desc "Common Lisp implementation that brings Common Lisp and C++ together"
  homepage "https://github.com/clasp-developers/clasp"
  url "https://github.com/clasp-developers/clasp.git",
      using:    :git,
      revision: "3548cefd97bc090ca9db4c857db2218e35765372"
  version "1.0.0-230-g3548cefd9"
  license "GPL-2.0-or-later"
  head "https://github.com/clasp-developers/clasp.git",
       using:  :git,
       branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/clasp-developers/clasp"
    sha256 monterey: "50f5d68b72236ae0f04c8432bd8248a6f23748c39cbca76247ac7edcd03b4338"
    sha256 big_sur:  "86a8c0703d84136c88ed8f0e29951c19d696cfe340c2c7841ba144df669a2dca"
    sha256 catalina: "2147ef8a0821c8f196f77df64c3884f470b2703d4cfdcac4e48afbfd751b9651"
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
