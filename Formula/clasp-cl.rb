class ClaspCl < Formula
  desc "Common Lisp implementation that brings Common Lisp and C++ together"
  homepage "https://github.com/clasp-developers/clasp"
  url "https://github.com/clasp-developers/clasp.git",
      using:    :git,
      revision: "4a4866fcbd6efbfdc3380206b1a4891abf48497f"
  version "2.6.0-294-g4a4866fcb"
  license "GPL-2.0-or-later"
  head "https://github.com/clasp-developers/clasp.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/clasp-developers/clasp"
    sha256 arm64_sonoma: "01c0b8ec7f20302816c91303ba7aa9da81c0b1b721fec6131b190ad5626ccfc0"
    sha256 ventura:      "0d17fa0d0d92cc21af85eb9dc1eb9a0dd544eb7ff5e070dbbb4dce2f094fb95e"
  end

  depends_on "boost" => :build
  depends_on "libunwind-headers" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "sbcl" => :build
  depends_on "fmt"
  depends_on "gmp"
  depends_on "lld"
  depends_on "llvm@19"

  conflicts_with "cando", because: "both install `clasp` binaries"

  def install
    ENV.deparallelize
    if Hardware::CPU.arm?
      system "./koga", "--reproducible-build", "--bin-path=#{bin}", "--share-path=#{share}/clasp/",
        "--lib-path=#{lib}/clasp/", "--llvm-config=#{Formula["llvm@19"].opt_bin}/llvm-config",
        "--pkg-config=#{Formula["pkg-config"].opt_bin}/pkg-config", "--dylib-path=#{lib}/",
        "--pkgconfig-path=#{lib}/pkgconfig/", "--cxxflags=-I#{Formula["boost"].include}/",
        "--cppflags=-I#{Formula["boost"].include}/", "--skip-sync=ansi-test,mps,cl-bench,cl-who",
        "--build-mode=bytecode"
    else
      system "./koga", "--reproducible-build", "--bin-path=#{bin}", "--share-path=#{share}/clasp/",
        "--lib-path=#{lib}/clasp/", "--llvm-config=#{Formula["llvm@19"].opt_bin}/llvm-config",
        "--pkg-config=#{Formula["pkg-config"].opt_bin}/pkg-config", "--dylib-path=#{lib}/",
        "--pkgconfig-path=#{lib}/pkgconfig/", "--cxxflags=-I#{Formula["boost"].include}/",
        "--cppflags=-I#{Formula["boost"].include}/", "--skip-sync=ansi-test,mps,cl-bench,cl-who"
    end
    system "ninja", "-C", "build", "install"
  end

  test do
    (testpath/"simple.lisp").write <<~EOS
      (write-line "Hello, world!")
    EOS
    assert_match "Hello, world!", shell_output("DYLD_LIBRARY_PATH=#{lib} #{bin}/clasp --script #{testpath}/simple.lisp")
  end
end
