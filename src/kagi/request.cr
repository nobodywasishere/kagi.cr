#
# `HTTP::Client` wrapper methods for interacting with the Kagi API
#
module Kagi::Request
  Log = Kagi::Log.for(self)

  struct Metadata
    include JSON::Serializable

    getter id : String
    getter node : String
    getter ms : Int32

    def initialize(@id, @node, @ms)
    end
  end

  struct Error
    include JSON::Serializable

    getter code : Int32
    getter msg : String
    getter ref : String?
    getter api_balance : Float32?

    def initialize(@code, @msg, @ref, @api_balance)
    end
  end

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
  # Set the API key to use when interacting with the Kagi API.
  # Defaults to the environment variable `KAGI_API_KEY`
  #
  def self.api_key=(key : String)
    @@api_key = key
  end

  def self.metadata : Metadata?
    @@metadata
  end

  #
  # Perform a get request to a given path with params, attaching the API key set via `KAGI_API_KEY`.
  # Raises an exception if the request was unsuccessful.
  #
  def self.get(path : String, params : String) : HTTP::Client::Response
    uri = URI.new("https", "kagi.com", path: "/api/#{api_version}#{path}", query: params)
    headers = HTTP::Headers.new
    headers["Authorization"] = "Bot #{@@api_key || ENV["KAGI_API_KEY"]}"

    response = HTTP::Client.get(uri, headers)
    Log.debug { response.body }

    body = JSON.parse(response.body)
    @@metadata = Metadata.from_json(body.as_h["meta"].to_json)

    if response.success?
      @@errors = [] of Error
    else
      Log.error { "Request failed (#{uri}): #{response.body}" }
      @@errors = Array(Error).from_json(body.as_h["error"].to_json)
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
    post_headers["Authorization"] = "Bot #{@@api_key || ENV["KAGI_API_KEY"]}"
    post_headers.merge!(headers) if headers

    response = HTTP::Client.post(uri, body: body, headers: post_headers)
    Log.debug { response.body }

    body = JSON.parse(response.body)
    @@metadata = Metadata.from_json(body.as_h["meta"].to_json)

    if response.success?
      @@errors = [] of Error
    else
      Log.error { "Request failed (#{uri}): #{response.body}" }
      @@errors = Array(Error).from_json(body.as_h["error"].to_json)
    end

    response
  end
end
