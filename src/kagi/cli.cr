require "../kagi"

#
# Defines a command-line interface for interacting with the Kagi APIs
#
# ```
# $ ./bin/kagi
#
# Usage: kagi [subcommand] [argument]
#
#     kagi search [query]              -   Search Kagi
#     kagi enrich [news|web] [query]   -   Search Enrichment APIs
#     kagi fast-gpt [query]            -   Ask FastGPT
#     kagi summarize [url]             -   Summarize a URL
#
# ```
#
#
class Kagi::CLI
  #
  # Parse ARGV and execute the corresponding method
  #
  def execute
    print_help if ARGV.size < 2

    cmd, *args = ARGV

    case cmd
    when "search"
      search(args.join(" "))
    when "enrich"
      print_help if ARGV.size < 3
      enrich(args.first, args[1..].join(" "))
    when "fast-gpt"
      fast_gpt(args.join(" "))
    when "summarize"
      summarize(args.first)
    else
      puts "Error: Unknown command #{cmd}"
      print_help
    end
  end

  #
  # Search for `query` via the search API and print the results
  #
  def search(query : String)
    results = Kagi::Search.query(query, limit: 10)

    if results.empty?
      puts "No results"
      exit 1
    end

    results[..-1].each do |result|
      result = result.as(Kagi::Object::Result)

      puts <<-RESULT
      #{result.rank.to_s.rjust(2)}: #{result.title}
          #{result.url}


      RESULT
    end
  end

  #
  # Search for `query` via the enrich API (depending on the cmd) and print the results
  #
  def enrich(cmd : String, query : String)
    results = case cmd
              when "web"
                Kagi::Enrich.web(query)
              when "news"
                Kagi::Enrich.news(query)
              else
                print_help
              end

    if results.empty?
      puts "No results"
      exit 1
    end

    results[...10].each do |result|
      result = result.as(Kagi::Object::Result)

      puts <<-RESULT
      #{result.rank.to_s.rjust(2)}: #{result.title}
          #{result.url}


      RESULT
    end
  end

  #
  # Prints the response of FastGPT for a given query
  #
  def fast_gpt(query : String)
    answer = Kagi::FastGPT.query(query)
    puts <<-OUTPUT
    FastGPT:
        #{answer.output.gsub(/\n/, "\n    ")}

    References:
        #{answer.references.map { |r| "#{r.title.inspect} - #{r.url}" }.join("\n    ")}


    OUTPUT
  end

  #
  # Prints a summary of the given url
  #
  def summarize(url : String)
    summary = Kagi::Summarize.url(url)
    puts <<-SUMMARY
    Summary:
        #{summary.output.gsub(/\n/, "\n    ")}

    SUMMARY
  end

  private def print_help
    puts <<-USAGE
    Usage: kagi [subcommand] [argument]

        kagi search [query]              -   Search Kagi
        kagi enrich [news|web] [query]   -   Search Enrichment APIs
        kagi fast-gpt [query]            -   Ask FastGPT
        kagi summarize [url]             -   Summarize a URL

    USAGE
    exit 1
  end
end

cli = Kagi::CLI.new
cli.execute
