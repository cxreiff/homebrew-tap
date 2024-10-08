class Ttysvr < Formula
  desc "Screensavers for your terminal"
  homepage "https://github.com/cxreiff/ttysvr"
  version "0.3.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cxreiff/ttysvr/releases/download/v0.3.1/ttysvr-aarch64-apple-darwin.tar.xz"
      sha256 "931f50604b5825599179fd9edaaf25c9870b8390c34dc5cc4ed5ec9f916b7917"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cxreiff/ttysvr/releases/download/v0.3.1/ttysvr-x86_64-apple-darwin.tar.xz"
      sha256 "e539579340e06c630a41422542aa088d90eb047cedabbd46a2de79f7f79776ca"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/cxreiff/ttysvr/releases/download/v0.3.1/ttysvr-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "0f044d2cb85c828e9d1e8571a2f1a47a8f11d551a151756d32b1745680406edb"
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
