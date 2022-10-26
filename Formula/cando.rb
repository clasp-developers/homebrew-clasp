class Cando < Formula
  desc "Common Lisp implementation and Cando chemistry system"
  homepage "https://github.com/clasp-developers/clasp"
  url "https://github.com/clasp-developers/clasp.git",
      using:    :git,
      revision: "382345fcbadb88991066871084d2302a40e361d8"
  version "1.0.0-1088-g382345fcb-gb8401ca3"
  license "GPL-2.0-or-later"
  head "https://github.com/clasp-developers/clasp.git",
       using:  :git,
       branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/clasp-developers/clasp"
    sha256 monterey: "b2e6ad80b47f46dbfa9a9e9d35425fb6e840efdf8f16bbb29009baf7dfddfa5e"
    sha256 big_sur:  "8dca9c0926321d631f005b7bf10a9ef50bffee3921ddc2cde8ac6d98d233b0df"
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
