class NaomeProtocol < Formula
  desc "Store and exchange research evidence in offline REP archives"
  homepage "https://github.com/naome-core/naome-protocol"
  url "https://github.com/naome-core/naome-protocol/releases/download/v0.1.4/naome-protocol-0.1.4.crate"
  sha256 "6daaa08021a72d145acd66635d07d693c994e80a6cda719c0d4b84db743e658b"
  license "MIT"

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", "--bin", "rep", *std_cargo_args
  end

  test do
    assert_equal "naome-protocol #{version}", shell_output("#{bin}/rep --version").strip

    (testpath/"reading.txt").write("instrument readback\n")
    id = JSON.parse(shell_output("#{bin}/rep blob reading.txt"))
    head = JSON.parse(shell_output("#{bin}/rep snapshot readback --root #{id}"))

    system bin/"rep", "export", head, "exchange.json"
    system bin/"rep", "--db", "receiver.sqlite", "import", "exchange.json"
    system bin/"rep", "--db", "receiver.sqlite", "resolve", head, id, "received.txt"
    assert_equal (testpath/"reading.txt").read, (testpath/"received.txt").read
  end
end
