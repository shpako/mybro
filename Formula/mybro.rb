class Mybro < Formula
  desc "Test description"
  homepage "https://github.com/shpako/mybro"
  version "0.0.1"
  url "https://github.com/shpako/mybro/releases/download/#{version}/mybro"

  sha256 "75e9d345a68a759ab268f0ecef4373a0ae590b07939096a076bdb25f20e69143"
  head "https://github.com/shpako/mybro.git"

  def install
    bin.install "mybro"
  end

  test do
    system bin/"mybro", "--version"
  end
end
