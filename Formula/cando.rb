class Cando < Formula
  desc "Common Lisp implementation and Cando chemistry system"
  homepage "https://github.com/clasp-developers/clasp"
  url "https://github.com/clasp-developers/clasp.git",
      using:    :git,
      revision: "a1906b1aac5530ce8aed4f52b04ded9aa11163f3"
  version "1.0.0-290-ga1906b1aa-gb65e1215"
  license "GPL-2.0-or-later"
  head "https://github.com/clasp-developers/clasp.git",
       using:  :git,
       branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/clasp-developers/clasp"
    sha256 monterey: "4e0b496f6cc9f95d17c4a693b07a23b58d2326c9df2a302a4c738caa5a9b4fec"
    sha256 big_sur:  "2cbaeff05c8c753da78c3b5464d69b0f7081e1253211a46156f9258a404ced7f"
    sha256 catalina: "74f97ea866d03ac77890b73b76fad2be5adf85855dad3be629c91afb3af1ebf3"
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
