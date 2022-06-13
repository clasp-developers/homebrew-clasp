class Cando < Formula
  desc "Common Lisp implementation and Cando chemistry system"
  homepage "https://github.com/clasp-developers/clasp"
  url "https://github.com/clasp-developers/clasp.git",
      using:    :git,
      revision: "e8f9b46082fdb52549b975935292856a709b50a2"
  version "1.0.0-284-ge8f9b4608-gb65e1215"
  license "GPL-2.0-or-later"
  head "https://github.com/clasp-developers/clasp.git",
       using:  :git,
       branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/clasp-developers/clasp"
    sha256 monterey: "19996d47455d075b88ea1d46869a750db7c42522b3131654b02e1347f909b220"
    sha256 big_sur:  "fa13e6c6d33fdeed286a726db02f93b972dc5c4ad8e46681099a1d014d6c3fb7"
    sha256 catalina: "8b5cf55e184b3bbce5be7a3c4ae054023ea1f6a6d5eb81bc36c35097bdf74adf"
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
  depends_on "zeromq"
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
