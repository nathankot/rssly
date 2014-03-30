module Rssly
  # Represents a single rss feed and it's metadata
  class Feed
    class << self
    end

    attr_accessor :feed_url
    attr_accessor :title
    attr_accessor :articles

    def initialize(title: nil, feed_url: nil)
      self.feed_url = feed_url
    end

    def fetch_articles
      result = Feedjira::Feed.fetch_and_parse @feed_url
      self.title = result.title
      self.articles = result.entries.map do |obj|
        Article.create_from_feedjira_entry(obj)
      end
    end
  end
end
