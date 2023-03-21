class Mybro < Formula
  desc "A description"
  homepage "https://github.com/shpako/mybro"
  version "v0.0.1"
  url "https://github.com/shpako/mybro/releases/download/#{version}/mybro.zip"
  sha256 "43a41bfeb84105863f89aca3484be4958df91cc9a1be294207e221568a46882c"
  license ""
  head "https://github.com/shpako/mybro.git"

  def install
    bin.install "mybro"
  end

  test do
    system "false"
  end
end
