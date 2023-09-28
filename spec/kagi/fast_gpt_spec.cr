require "../spec_helper"

describe Kagi::FastGPT do
  context ".query" do
    it "builds an answer from a query" do
      #
      # Example borrowed from Kagi docs
      # https://help.kagi.com/kagi/api/fastgpt.html#examples
      #
      body = File.read("#{__DIR__}/fast_gpt.json")
      params = {"query" => "python 3.11"}.to_json

      WebMock.stub(:post, "https://kagi.com/api/v0/fastgpt")
        .with(body: params)
        .to_return(body: body, status: 200)

      response = Kagi::FastGPT.query("python 3.11")

      response.should be_a(Kagi::Object::Answer)
      response.output.should eq("Python 3.11 was released in 2021 and introduced several new features compared to previous versions:")
    end
  end
end
