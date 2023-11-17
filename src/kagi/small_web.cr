module Kagi::SmallWeb
  Log = Kagi::Log.for(self)

  def self.feed
    # Using HTTP::Client directly as this isn't a JSON api and has a different API version
    response = HTTP::Client.get("https://kagi.com/api/v1/smallweb/feed/")

    Feed.from_xml xml: response.body
  end

  class Feed
    include XMLT::Serializable

    getter title : String

    @[XMLT::Field(key: "id")]
    getter url : String

    # getter updated : Time

    getter generator : String

    # # @[XMLT::Field(omit_nil: true)]
    @[XMLT::Field(key: "entry")]
    getter item : String
  end

  # class Item
  #   include XMLT::Serializable

  #   getter title : String

  #   @[XMLT::Field(key: "id")]
  #   getter url : String

  #   # getter updated : Time

  #   # getter published : Time

  #   @[XMLT::Field(omit_nil: true)]
  #   getter? authors : Array(Author)?

  #   getter content : String
  # end

  # record Author, name : String do
  #   include XMLT::Serializable
  # end
end
