class Cando < Formula
  desc "Common Lisp implementation and Cando chemistry system"
  homepage "https://github.com/clasp-developers/clasp"
  url "https://github.com/clasp-developers/clasp.git",
      using:    :git,
      revision: "8ed8e167c11b1044c3727d0b67fd1195257eb7ab"
  version "1.0.0-523-g8ed8e167c-gf1f0709c"
  license "GPL-2.0-or-later"
  head "https://github.com/clasp-developers/clasp.git",
       using:  :git,
       branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/clasp-developers/clasp"
    sha256 monterey: "e32cd8369adcab947e9e9f028dd3ad8921100a3e6d0e4becf4200c9174b8999e"
    sha256 big_sur:  "9ad289d75f63c320905ae16b4752d3b1d540efb67b825945433cc1f200450178"
  end

  depends_on "boost" => :build
  depends_on "libunwind-headers" => :build
  depends_on "pkg-config" => :build
  depends_on "sbcl" => :build
  depends_on "expat"
  depends_on "fmt"
  depends_on "gmp"
  depends_on "jupyterlab"
  depends_on "llvm@14"
  depends_on "netcdf"
  depends_on "ninja"
  depends_on "zeromq"
  uses_from_macos "libffi"

  conflicts_with "clasp-cl", because: "both install `clasp` binaries"

  def install
    ENV.deparallelize
    system "./koga", "--reproducible-build", "--bin-path=#{bin}", "--share-path=#{share}/clasp/",
      "--lib-path=#{lib}/clasp/", "--extensions=cando,seqan-clasp",
      "--skip-sync=ansi-test,mps,cl-bench,cl-who"
    system "ninja", "-C", "build"
    system "ninja", "-C", "build", "install"
  end

  test do
    assert_match "clasp-boehmprecise", shell_output("#{bin}/clasp --version")
  end
end
