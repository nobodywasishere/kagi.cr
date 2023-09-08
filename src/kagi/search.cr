#
# Encapsulates methods for interacting with the `/search` endpoint
#
# <https://help.kagi.com/kagi/api/search.html>
#
module Kagi::Search
  Log = Kagi::Log.for(self)

  #
  # Performs a search and returns the results.
  # Typically, the array returned are all `Kagi::Object::Result`, while
  # the last item is a `Kagi::Object::RelatedResults`
  #
  # <https://help.kagi.com/kagi/api/search.html#get-search>
  #
  def self.query(q : String, limit : Int32 = 10) : Array(Kagi::Object::Result | Kagi::Object::RelatedResults)
    params = URI::Params.encode({"q" => q, "limit" => limit.to_s})
    response = Kagi::Request.get("/search", params)

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
