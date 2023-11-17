require "json"
require "xmlt"
require "http/client"
require "http/headers"

module Kagi
  VERSION = "0.1.0"

  Log = ::Log.for("kagi")
end

require "./kagi/request"
require "./kagi/objects"
require "./kagi/search"
require "./kagi/enrich"
require "./kagi/fast_gpt"
require "./kagi/summarize"
require "./kagi/small_web"
