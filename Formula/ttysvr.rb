class Ttysvr < Formula
  desc "Screensavers for your terminal."
  homepage "https://github.com/cxreiff/ttysvr"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cxreiff/ttysvr/releases/download/v0.2.0/ttysvr-aarch64-apple-darwin.tar.xz"
      sha256 "6479b9fdd31701c4e8e75fc50e945f206b494d3ecfbf94d7f8691b72c992127b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cxreiff/ttysvr/releases/download/v0.2.0/ttysvr-x86_64-apple-darwin.tar.xz"
      sha256 "2b7874242895f231b8ed35876d81600d3f3c153e9ece81ddc0509bb78d093fc9"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/cxreiff/ttysvr/releases/download/v0.2.0/ttysvr-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6a62b178863afd3b2cff5a51116a77178df7d37786d9220ec05c247a72e90f8e"
    end
  end
  license "MIT OR Apache-2.0"

  BINARY_ALIASES = {"aarch64-apple-darwin": {}, "x86_64-apple-darwin": {}, "x86_64-pc-windows-gnu": {}, "x86_64-unknown-linux-gnu": {}}

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "ttysvr"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "ttysvr"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "ttysvr"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
