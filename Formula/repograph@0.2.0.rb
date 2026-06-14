class RepographAT020 < Formula
  desc "Register, group, and expose local git repos as structured context for AI agents"
  homepage "https://github.com/maikbasel/repograph"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/maikbasel/repograph/releases/download/v0.2.0/repograph-aarch64-apple-darwin.tar.xz"
      sha256 "ede2ff2b5b36cf1b0ab2bebe46ab6542b117b33d8e8738632212d2aa22e5f41b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/maikbasel/repograph/releases/download/v0.2.0/repograph-x86_64-apple-darwin.tar.xz"
      sha256 "09c3650cda835a84b37e6d390d5f2f4653307dc5bd170361f19fa300424b7638"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/maikbasel/repograph/releases/download/v0.2.0/repograph-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "53137ddf41eb0a4c04f19be7b737b43a2b46068a926402de6b7068c470fc45fa"
    end
    if Hardware::CPU.intel?
      url "https://github.com/maikbasel/repograph/releases/download/v0.2.0/repograph-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b436a4eeb299bccfc31d05baa4f2aeaeec37d8794d2b43740f68a48bb4e7f0a1"
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
