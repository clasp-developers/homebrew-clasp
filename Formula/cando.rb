class Cando < Formula
  desc "Common Lisp implementation and Cando chemistry system"
  homepage "https://github.com/clasp-developers/clasp"
  url "https://github.com/clasp-developers/clasp.git",
      using:    :git,
      revision: "fba47e89ea9e923e225130dbe638a1708b415a55"
  version "1.0.0-528-gfba47e89e-g7371ab99"
  license "GPL-2.0-or-later"
  head "https://github.com/clasp-developers/clasp.git",
       using:  :git,
       branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/clasp-developers/clasp"
    sha256 monterey: "94bab094bfd30d2ea262c7f1c667932dc5c6e1fe649304359ef3ae7b8f156d72"
    sha256 big_sur:  "3fbce84cc842d3be1d3f84a470768a1feb4cb0d2f0db098285278882415c2933"
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
