require "../spec_helper"

describe Kagi::SmallWeb do
  context ".feed" do
    it "returns a feed of items" do
      body = File.read("#{__DIR__}/small_web_example.xml")

      WebMock.stub(:get, "https://kagi.com/api/v1/smallweb/feed/")
        .to_return(body: body, status: 200)

      feed = Kagi::SmallWeb.feed

      # feed.items.should be_a(Array(RSS::Item))
    end
  end
end
