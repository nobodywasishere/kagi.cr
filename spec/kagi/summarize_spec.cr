require "../spec_helper"

describe Kagi::Summarize do
  context ".text" do
    it "summarizes text" do
      #
      # Example borrowed from Kagi docs
      # https://help.kagi.com/kagi/api/summarizer.html#examples
      #
      body = File.read("#{__DIR__}/summarize.json")

      WebMock.stub(:post, "https://kagi.com/api/v0/summarize")
        .to_return(body: body, status: 200)

      Kagi::Summarize.text(
        "python 3.11",
        engine: "spec-engine",
        summary_type: "takeaway"
      )
    end
  end

  context ".url" do
    it "summarizes from url" do
      #
      # Example borrowed from Kagi docs
      # https://help.kagi.com/kagi/api/summarizer.html#examples
      #
      body = File.read("#{__DIR__}/summarize.json")

      WebMock.stub(:post, "https://kagi.com/api/v0/summarize")
        .to_return(body: body, status: 200)

      Kagi::Summarize.url("https://my/example/url")
    end
  end
end
