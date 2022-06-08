class ClaspCl < Formula
  desc "Common Lisp implementation that brings Common Lisp and C++ together"
  homepage "https://github.com/clasp-developers/clasp"
  url "https://github.com/clasp-developers/clasp.git",
      using:    :git,
      revision: "108eb3dd9b25c2d3442e691cd7766879032dc8d2"
  version "1.0.0-276-g108eb3dd9"
  license "GPL-2.0-or-later"
  head "https://github.com/clasp-developers/clasp.git",
       using:  :git,
       branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/clasp-developers/clasp"
    sha256 monterey: "b1397ba03913f73354b51be2fbceffd5703b7b506c1356b9ee6bb48b590c2365"
    sha256 big_sur:  "a81b55587b2fa94a706b317401e52ce7094b76720f9a07243746a06796ca8ff8"
    sha256 catalina: "f6a3920af692699f61759c23388c75d11d68a3057966a40f7c0bb1cdea881c56"
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
