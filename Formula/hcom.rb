class Hcom < Formula
  desc "Connect Claude Code, Gemini CLI, Codex, OpenCode, Kilo Code, Pi, Oh My Pi, Antigravity, Cursor, Kimi, and Copilot so agents can message, watch, and spawn each other across terminals"
  homepage "https://github.com/aannoo/hcom"
  version "0.7.27"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/aannoo/hcom/releases/download/v0.7.27/hcom-aarch64-apple-darwin.tar.gz"
      sha256 "6b7a999cf39559b0ad58de26ba91037ccd58c85a4e51d51ef5d24b3e8e49c4ec"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aannoo/hcom/releases/download/v0.7.27/hcom-x86_64-apple-darwin.tar.gz"
      sha256 "489dbca315b4cba25961a5c4eef43341c75d6990fa003ae1bb165ca511f87767"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/aannoo/hcom/releases/download/v0.7.27/hcom-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "628ef746afdad75ed7338ff6bbe70c76e1c05e36bddd83ba1040570823cb7e38"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aannoo/hcom/releases/download/v0.7.27/hcom-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "8ae97ff6fef63c637d66ddf882651aadd035bd74ae26c0787743869c20a5391d"
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
