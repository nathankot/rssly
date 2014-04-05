require 'feedjira'
require 'feedbag'

module Rssly
  # Represents a single rss feed and it's metadata
  class Feed
    class << self
    end

    attr_accessor :url
    attr_accessor :title
    attr_accessor :articles

    def initialize(title: nil, url: nil)
      self.url = url
      self.title = title
    end

    def articles
      @articles ||= fetch_articles
    end

    private

    def fetch_articles
      urls = [@url]
      urls = Feedbag.find(@url) if Rssly::CONFIG[:discover_feeds]
      result = Feedjira::Feed.fetch_and_parse(*urls)
      self.title = result.title
      result.entries.map do |obj|
        Article.create_from_feedjira_entry(obj)
      end
    rescue RuntimeError
      raise Rssly::HTTPError,
            "Could not fetch articles for feed: #{url}"
    end
  end
end
