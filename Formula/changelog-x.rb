class ChangelogX < Formula
  desc "Generate high-quality changelogs from conventional commits with AI enhancement"
  homepage "https://github.com/maikbasel/changelog-x"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/maikbasel/changelog-x/releases/download/v0.2.0/changelog-x-aarch64-apple-darwin.tar.xz"
      sha256 "7a240085351902dce4b622cefe72ee448f8d2100fc0bc1903f5885b47e7a4b6d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/maikbasel/changelog-x/releases/download/v0.2.0/changelog-x-x86_64-apple-darwin.tar.xz"
      sha256 "d2e1d7d8006e55c49e2ad5ea6c673105165a1bb7b123ac26bd8beb5ef0725fb9"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/maikbasel/changelog-x/releases/download/v0.2.0/changelog-x-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "2676b46ddde51b64b0dc684c750940b292f93b11de9e4ade665c81afd80b3a94"
    end
    if Hardware::CPU.intel?
      url "https://github.com/maikbasel/changelog-x/releases/download/v0.2.0/changelog-x-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "70b1df578646c7c69c5c75c597b54411716aa9e03f6136f03a4dad0073d19ad9"
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
    bin.install "cgx" if OS.mac? && Hardware::CPU.arm?
    bin.install "cgx" if OS.mac? && Hardware::CPU.intel?
    bin.install "cgx" if OS.linux? && Hardware::CPU.arm?
    bin.install "cgx" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
