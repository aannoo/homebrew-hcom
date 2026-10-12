class Hcom < Formula
  desc "Connect Claude Code, Gemini CLI, Codex, OpenCode, Kilo Code, Pi, Oh My Pi, Antigravity, Cursor, Kimi, Copilot, Qoder CLI, and Grok Build so agents can message, watch, and spawn each other across terminals"
  homepage "https://github.com/aannoo/hcom"
  version "0.7.29"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/aannoo/hcom/releases/download/v0.7.29/hcom-aarch64-apple-darwin.tar.gz"
      sha256 "0787cb3e587ff8b245c05f2cb66331278314b717c809d9bfcd796d24ec9505f9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aannoo/hcom/releases/download/v0.7.29/hcom-x86_64-apple-darwin.tar.gz"
      sha256 "49e7d80babecfb09463b8dbe5c4c3475777af40c3ffe3d48d9bbd97fad793c3d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/aannoo/hcom/releases/download/v0.7.29/hcom-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "9129faea94faed75fe285e74ac2c2a9ad79443e93b3851ef4dd4cf7a961d158f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aannoo/hcom/releases/download/v0.7.29/hcom-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "3e773ea2ca705dbf116ab733b73ff963d0d595bce1e04b27e86d15e4b3ade32c"
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
