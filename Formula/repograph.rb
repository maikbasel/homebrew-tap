class Repograph < Formula
  desc "Register, group, and expose local git repos as structured context for AI agents"
  homepage "https://github.com/maikbasel/repograph"
  version "0.3.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/maikbasel/repograph/releases/download/repograph-v0.3.1/repograph-aarch64-apple-darwin.tar.xz"
      sha256 "37370a103083bbf80a190d40f78fe3fa91a1a24297a814070d54abc3851a1c4b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/maikbasel/repograph/releases/download/repograph-v0.3.1/repograph-x86_64-apple-darwin.tar.xz"
      sha256 "124a13445300ab46c3800ae15d125bc1a5631df0a4e03d78b26e25176b1df351"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/maikbasel/repograph/releases/download/repograph-v0.3.1/repograph-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "cc3fc2b3ca4fb16bdab4df7be7ce8c224681f8f1af006c897de46a947e404956"
    end
    if Hardware::CPU.intel?
      url "https://github.com/maikbasel/repograph/releases/download/repograph-v0.3.1/repograph-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4fc8b1a466f940bc8848324129a5864bfd66875e1fe1a6553afa64a0616e329a"
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
