class Ttysvr < Formula
  desc "Screensavers for your terminal"
  homepage "https://github.com/cxreiff/ttysvr"
  version "0.3.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cxreiff/ttysvr/releases/download/v0.3.2/ttysvr-aarch64-apple-darwin.tar.xz"
      sha256 "f2f72be59e3d26133576ac2fa5a2f6278188c2be906e4cc44c483cf6afb8f9c1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cxreiff/ttysvr/releases/download/v0.3.2/ttysvr-x86_64-apple-darwin.tar.xz"
      sha256 "a1dd4545393e5cf5d25f5fb939733ec9e484f6e40d109e23f7f96b201cd626ae"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/cxreiff/ttysvr/releases/download/v0.3.2/ttysvr-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "44ce24f9199b7f33906d2a7a43329bd51ffacbe462a7280580cd7e9896f534e8"
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
