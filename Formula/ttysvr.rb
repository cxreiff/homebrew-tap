class Ttysvr < Formula
  desc "Screensavers for your terminal"
  homepage "https://github.com/cxreiff/ttysvr"
  version "0.3.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cxreiff/ttysvr/releases/download/v0.3.3/ttysvr-aarch64-apple-darwin.tar.xz"
      sha256 "0e30890b41ae7eda17af994b79b4fac5300a626d4100620cb2678bb6aba8ea39"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cxreiff/ttysvr/releases/download/v0.3.3/ttysvr-x86_64-apple-darwin.tar.xz"
      sha256 "761b60f369380d1c709a796a2e5a7a0aea76d78a632a47c8145624cabd3aaff2"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/cxreiff/ttysvr/releases/download/v0.3.3/ttysvr-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "0e0379ffd6e1b9629dce7e95f28dceb8e8f42cc723e4dd3def9fc08c9202f0b8"
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
    "x86_64-pc-windows-gnu":    {},
    "x86_64-unknown-linux-gnu": {},
  }.freeze

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
