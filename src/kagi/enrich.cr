#
# Encapsulates methods for interacting with the `/enrich/*` endpoints
#
# <https://help.kagi.com/kagi/api/enrich.html>
#
module Kagi::Enrich
  Log = Kagi::Log.for(self)

  #
  # <https://help.kagi.com/kagi/api/enrich.html#get-enrich-web>
  #
  def self.web(q : String) : Array(Kagi::Object::Result | Kagi::Object::RelatedResults)
    params = URI::Params.encode({"q" => q})
    response = Kagi::Request.get("/enrich/web", params)

    results = [] of Kagi::Object::Result | Kagi::Object::RelatedResults

    JSON.parse(response.body).as_h["data"].as_a.each do |item|
      if item.as_h["t"] == 0
        results << Kagi::Object::Result.from_json(item.to_json)
      elsif item.as_h["t"] == 1
        results << Kagi::Object::RelatedResults.from_json(item.to_json)
      else
        Log.error { "Unknown result type #{item.as_h["t"]}" }
      end
    end

    results
  end

  #
  # <https://help.kagi.com/kagi/api/enrich.html#get-enrich-news>
  #
  def self.news(q : String) : Array(Kagi::Object::Result | Kagi::Object::RelatedResults)
    params = URI::Params.encode({"q" => q})
    response = Kagi::Request.get("/enrich/news", params)

    results = [] of Kagi::Object::Result | Kagi::Object::RelatedResults

    JSON.parse(response.body).as_h["data"].as_a.each do |item|
      if item.as_h["t"] == 0
        results << Kagi::Object::Result.from_json(item.to_json)
      elsif item.as_h["t"] == 1
        results << Kagi::Object::RelatedResults.from_json(item.to_json)
      else
        Log.error { "Unknown result type #{item.as_h["t"]}" }
      end
    end

    results
  end
end
