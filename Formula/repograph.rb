class Repograph < Formula
  desc "Register, group, and expose local git repos as structured context for AI agents"
  homepage "https://github.com/maikbasel/repograph"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/maikbasel/repograph/releases/download/repograph-v0.4.0/repograph-aarch64-apple-darwin.tar.xz"
      sha256 "75c52d3dea842d8006c11761301dcc85505546b9ac32e98d0c53a287e6788b2d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/maikbasel/repograph/releases/download/repograph-v0.4.0/repograph-x86_64-apple-darwin.tar.xz"
      sha256 "eda91d51906ea35b92bce9c19954ea6f91c83cd092f66185f08dc187132eee36"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/maikbasel/repograph/releases/download/repograph-v0.4.0/repograph-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a783e83b76806bfd3a0b3dc305496cc9cc62e7e69ba0e7302158233e1d7683b0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/maikbasel/repograph/releases/download/repograph-v0.4.0/repograph-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b94ecf50c622567b35fd51af0793dc0d3d251b980591546c5c3c3d6fb31e95fc"
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
