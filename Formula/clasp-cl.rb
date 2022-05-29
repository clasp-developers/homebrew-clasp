class ClaspCl < Formula
  desc "Common Lisp implementation that brings Common Lisp and C++ together"
  homepage "https://github.com/clasp-developers/clasp"
  url "https://github.com/clasp-developers/clasp.git", using: :git, branch: "main"
  version "1.0.0-220-g0f62839c7"
  license "GPL-2.0-or-later"
  head "https://github.com/clasp-developers/clasp.git"

  depends_on "boost" => :build
  depends_on "libunwind-headers" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "sbcl" => :build
  depends_on "fmt"
  depends_on "gmp"
  depends_on "llvm"
  uses_from_macos "libffi"

  def install
    ENV.deparallelize
    system "./koga", "--bin-path=#{bin}", "--share-path=#{share}/clasp/", "--lib-path=#{lib}/clasp/"
    system "ninja", "-C", "build", "install"
  end

  test do
    assert_match "clasp-boehmprecise", shell_output("#{bin}/clasp --version")
  end
end
