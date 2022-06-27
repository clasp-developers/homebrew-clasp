class Cando < Formula
  desc "Common Lisp implementation and Cando chemistry system"
  homepage "https://github.com/clasp-developers/clasp"
  url "https://github.com/clasp-developers/clasp.git",
      using:    :git,
      revision: "ea5c624d93fe5b7c38dd9e90f64fd26d91f2c805"
  version "1.0.0-313-gea5c624d9-g5622c413"
  license "GPL-2.0-or-later"
  head "https://github.com/clasp-developers/clasp.git",
       using:  :git,
       branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/clasp-developers/clasp"
    sha256 monterey: "855bc4bc867d296e365ca28a34a436fd384f785fafcefc5b5291f14f2da2bc9d"
    sha256 big_sur:  "f3b57c50341a8620742e4ea0edbb32d04fc682bcb90edf9c7c4f42e3e4452d36"
    sha256 catalina: "b3a89509ee04cc6230977acce454c719df87d03284064e635db5a09f036e8160"
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
