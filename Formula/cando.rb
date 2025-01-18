class Cando < Formula
  desc "Common Lisp implementation and Cando chemistry system"
  homepage "https://github.com/clasp-developers/clasp"
  url "https://github.com/clasp-developers/clasp.git",
      using:    :git,
      revision: "4b1373673c758781c79afdeefa15ab008deca5d4"
  version "2.6.0-392-g4b1373673-ge3ce8303"
  license "GPL-2.0-or-later"
  head "https://github.com/clasp-developers/clasp.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/clasp-developers/clasp"
    sha256 arm64_sonoma: "551acfd169cc3b0a4eb492ca0f72a99845b081995b391715945860e91e09a2ba"
    sha256 ventura:      "5c25d7728aa339fa8f813019e2133233e84977284bcb32ebbe7a5699845190f9"
  end

  depends_on "boost" => :build
  depends_on "libunwind-headers" => :build
  depends_on "pkg-config" => :build
  depends_on "sbcl" => :build
  depends_on "fmt"
  depends_on "gmp"
  depends_on "jupyterlab"
  depends_on "lld"
  depends_on "llvm@19"
  depends_on "netcdf"
  depends_on "ninja"
  depends_on "zeromq"

  uses_from_macos "expat"

  conflicts_with "clasp-cl", because: "both install `clasp` binaries"

  def install
    ENV.deparallelize
    system "./koga", "--reproducible-build", "--bin-path=#{bin}", "--share-path=#{share}/clasp/",
      "--lib-path=#{lib}/clasp/", "--llvm-config=#{Formula["llvm@19"].opt_bin}/llvm-config",
      "--pkg-config=#{Formula["pkg-config"].opt_bin}/pkg-config", "--dylib-path=#{lib}/",
      "--cxxflags=-I#{Formula["boost"].include}/", "--cppflags=-I#{Formula["boost"].include}/",
      "--skip-sync=ansi-test,mps,cl-bench,cl-who", "--extensions=cando",
      "--pkgconfig-path=#{lib}/pkgconfig/"
    system "ninja", "-C", "build"
    system "ninja", "-C", "build", "install"
  end

  test do
    (testpath/"simple.lisp").write <<~EOS
      (write-line "Hello, world!")
    EOS
    assert_match "Hello, world!",
      shell_output("DYLD_LIBRARY_PATH=#{lib} #{bin}/clasp --script #{testpath}/simple.lisp")
  end
end
