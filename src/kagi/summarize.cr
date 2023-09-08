#
# Encapsulates methods for interacting with the `/summarize` endpoint
#
# <https://help.kagi.com/kagi/api/summarizer.html>
#
module Kagi::Summarize
  Log = Kagi::Log.for(self)

  #
  # Summarizes a given string. For a list of supported engines, summary types, and target languages, see
  # <https://help.kagi.com/kagi/api/summarizer.html#options>
  #
  # <https://help.kagi.com/kagi/api/summarizer.html#get-post-summarize>
  #
  def self.text(string : String, engine : String? = nil, summary_type : String? = nil, target_lang : String? = nil, cache : Bool? = nil) : Kagi::Object::Summarization
    params_hash = {"text" => string}
    params_hash["engine"] = engine if engine
    params_hash["summary_type"] = summary_type if summary_type
    params_hash["target_language"] = target_lang if target_lang
    params_hash["cache"] = cache.to_s unless cache.nil?

    params = URI::Params.encode(params_hash)
    response = Kagi::Request.post("/summarize", params.to_s)

    Kagi::Object::Summarization.from_json(JSON.parse(response.body).as_h["data"].to_json)
  end

  #
  # Summarizes a given URL that points to content. For a list of supported engines, summary types,
  # and target languages, see <https://help.kagi.com/kagi/api/summarizer.html#options>
  #
  # <https://help.kagi.com/kagi/api/summarizer.html#get-post-summarize>
  #
  def self.url(link : String, engine : String? = nil, summary_type : String? = nil, target_lang : String? = nil, cache : Bool? = nil) : Kagi::Object::Summarization
    params_hash = {"url" => link}
    params_hash["engine"] = engine if engine
    params_hash["summary_type"] = summary_type if summary_type
    params_hash["target_language"] = target_lang if target_lang
    params_hash["cache"] = cache.to_s unless cache.nil?

    params = URI::Params.encode(params_hash)
    response = Kagi::Request.post("/summarize", params.to_s)

    Kagi::Object::Summarization.from_json(JSON.parse(response.body).as_h["data"].to_json)
  end
end
