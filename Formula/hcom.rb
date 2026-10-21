class Hcom < Formula
  desc "Connect Claude Code, Gemini CLI, Codex, OpenCode, Kilo Code, Pi, Oh My Pi, Antigravity, Cursor, Kimi, Copilot, Qoder CLI, and Grok Build so agents can message, watch, and spawn each other across terminals"
  homepage "https://github.com/aannoo/hcom"
  version "0.7.31"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/aannoo/hcom/releases/download/v0.7.31/hcom-aarch64-apple-darwin.tar.gz"
      sha256 "4796a1c1c139453c792b802c10163f15037f2ce382920599689e7eb1aad74de1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aannoo/hcom/releases/download/v0.7.31/hcom-x86_64-apple-darwin.tar.gz"
      sha256 "227fbc53a0b53e813c10232bd509e5c69d74a87be944e61883d89bb1daa996ae"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/aannoo/hcom/releases/download/v0.7.31/hcom-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "e28cab039a3351a115ad1126f3c98f2d81966b24ac7a72436eec4faa4775c2c4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aannoo/hcom/releases/download/v0.7.31/hcom-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "ba0348fa87d9f56b4e904f249f1a2b4bbd9501d82e4431530660245c09d3f2bc"
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
