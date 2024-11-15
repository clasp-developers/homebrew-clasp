class Cando < Formula
  desc "Common Lisp implementation and Cando chemistry system"
  homepage "https://github.com/clasp-developers/clasp"
  url "https://github.com/clasp-developers/clasp.git",
      using:    :git,
      revision: "addf186fb925e5f3b26bf94f0150dabded5721d2"
  version "2.6.0-281-gaddf186fb-g477f0683"
  license "GPL-2.0-or-later"
  head "https://github.com/clasp-developers/clasp.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/clasp-developers/clasp"
    sha256 arm64_sonoma: "7791f3d92ec764e35a92e62a105124eb66647c3bdb3593a7bda7150d9d7307ca"
    sha256 ventura:      "b1b3dc454bba8c1811e7281607c8ea759c61ebade5f7a1fdaa0e154b72d5f98b"
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
    if Hardware::CPU.arm?
      system "./koga", "--reproducible-build", "--bin-path=#{bin}", "--share-path=#{share}/clasp/",
        "--lib-path=#{lib}/clasp/", "--llvm-config=#{Formula["llvm@19"].opt_bin}/llvm-config",
        "--pkg-config=#{Formula["pkg-config"].opt_bin}/pkg-config",
        "--cxxflags=-I#{Formula["boost"].include}/", "--cppflags=-I#{Formula["boost"].include}/",
        "--skip-sync=ansi-test,mps,cl-bench,cl-who", "--extensions=cando,seqan-clasp",
        "--build-mode=bytecode"
    else
      system "./koga", "--reproducible-build", "--bin-path=#{bin}", "--share-path=#{share}/clasp/",
        "--lib-path=#{lib}/clasp/", "--llvm-config=#{Formula["llvm@19"].opt_bin}/llvm-config",
        "--pkg-config=#{Formula["pkg-config"].opt_bin}/pkg-config",
        "--cxxflags=-I#{Formula["boost"].include}/", "--cppflags=-I#{Formula["boost"].include}/",
        "--skip-sync=ansi-test,mps,cl-bench,cl-who", "--extensions=cando,seqan-clasp"
    end
    system "ninja", "-C", "build"
    system "ninja", "-C", "build", "install"
  end

  test do
    (testpath/"simple.lisp").write <<~EOS
      (write-line "Hello, world!")
    EOS
    assert_match "Hello, world!", shell_output("#{bin}/clasp --script #{testpath}/simple.lisp")
  end
end
