class NaomeNetwork < Formula
  desc "Run NAOME nodes and replicate research evidence"
  homepage "https://github.com/naome-core/naome-network"
  url "https://github.com/naome-core/naome-network/releases/download/v0.4.0/naome-network-v0.4.0-macos-arm64.tar.gz"
  sha256 "8411a9ecf5c5d5ec7dcb0e66911611aa349d6e28ee6d7f58e6ba34a78862942f"
  license "MIT"

  depends_on arch: :arm64
  depends_on :macos

  def install
    bin.install "naome"
  end

  test do
    assert_equal "naome #{version}", shell_output("#{bin}/naome --version").strip
    system bin/"naome", "--directory", testpath/"node", "archive", "init"
    assert_path_exists testpath/"node/archive.sqlite"
  end
end
