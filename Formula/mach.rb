class Mach < Formula
  desc "A CLI tool for managing todos with a weekly calendar"
  homepage "https://machich.co"
  version "0.2.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/rvcas/mach/releases/download/v0.2.3/machich-aarch64-apple-darwin.tar.xz"
      sha256 "4a3a1120cd12990449645db229ec8f0198b7c63a24e751e4ca113e1c94986e60"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rvcas/mach/releases/download/v0.2.3/machich-x86_64-apple-darwin.tar.xz"
      sha256 "160b3a8c2e9b1606656fa0de540d549f57e4552aaee5a8e5588f987155a72c6c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/rvcas/mach/releases/download/v0.2.3/machich-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "117111874a52e5f66bbf9ad8ffa93cf2e31a59880b9f17a98c34aac00feb1b22"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rvcas/mach/releases/download/v0.2.3/machich-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "238e27b118d6ca0219a27a9c4d74f72746fca68691856be671f308889f2a0121"
    end
  end
  license "Apache-2.0"

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
