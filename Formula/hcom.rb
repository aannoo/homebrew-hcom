class Hcom < Formula
  desc "Connect Claude Code, Gemini CLI, and Codex so agents can message, watch, and spawn each other across terminals"
  homepage "https://github.com/aannoo/hcom"
  version "0.7.10"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/aannoo/hcom/releases/download/v0.7.10/hcom-aarch64-apple-darwin.tar.gz"
      sha256 "cf37f95e248cbca04ba8aaa6448fd35b5ab9e062c41d035ad4ad37be3f7d7550"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aannoo/hcom/releases/download/v0.7.10/hcom-x86_64-apple-darwin.tar.gz"
      sha256 "348110bc2f0a80d29567fb35c71f3650bb6a4f75536f6e3e206e4816712e61d2"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/aannoo/hcom/releases/download/v0.7.10/hcom-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "8349ceb0d2f6a92b6f044c9f328d138db403aed0c3c5affae3f47504168fc550"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aannoo/hcom/releases/download/v0.7.10/hcom-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "f4600d8e4216f7ffcc4e8ecd82fddefe8819e8dafb29c12e27dc52813642b67b"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":               {},
    "aarch64-linux-android":              {},
    "aarch64-unknown-linux-gnu":          {},
    "aarch64-unknown-linux-musl-dynamic": {},
    "aarch64-unknown-linux-musl-static":  {},
    "x86_64-apple-darwin":                {},
    "x86_64-unknown-linux-gnu":           {},
    "x86_64-unknown-linux-musl-dynamic":  {},
    "x86_64-unknown-linux-musl-static":   {},
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
    bin.install "hcom" if OS.mac? && Hardware::CPU.arm?
    bin.install "hcom" if OS.mac? && Hardware::CPU.intel?
    bin.install "hcom" if OS.linux? && Hardware::CPU.arm?
    bin.install "hcom" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
