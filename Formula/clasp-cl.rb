class ClaspCl < Formula
  desc "Common Lisp implementation that brings Common Lisp and C++ together"
  homepage "https://github.com/clasp-developers/clasp"
  url "https://github.com/clasp-developers/clasp.git",
      using:    :git,
      revision: "1ede2f85d9d1db06370829dbc27471567e1b387f"
  version "1.0.0-261-g1ede2f85d"
  license "GPL-2.0-or-later"
  head "https://github.com/clasp-developers/clasp.git",
       using:  :git,
       branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/clasp-developers/clasp"
    sha256 monterey: "7a8b7a3c94e23835aef6c6174c50529a25fe0a311e436c39bbe68f7fd0a865dc"
    sha256 big_sur:  "64d7d09359b7d5cc7084ac4e395a256a33838bb9292402a628f78c50b7c8fff2"
    sha256 catalina: "16dd8e04456086b0968342355d5db2e1d05a322ea2ed3960a469ad1b04dc6913"
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
