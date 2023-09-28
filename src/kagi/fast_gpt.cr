#
# Encapsulates methods for interacting with the `/fastgpt` endpoint
#
# <https://help.kagi.com/kagi/api/fastgpt.html>
#
module Kagi::FastGPT
  Log = Kagi::Log.for(self)

  #
  # Sends a query to FastGPT and returns am `Kagi::Object::Answer`, markdown formatted
  #
  # <https://help.kagi.com/kagi/api/fastgpt.html#post-fastgpt>
  #
  def self.query(query : String, cache : Bool? = nil) : Kagi::Object::Answer
    params_hash = {"query" => query}
    params_hash["cache"] = cache.to_s unless cache.nil?
    headers = HTTP::Headers.new
    headers["Content-Type"] = "application/json"

    params = params_hash.to_json
    response = Kagi::Request.post("/fastgpt", params, headers: headers)

    Kagi::Object::Answer.from_json(JSON.parse(response.body).as_h["data"].to_json)
  end
end
