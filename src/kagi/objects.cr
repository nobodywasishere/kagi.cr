#
# Wrappers for objects returned by the API
#
module Kagi::Object
  #
  # A single search result returned by a request
  #
  # <https://help.kagi.com/kagi/api/search.html#search-result>
  #
  class Result
    include JSON::Serializable

    @[JSON::Field(key: "t")]
    # Type of result object, always "0" for `Result`
    getter type : Int32

    # Search result rank, starting from 0
    getter rank : Int32

    # Full URL of website
    getter url : String

    # Website title
    getter title : String

    # (If available) HTML snippet from website
    getter snippet : String?

    # @[JSON::Field(key: "published", converter: Time::EpochConverter)]
    # (If available) When the result was publshed
    getter published : Time?

    # (If available) Thumbnail associated with the result
    getter thumbnail : Image?
  end

  #
  # An image associated with a search result.
  # The URLs are proxied through Kagi's servers, and provide
  # a path from `https://kagi.com` to the image. This proxied URL is provided
  # at `#proxy_url` here, and a full URL is returned by `#url`
  #
  # <https://help.kagi.com/kagi/api/search.html#image>
  #
  # <https://help.kagi.com/kagi/api/intro/image-proxy-urls.html>
  #
  class Image
    include JSON::Serializable

    @[JSON::Field(key: "url")]
    # The path of the proxied image, `/proxy/filename.jpg?c=HASH`
    getter proxy_url : String

    # @[JSON::Field(key: "height", converter: Int32)]
    # Height of the image in pixels
    getter height : String

    # @[JSON::Field(key: "width", converter: Int32)]
    # Width of the image in pixels
    getter width : String

    # The full url of the proxied image, `https://kagi.com/proxy/filename.jpg?c=HASH`
    def url : String
      URI.new("https", "kagi.com", proxy_url).to_s
    end
  end

  #
  # A list of suggestions based on the search request
  #
  # <https://help.kagi.com/kagi/api/search.html#related-searches>
  #
  class RelatedResults
    include JSON::Serializable

    @[JSON::Field(key: "t")]
    # Type of result object, always "1" for `RelatedResults`
    getter type : Int32

    # List of related results to the query performed
    getter list : Array(String)
  end

  #
  # A summarization of the requested text or url
  #
  class Summarization
    include JSON::Serializable

    getter output : String
    getter tokens : Int32
  end

  class Answer
    include JSON::Serializable

    # HTML formatted
    getter output : String
    getter references : Array(Reference)
    getter tokens : Int32
  end

  class Reference
    include JSON::Serializable

    getter title : String
    getter snippet : String
    getter url : String
  end
end
