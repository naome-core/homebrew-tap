class NaomeNetwork < Formula
  desc "Run NAOME nodes and replicate research evidence"
  homepage "https://github.com/naome-core/naome-network"
  url "https://github.com/naome-core/naome-network/releases/download/v0.5.0/naome-network-v0.5.0-macos-arm64.tar.gz"
  sha256 "265b9733a4da819f2b1c29a2591822409d0ae61199437949b3355a55e15ae4c9"
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
