class Mach < Formula
  desc "A CLI tool for managing todos with a weekly calendar"
  homepage "https://machich.co"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/rvcas/mach/releases/download/v0.2.0/machich-aarch64-apple-darwin.tar.xz"
      sha256 "ad87507e9c7c7065b80f5b777f1cc8c476ff5f9298d06606c6a8449f54050643"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rvcas/mach/releases/download/v0.2.0/machich-x86_64-apple-darwin.tar.xz"
      sha256 "5d5dc4f28cd5c934f2dd42884f91bc1470b75d80602b98bf70afa08f0f55a7ae"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/rvcas/mach/releases/download/v0.2.0/machich-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f0ff97158fbb9c915d8831663129ae99e058804d38e696718ac87a313e65de5b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rvcas/mach/releases/download/v0.2.0/machich-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a5c86eb59723f24a4f4e460ae3ca292d1c40c844f2f74c851a82fe2683fad68b"
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
