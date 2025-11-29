class Mach < Formula
  desc "A CLI tool for managing todos with a weekly calendar"
  homepage "https://machich.co"
  version "0.2.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/rvcas/mach/releases/download/v0.2.2/machich-aarch64-apple-darwin.tar.xz"
      sha256 "f952615ea669ea01b4cb059eebd4e9bbc0cdeb90c87f8fd9972156ece3df91e6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rvcas/mach/releases/download/v0.2.2/machich-x86_64-apple-darwin.tar.xz"
      sha256 "ee02b8cc9e385bc6988edd15ca5c5c56a3c0b87f5246c9f9e8729574bd8f74dc"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/rvcas/mach/releases/download/v0.2.2/machich-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "8837dd98dad8c5e83ae3cf722af6d9f63490b5bb0bafcbbccb0bed5d17e2392a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rvcas/mach/releases/download/v0.2.2/machich-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e1590800be0def482f24c7ee8e36d513def12b3a97565bef4139a85b12b04f1e"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
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
    bin.install "mach" if OS.mac? && Hardware::CPU.arm?
    bin.install "mach" if OS.mac? && Hardware::CPU.intel?
    bin.install "mach" if OS.linux? && Hardware::CPU.arm?
    bin.install "mach" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
