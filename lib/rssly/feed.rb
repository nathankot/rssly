require 'feedjira'
require 'feedbag'
require 'rfeedfinder'

module Rssly
  # Represents a single rss feed and it's metadata
  class Feed
    class << self
    end

    attr_accessor :url
    attr_accessor :articles

    def initialize(url: nil)
      self.url = url
    end

    def articles
      @articles ||= fetch_articles
    end

    private

    def fetch_articles
      urls = gather_feeds
      $stderr.puts "Found feeds #{urls.join(', ')}" if Rssly::CONFIG[:verbose]

      Feedjira::Feed.fetch_and_parse(urls).values.select do |result|
        result.class.name.start_with?('Feedjira::')
      end.reduce([]) do |a, result|
        a + result.entries.map { |o| Article.create_from_feedjira_entry(o) }
      end
    rescue RuntimeError
      raise Rssly::HTTPError, "Could not fetch articles for feed: #{url}"
    end

    def gather_feeds
      $stderr.puts "Gathering feeds for #{url}" if Rssly::CONFIG[:verbose]

      if Rssly::CONFIG[:discover_feeds]
        ([@url] + Feedbag.find(@url) + Rfeedfinder.feeds(@url))
        .flatten.uniq.compact
      else [@url]
      end
    end
  end
end
