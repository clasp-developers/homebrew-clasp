class Cando < Formula
  desc "Common Lisp implementation and Cando chemistry system"
  homepage "https://github.com/clasp-developers/clasp"
  url "https://github.com/clasp-developers/clasp.git",
      using:    :git,
      revision: "d71a62487b2e9eb1922aa3602f5c5348268f87dc"
  version "1.0.0-275-gd71a62487-gedef9eea"
  license "GPL-2.0-or-later"
  head "https://github.com/clasp-developers/clasp.git",
       using:  :git,
       branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/clasp-developers/clasp"
    sha256 monterey: "0fca14589f24f76d118572cd7b42a6dbeb9b99b8ebed6056d73ed6f7f7a37f49"
    sha256 big_sur:  "75b8fac5ed8e83b69cf3b6924f69e24f9dc9684fd8c90ccaf8db222e8222f4c6"
    sha256 catalina: "8936e10ee95b2eed2e6b978d1637be7b7b4db95f43281dbdb45ef332b3cdf8d5"
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
      "--jupyter-path=#{share}/jupyter/", "--jupyter", "--extensions=cando,seqan-clasp"
    system "ninja", "-C", "build"
    system "ninja", "-C", "build", "install"
  end

  test do
    assert_match "clasp-boehmprecise", shell_output("#{bin}/clasp --version")
  end
end
