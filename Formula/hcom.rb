class Hcom < Formula
  desc "Connect Claude Code, Gemini CLI, Codex, and OpenCode so agents can message, watch, and spawn each other across terminals"
  homepage "https://github.com/aannoo/hcom"
  version "0.7.13"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/aannoo/hcom/releases/download/v0.7.13/hcom-aarch64-apple-darwin.tar.gz"
      sha256 "23032fa756225e58495c6ef38f351b6504776f8fb6399b3939762f7ecedcb9ce"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aannoo/hcom/releases/download/v0.7.13/hcom-x86_64-apple-darwin.tar.gz"
      sha256 "15bd52cdb7511a04203c27447d282a0b026d83826ad8160f92db09c804649bdd"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/aannoo/hcom/releases/download/v0.7.13/hcom-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "8247df30bc99d5bb245efdce8292a4179fe271d9846284037fe532c9ba985a3e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aannoo/hcom/releases/download/v0.7.13/hcom-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "b6be58e79cdf5ca1ba13f99bef388be162449849c40a8d583735e5695a686072"
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
