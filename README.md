# kagi

Crystal shard for interacting with the [Kagi REST API](https://help.kagi.com/kagi/api/overview.html).

Supports the following APIs:
- [Kagi Search API](https://help.kagi.com/kagi/api/search.html) via `Kagi::Search`
- [Enrichment API](https://help.kagi.com/kagi/api/enrich.html) via `Kagi::Enrich`
- [Universal Summarizer API](https://help.kagi.com/kagi/api/summarizer.html) via `Kagi::Summarize`
- [FastGPT API](https://help.kagi.com/kagi/api/fastgpt.html) via `Kagi::FastGPT`

## Installation

1. Add the dependency to your `shard.yml`:

   ```yml
   dependencies:
     kagi:
       github: nobodywasishere/kagi.cr
   ```

2. Run `shards install`

3. Get a Kagi API key from [here](https://help.kagi.com/kagi/api/intro/auth.html)

4. Set the environment variable `KAGI_API_KEY` with your API key

## Usage

### Library

```crystal
require "kagi"

results = Kagi::Enrich.web("steve jobs")

results # => # Array of `Kagi::Object::Result | Kagi::Object::RelatedResults`

results.each do |result|
  next if result.is_a? Kagi::Object::RelatedResults

  result = result.as(Kagi::Object::Result)

  puts <<-RESULT
  #{result.rank}: #{result.title}
      #{result.url}


  RESULT
end
```

### CLI

```sh
$ ./bin/kagi

Usage: kagi [subcommand] [argument]

    kagi search [query]              -   Search Kagi
    kagi enrich [news|web] [query]   -   Search Enrichment APIs
    kagi fast-gpt [query]            -   Ask FastGPT
    kagi summarize [url]             -   Summarize a URL

```

```sh
$ ./bin/kagi enrich web steve jobs

 1: Dennis Forbes on Software and Technology  - Steve Jobs Just Murdered the Web
    https://web.archive.org/web/20100414005022/http://www.yafla.com/dforbes/Steve_Jobs_Just_Murdered_the_Web/

 2: World Wild Web: Steve Jobs Stanford Commencement Speech 2005
    http://satyajeetsingh.blogspot.com/2007/10/steve-jobs-stanford-commencement-speech.html

 3: 15 Great Google Web Fonts Demonstrated By The Best Steve Jobs Quotes
    https://www.shareaholic.com/blog/google-web-fonts/

 4: Steve Jobs | I, Cringely
    http://www.cringely.com/2011/10/steve-jobs-is-dead/

 5: Why web developers have more to learn from Wall Street than Steve Jobs
    https://scoutapm.com/blog/why-web-developers-have-more-learn-to-from-wall-street-than-steve-jobs

 6: Steve Jobs: 1955-2011 - Marco.org
    https://marco.org/2011/10/05/steve-jobs-dies

 7: Steve Jobs - Wikipedia
    https://en.wikipedia.org/wiki/Steve_Jobs

 8: Steve Paul Jobs
    https://ei.cs.vt.edu/~history/Jobs.html

 9: Steve Jobs: The Next Insanely Great Thing ��� (The Web) | The Web Ahead
    http://thewebahead.net/linkblog/2014/09/steve-jobs-the-next-insanely-great-thing-the-web

10: Steve Jobs – De Programmatica Ipsum
    https://deprogrammaticaipsum.com/steve-jobs/

```

## Development

Improvements:
- [ ] Better CLI interface / use a CLI library
- [ ] Capture metadata from requests (potentially map latest metadata to `Kagi::Request.meta`)
- [ ] Render and/or strip HTML from `Kagi::FastGPT.query` output

## Contributing

1. Fork it (<https://github.com/nobodywasishere/kagi.cr/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Margret Riegert](https://github.com/nobodywasishere) - creator and maintainer
