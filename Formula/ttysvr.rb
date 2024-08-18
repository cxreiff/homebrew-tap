class Ttysvr < Formula
  desc "Screensavers for your terminal"
  homepage "https://github.com/cxreiff/ttysvr"
  version "0.2.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cxreiff/ttysvr/releases/download/v0.2.1/ttysvr-aarch64-apple-darwin.tar.xz"
      sha256 "539e74012bcd5a018a69c621f9e0977b24798becbd995a95a9124173e8339933"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cxreiff/ttysvr/releases/download/v0.2.1/ttysvr-x86_64-apple-darwin.tar.xz"
      sha256 "6c888cab8543c468a230f680997eb04b8259aedf8225beed21cf58a2ebac6d3b"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/cxreiff/ttysvr/releases/download/v0.2.1/ttysvr-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "6558c6f9b7306f1ca0ce9534ad2e96ae4320e5fc9c9128f0dd561951ae33ede2"
  end
  license "MIT OR Apache-2.0"

  BINARY_ALIASES = { "aarch64-apple-darwin": {}, "x86_64-apple-darwin": {}, "x86_64-pc-windows-gnu": {},
"x86_64-unknown-linux-gnu": {} }.freeze

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
    bin.install "ttysvr" if OS.mac? && Hardware::CPU.arm?
    bin.install "ttysvr" if OS.mac? && Hardware::CPU.intel?
    bin.install "ttysvr" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
