class Mach < Formula
  desc "A CLI tool for managing todos with a weekly calendar"
  homepage "https://machich.co"
  version "0.2.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/rvcas/mach/releases/download/v0.2.4/machich-aarch64-apple-darwin.tar.xz"
      sha256 "fe6b4b6ab19d12bb24209a56e69aabeba24e2965e8a5cae5e846a8d4f1fa9ca1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rvcas/mach/releases/download/v0.2.4/machich-x86_64-apple-darwin.tar.xz"
      sha256 "ea75c63cd214e24981458bda93f23b849db649965479c505759ecc75d45d8e99"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/rvcas/mach/releases/download/v0.2.4/machich-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "79a308ab9cf60100c85e67b67c0bbab0acc94c2c6faff53dde0ea3fd73582970"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rvcas/mach/releases/download/v0.2.4/machich-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f063d91e94ad1367c91903d8c1b1360cc612b4a8df1e1d68e783da5e7081dc03"
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
