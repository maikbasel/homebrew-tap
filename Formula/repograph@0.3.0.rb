class RepographAT030 < Formula
  desc "Register, group, and expose local git repos as structured context for AI agents"
  homepage "https://github.com/maikbasel/repograph"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/maikbasel/repograph/releases/download/repograph-v0.3.0/repograph-aarch64-apple-darwin.tar.xz"
      sha256 "9e3db4a6d4c5e28978e2bd44f5b6e5d1f2d04171affdbddad7952d3fc8f74ef5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/maikbasel/repograph/releases/download/repograph-v0.3.0/repograph-x86_64-apple-darwin.tar.xz"
      sha256 "3c8a5f61d1103fb6fd9a13a7dc7acc1821ed0b3ee4aa4f397d305745c762e949"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/maikbasel/repograph/releases/download/repograph-v0.3.0/repograph-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "612d4d5254deb36168e89e5eb37ee62bad6fd07afe2b2c5eb84180d64ba86acf"
    end
    if Hardware::CPU.intel?
      url "https://github.com/maikbasel/repograph/releases/download/repograph-v0.3.0/repograph-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "abeeb3c536e9fb5fefd1454ef5a3b635a7f2c6e5686d3b45d5c10d7f9cfd96a4"
    end
  end
  license "MIT"
  keg_only :versioned_formula

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
    bin.install "repograph" if OS.mac? && Hardware::CPU.arm?
    bin.install "repograph" if OS.mac? && Hardware::CPU.intel?
    bin.install "repograph" if OS.linux? && Hardware::CPU.arm?
    bin.install "repograph" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
