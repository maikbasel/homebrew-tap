class Repograph < Formula
  desc "Register, group, and expose local git repos as structured context for AI agents"
  homepage "https://github.com/maikbasel/repograph"
  version "0.6.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/maikbasel/repograph/releases/download/repograph-v0.6.0/repograph-aarch64-apple-darwin.tar.xz"
      sha256 "8f6fe5fc8450b6f4d0803cd4ff6810e6e5cfceb6ca0c8686a4adc91fb4e092fa"
    end
    if Hardware::CPU.intel?
      url "https://github.com/maikbasel/repograph/releases/download/repograph-v0.6.0/repograph-x86_64-apple-darwin.tar.xz"
      sha256 "05e9485b1083c6407adcfe16862d47fececd15c66780ca435680d463225f034d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/maikbasel/repograph/releases/download/repograph-v0.6.0/repograph-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "31e6dc1e068203d06f0e056c578d8fb2bbe7dc03179c71533d3ce5401a9b8fd4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/maikbasel/repograph/releases/download/repograph-v0.6.0/repograph-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d03e8cd53a5776e15b21dd2ca861124889a3d3e4582a10e7958c5327f491c509"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "repograph"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "repograph"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "repograph"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "repograph"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
