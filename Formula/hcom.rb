class Hcom < Formula
  desc "Connect Claude Code, Gemini CLI, Codex, OpenCode, Kilo Code, Pi, Antigravity, Cursor, Kimi, and Copilot so agents can message, watch, and spawn each other across terminals"
  homepage "https://github.com/aannoo/hcom"
  version "0.7.21"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/aannoo/hcom/releases/download/v0.7.21/hcom-aarch64-apple-darwin.tar.gz"
      sha256 "284d5cffd0606ea3ccc8ec35e7f09fd38bdf42686491c975f012de94ab09c2fc"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aannoo/hcom/releases/download/v0.7.21/hcom-x86_64-apple-darwin.tar.gz"
      sha256 "add048c5f4b964f20fb9527869ca9fbc836f7b386520eeee34c81db91374640e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/aannoo/hcom/releases/download/v0.7.21/hcom-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "9b8e70d35c9195484895a287fa142963ba2d809b64e0add3e6c9f51a9fc09eb2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aannoo/hcom/releases/download/v0.7.21/hcom-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "84a3e7ebd7ac5fa5ede93918ebf5e5190c55f1a4cebd80f68c8729e393569a38"
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
