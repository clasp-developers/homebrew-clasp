class ClaspCl < Formula
  desc "Common Lisp implementation that brings Common Lisp and C++ together"
  homepage "https://github.com/clasp-developers/clasp"
  url "https://github.com/clasp-developers/clasp.git",
      using:    :git,
      revision: "77c526c14d015d4020e896362838a3f01920bdb2"
  version "1.0.0-298-g77c526c14"
  license "GPL-2.0-or-later"
  head "https://github.com/clasp-developers/clasp.git",
       using:  :git,
       branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/clasp-developers/clasp"
    sha256 monterey: "231108cc7cc1b8e8e67fe5296bca632a09ddf6713ed94eeb195542b13d519b89"
    sha256 big_sur:  "abecac59d6629538399daa11eff00675e17c567b12c842f98f2bd2e513de6fcd"
    sha256 catalina: "e0cd5464bffd05e9f6c028fa3c2d499f30950724b77913c309cbcd50fdf1eb17"
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
