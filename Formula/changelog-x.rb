class ChangelogX < Formula
  desc "Generate high-quality changelogs from conventional commits with AI enhancement"
  homepage "https://github.com/maikbasel/changelog-x"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/maikbasel/changelog-x/releases/download/v0.1.1/changelog-x-aarch64-apple-darwin.tar.xz"
      sha256 "5aff06b6aac9640d1445cc231543269dc27f2a57eaddbe1f1a9118b758b86e6d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/maikbasel/changelog-x/releases/download/v0.1.1/changelog-x-x86_64-apple-darwin.tar.xz"
      sha256 "4f6f77b785dfc31ae2516d9c1fbc77a6ecbc9bc46558f7ed8d88bbe281d8188a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/maikbasel/changelog-x/releases/download/v0.1.1/changelog-x-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "30151e6d33c505e9ce7aa3f8e2a8503f292e8a2ec72aba9ca84e8d1c8da968f6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/maikbasel/changelog-x/releases/download/v0.1.1/changelog-x-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3d94cf9919ef25ae98a80f2a435b82336ab5891f8e301e3d152574641170aca0"
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
