class Hcom < Formula
  desc "Connect Claude Code, Gemini CLI, Codex, OpenCode, Kilo Code, Pi, Oh My Pi, Antigravity, Cursor, Kimi, and Copilot so agents can message, watch, and spawn each other across terminals"
  homepage "https://github.com/aannoo/hcom"
  version "0.7.26"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/aannoo/hcom/releases/download/v0.7.26/hcom-aarch64-apple-darwin.tar.gz"
      sha256 "8bc5d5255581592ea61b352ddd6adf7dbb8ddada0bcdad1c2004cd858d18dff6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aannoo/hcom/releases/download/v0.7.26/hcom-x86_64-apple-darwin.tar.gz"
      sha256 "edda9cfb2f1480c1abe310b3529ed39404059f698111fcf9142273ef43f2a71e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/aannoo/hcom/releases/download/v0.7.26/hcom-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "fad1135fb1e9faab4293ae74fcd4a8117e13760c236d0ab07ba74ed85090f781"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aannoo/hcom/releases/download/v0.7.26/hcom-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "fc56419e97bb063c8ec70e577c4144f1a073ff0d88d7d1fa903cc39b24117e91"
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
    "x86_64-pc-windows-gnu":              {},
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "hcom"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "hcom"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "hcom"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "hcom"
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
