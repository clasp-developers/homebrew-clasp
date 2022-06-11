class Cando < Formula
  desc "Common Lisp implementation and Cando chemistry system"
  homepage "https://github.com/clasp-developers/clasp"
  url "https://github.com/clasp-developers/clasp.git",
      using:    :git,
      revision: "87b4f5c244138a6b6b759605ad3cfb21a611dc94"
  version "1.0.0-278-g87b4f5c24-gf16e586e"
  license "GPL-2.0-or-later"
  head "https://github.com/clasp-developers/clasp.git",
       using:  :git,
       branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/clasp-developers/clasp"
    sha256 monterey: "84a080f2c20bb95e45c5c9764225cfd3590340f643da6f7319911dabc108aec8"
    sha256 big_sur:  "ee08c25215c863b0b00a61393039cd891e3509e531fbb172a64ae49b9ea881da"
    sha256 catalina: "a19620dacb1805fdc2d23e2fe47e8b78abd4d23835dcc7b9fdb20324449dd7da"
  end

  depends_on "boost" => :build
  depends_on "libunwind-headers" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "sbcl" => :build
  depends_on "expat"
  depends_on "fmt"
  depends_on "gmp"
  depends_on "jupyterlab"
  depends_on "llvm@13"
  depends_on "netcdf"
  uses_from_macos "libffi"

  conflicts_with "clasp-cl", because: "both install `clasp` binaries"

  def install
    ENV.deparallelize
    system "./koga", "--bin-path=#{bin}", "--share-path=#{share}/clasp/", "--lib-path=#{lib}/clasp/",
      "--extensions=cando,seqan-clasp"
    system "ninja", "-C", "build"
    system "ninja", "-C", "build", "install"
  end

  test do
    assert_match "clasp-boehmprecise", shell_output("#{bin}/clasp --version")
  end
end
