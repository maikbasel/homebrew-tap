class Repograph < Formula
  desc "CLI for registering, grouping, and exposing local git repositories as structured context for AI agents."
  homepage "https://github.com/maikbasel/repograph"
  version "0.2.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/maikbasel/repograph/releases/download/repograph-v0.2.1/repograph-aarch64-apple-darwin.tar.xz"
      sha256 "96126740729b86e9417d088c2c1303135ace65442f5fd558f72ad1e123df5f27"
    end
    if Hardware::CPU.intel?
      url "https://github.com/maikbasel/repograph/releases/download/repograph-v0.2.1/repograph-x86_64-apple-darwin.tar.xz"
      sha256 "9f6d3db2e765b9cf6d7c5d048d39e72813d72183cf37b448a70da4995de427c6"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/maikbasel/repograph/releases/download/repograph-v0.2.1/repograph-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "9f36fe61edb12c436a94a18653196b291842871820c3315bdd433160b23b94de"
    end
    if Hardware::CPU.intel?
      url "https://github.com/maikbasel/repograph/releases/download/repograph-v0.2.1/repograph-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "1693fce1e87f8146d3c2afc162389865b8cb848f7281d5891b895bf15fd6c7f7"
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
