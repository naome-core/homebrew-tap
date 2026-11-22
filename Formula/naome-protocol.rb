class NaomeProtocol < Formula
  desc "Store and exchange research evidence in local archives"
  homepage "https://github.com/naome-core/naome-protocol"
  url "https://github.com/naome-core/naome-protocol/releases/download/v0.1.5/naome-protocol-0.1.5.crate"
  sha256 "3936ca2fe570bc80cdc063d374aa15d5075252e5429a9aaeb7d825b8c662c99e"
  license "MIT"

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    legacy = version.to_s == "0.1.5"
    cli = bin/(legacy ? "rep" : "nao")
    version_name = legacy ? "naome-protocol" : "nao"
    assert_equal "#{version_name} #{version}", shell_output("#{cli} --version").strip

    (testpath/"reading.txt").write("instrument readback\n")
    id = JSON.parse(shell_output("#{cli} blob reading.txt"))
    head = JSON.parse(shell_output("#{cli} snapshot readback --root #{id}"))

    system cli, "export", head, "exchange.json"
    system cli, "--db", "receiver.sqlite", "import", "exchange.json"
    system cli, "--db", "receiver.sqlite", "resolve", head, id, "received.txt"
    assert_equal (testpath/"reading.txt").read, (testpath/"received.txt").read
  end
end
