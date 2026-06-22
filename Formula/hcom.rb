class Hcom < Formula
  desc "Connect Claude Code, Gemini CLI, Codex, OpenCode, Kilo Code, Pi, Antigravity, Cursor, Kimi, and Copilot so agents can message, watch, and spawn each other across terminals"
  homepage "https://github.com/aannoo/hcom"
  version "0.7.22"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/aannoo/hcom/releases/download/v0.7.22/hcom-aarch64-apple-darwin.tar.gz"
      sha256 "f1836c9bd2102e3ee59ef6215ca16be87e55b3ebb104fc6406a04487864c3b1d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aannoo/hcom/releases/download/v0.7.22/hcom-x86_64-apple-darwin.tar.gz"
      sha256 "68296ef64c73fd2ea345e2190c0fb62d9877ce138be7c502dde000debbbc6f39"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/aannoo/hcom/releases/download/v0.7.22/hcom-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "138297f9034e99dc0a45123ef2f2d28287c91d07c763ea268f3892f78795351a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aannoo/hcom/releases/download/v0.7.22/hcom-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "f8f954b46f41db0cb168c1e706b60c745381bda058ad9f4a9c60aef30b13d5f3"
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
