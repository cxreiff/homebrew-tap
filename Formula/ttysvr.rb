class Ttysvr < Formula
  desc "Screensavers for your terminal."
  homepage "https://github.com/cxreiff/ttysvr"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cxreiff/ttysvr/releases/download/v0.3.0/ttysvr-aarch64-apple-darwin.tar.xz"
      sha256 "22a5929465381d51bd9c864c8eb14830e1aefb718a5fe4fd9754aba870771a36"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cxreiff/ttysvr/releases/download/v0.3.0/ttysvr-x86_64-apple-darwin.tar.xz"
      sha256 "4349100db2f34dec17c3a300b9ea6c675c86ccf609a519a1731124a604dc0631"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/cxreiff/ttysvr/releases/download/v0.3.0/ttysvr-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "17f39d8ddd8560bed0dc654f6a770408c211b13907deab4f110af659eaf10357"
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
