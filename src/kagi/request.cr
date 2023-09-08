#
# `HTTP::Client` wrapper methods for interacting with the Kagi API
#
module Kagi::Request
  Log = Kagi::Log.for(self)

  #
  # Set the API version to be used for queries
  #
  def self.api_version=(version : String)
    @@api_version = version
  end

  #
  # Gets the current API version, defaulting to "v0"
  #
  def self.api_version : String
    @@api_version || "v0"
  end

  #
  # Perform a get request to a given path with params, attaching the API key set via `KAGI_API_KEY`.
  # Raises an exception if the request was unsuccessful.
  #
  def self.get(path : String, params : String) : HTTP::Client::Response
    uri = URI.new("https", "kagi.com", path: "/api/#{api_version}#{path}", query: params)
    headers = HTTP::Headers.new
    headers["Authorization"] = "Bot #{ENV["KAGI_API_KEY"]}"

    response = HTTP::Client.get(uri, headers)

    unless response.success?
      Log.error { "Request failed (#{uri}): #{response.body}" }
      raise "Request failed"
    end

    response
  end

  #
  # Perform a post request to a given path, body, and optional headers, attaching the API key set via `KAGI_API_KEY`.
  # Raises an exception if the request was unsuccessful.
  #
  def self.post(path : String, body : String, headers : HTTP::Headers? = nil) : HTTP::Client::Response
    uri = URI.new("https", "kagi.com", path: "/api/#{api_version}#{path}")
    post_headers = HTTP::Headers.new
    post_headers["Authorization"] = "Bot #{ENV["KAGI_API_KEY"]}"
    post_headers.merge!(headers) if headers

    response = HTTP::Client.post(uri, body: body, headers: post_headers)

    unless response.success?
      Log.error { "Request failed (#{uri}): #{response.body}" }
      raise "Request failed"
    end

    response
  end
end
