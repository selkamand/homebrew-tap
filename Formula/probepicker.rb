class Probepicker < Formula
  desc "Identify most variable probes in larger-than-memory methylation array datasets"
  homepage "https://selkamand.github.io/probepicker"
  version "0.1.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/selkamand/probepicker/releases/download/v0.1.3/probepicker-aarch64-apple-darwin.tar.gz"
      sha256 "5b4bdfd8cdb59436074846a2efe41b1350ee0fd29f611b70847bb4c317b27c17"
    end
    if Hardware::CPU.intel?
      url "https://github.com/selkamand/probepicker/releases/download/v0.1.3/probepicker-x86_64-apple-darwin.tar.gz"
      sha256 "12357c38b6742f5e6a26644d9bd51dc21e4b3c04fb9ffa5b4f70c826bf128a73"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/selkamand/probepicker/releases/download/v0.1.3/probepicker-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "685e1b2b7c99862ace3faec311058e57afb78ed17cbd374b854b52538f6b01f0"
    end
  end

  BINARY_ALIASES = {"aarch64-apple-darwin": {}, "x86_64-apple-darwin": {}, "x86_64-pc-windows-gnu": {}, "x86_64-unknown-linux-gnu": {}}

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
      bin.install "probepicker"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "probepicker"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "probepicker"
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
