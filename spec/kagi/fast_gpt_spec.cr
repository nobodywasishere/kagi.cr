require "../spec_helper"

describe Kagi::FastGPT do
  context ".query" do
    it "builds an answer from a query" do
      #
      # Example borrowed from Kagi docs
      # https://help.kagi.com/kagi/api/fastgpt.html#examples
      #
      body = File.read("#{__DIR__}/fast_gpt.json")

      params = URI::Params.encode({"q" => "python 3.11"})
      WebMock.stub(:post, "https://kagi.com/api/v0/fastgpt")
        .to_return(body: body, status: 200)

      Kagi::FastGPT.query("python 3.11")
    end
  end
end
