class Mach < Formula
  desc "A CLI tool for managing todos with a weekly calendar"
  homepage "https://machich.co"
  version "0.2.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/rvcas/mach/releases/download/v0.2.1/machich-aarch64-apple-darwin.tar.xz"
      sha256 "9b1d991324ab5d6cc320619949492e6f84ce2b2c01edf06ca6bdabd93bd117f7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rvcas/mach/releases/download/v0.2.1/machich-x86_64-apple-darwin.tar.xz"
      sha256 "94afde93df99d20bc668169bcea74a06080f7384466c216597e0a6232424ce54"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/rvcas/mach/releases/download/v0.2.1/machich-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "0e5881e67e929f60eb1027ab918bee85e4b3c10002fc4621659f353014a741df"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rvcas/mach/releases/download/v0.2.1/machich-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "8eab2da44892ac8077b90e23af7c90f98167dd76c9dacf7afb33f64dd6a70960"
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
