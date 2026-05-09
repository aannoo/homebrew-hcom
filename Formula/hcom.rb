class Hcom < Formula
  desc "Connect Claude Code, Gemini CLI, Codex, and OpenCode so agents can message, watch, and spawn each other across terminals"
  homepage "https://github.com/aannoo/hcom"
  version "0.7.16"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/aannoo/hcom/releases/download/v0.7.16/hcom-aarch64-apple-darwin.tar.gz"
      sha256 "7920037047d371596cfc7f691f68c057c390056498651bac81ffebaecc02546d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aannoo/hcom/releases/download/v0.7.16/hcom-x86_64-apple-darwin.tar.gz"
      sha256 "d058991d437f7ef6ba87edd94134b646f9a90562b64cec7f85bc09c8f256dcc0"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/aannoo/hcom/releases/download/v0.7.16/hcom-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "c537d68e485bf10a5f8ddbaab12c78cc61b159ed3881034f06bb7fc7cc3aec44"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aannoo/hcom/releases/download/v0.7.16/hcom-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "841a60116e5afa3c40baf82f4c16d3bf953121540f67726a5a0d6f278ed7e73c"
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
