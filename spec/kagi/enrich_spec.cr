require "../spec_helper"

describe Kagi::Enrich do
  context ".web" do
    #
    # Example borrowed from Kagi docs
    # https://help.kagi.com/kagi/api/enrich.html#example
    #
    body = File.read("#{__DIR__}/enrich_web.json")
    params = URI::Params.encode({"q" => "microsoft"})
    WebMock.stub(:get, "https://kagi.com/api/v0/enrich/web?#{params}")
      .to_return(body: body, status: 200)

    it "builds objects from search results" do
      results = Kagi::Enrich.web("microsoft")

      results.each do |result|
        next if result.is_a? Kagi::Object::RelatedResults

        result = result.as(Kagi::Object::Result)

        result.published.should be_a(Time) if result.published
      end
    end

    it "returns metadata" do
      Kagi::Enrich.web("microsoft")

      Kagi::Request.metadata.should eq(
        Kagi::Request::Metadata.new("db862c5b-c594-4480-9e0c-86a14f71cf0e", "us-east4", 386)
      )
    end
  end

  context ".news" do
    #
    # Example borrowed from Kagi docs
    # https://help.kagi.com/kagi/api/enrich.html#example-1
    #
    body = File.read("#{__DIR__}/enrich_news.json")
    params = URI::Params.encode({"q" => "microsoft"})
    WebMock.stub(:get, "https://kagi.com/api/v0/enrich/news?#{params}")
      .to_return(body: body, status: 200)

    it "builds objects from search results" do
      results = Kagi::Enrich.news("microsoft")

      results.each do |result|
        next if result.is_a? Kagi::Object::RelatedResults

        result = result.as(Kagi::Object::Result)

        result.published.should be_a(Time) if result.published
      end
    end

    it "returns metadata" do
      Kagi::Enrich.web("microsoft")

      Kagi::Request.metadata.should eq(
        Kagi::Request::Metadata.new("db862c5b-c594-4480-9e0c-86a14f71cf0e", "us-east4", 386)
      )
    end
  end
end
