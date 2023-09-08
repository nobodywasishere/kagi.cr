require "../spec_helper"

describe Kagi::Enrich do
  context ".web" do
    it "builds objects from search results" do
      #
      # Example borrowed from Kagi docs
      # https://help.kagi.com/kagi/api/enrich.html#example
      #
      body = File.read("#{__DIR__}/enrich_web.json")
      params = URI::Params.encode({"q" => "microsoft"})
      WebMock.stub(:get, "https://kagi.com/api/v0/enrich/web?q=microsoft")
        .to_return(body: body, status: 200)

      results = Kagi::Enrich.web("microsoft")

      results.each do |result|
        next if result.is_a? Kagi::Object::RelatedResults

        result = result.as(Kagi::Object::Result)

        result.published.should be_a(Time) if result.published
      end
    end
  end

  context ".news" do
    it "builds objects from search results" do
      #
      # Example borrowed from Kagi docs
      # https://help.kagi.com/kagi/api/enrich.html#example-1
      #
      body = File.read("#{__DIR__}/enrich_news.json")
      params = URI::Params.encode({"q" => "microsoft"})
      WebMock.stub(:get, "https://kagi.com/api/v0/enrich/news?q=microsoft")
        .to_return(body: body, status: 200)

      results = Kagi::Enrich.news("microsoft")

      results.each do |result|
        next if result.is_a? Kagi::Object::RelatedResults

        result = result.as(Kagi::Object::Result)

        result.published.should be_a(Time) if result.published
      end
    end
  end
end
