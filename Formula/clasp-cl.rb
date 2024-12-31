class ClaspCl < Formula
  desc "Common Lisp implementation that brings Common Lisp and C++ together"
  homepage "https://github.com/clasp-developers/clasp"
  url "https://github.com/clasp-developers/clasp.git",
      using:    :git,
      revision: "2381c77e0d34d65c1534875f649945090e383bca"
  version "2.6.0-311-g2381c77e0"
  license "GPL-2.0-or-later"
  head "https://github.com/clasp-developers/clasp.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/clasp-developers/clasp"
    sha256 arm64_sonoma: "8ef88d933cd9ffc82313b52b937145498bbf752693e49445c21510e2641da3ed"
    sha256 ventura:      "6e11b1cd631c75ddd6c76175ef8d27a3d781cc89aa2fcd7d7e91f4b51f3bbb9d"
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
    system "./koga", "--reproducible-build", "--bin-path=#{bin}", "--share-path=#{share}/clasp/",
      "--lib-path=#{lib}/clasp/", "--llvm-config=#{Formula["llvm@19"].opt_bin}/llvm-config",
      "--pkg-config=#{Formula["pkg-config"].opt_bin}/pkg-config", "--dylib-path=#{lib}/",
      "--pkgconfig-path=#{lib}/pkgconfig/", "--cxxflags=-I#{Formula["boost"].include}/",
      "--cppflags=-I#{Formula["boost"].include}/", "--skip-sync=ansi-test,mps,cl-bench,cl-who"
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
