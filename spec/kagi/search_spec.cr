require "../spec_helper"

describe Kagi::Search do
  context ".query" do
    it "builds objects from search results" do
      #
      # Example borrowed from Kagi docs
      # https://help.kagi.com/kagi/api/search.html#examples
      #
      body = File.read("#{__DIR__}/search.json")

      params = URI::Params.encode({"q" => "steve jobs", "limit" => "10"})
      WebMock.stub(:get, "https://kagi.com/api/v0/search?#{params}")
        .to_return(body: body, status: 200)

      results = Kagi::Search.query("steve jobs", limit: 10)

      results.each do |result|
        next if result.is_a? Kagi::Object::RelatedResults

        result = result.as(Kagi::Object::Result)

        result.published.should be_a(Time) if result.published
      end
    end
  end
end
