require 'feedjira'

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
      result = Feedjira::Feed.fetch_and_parse @url
      self.title = result.title
      result.entries.map do |obj|
        Article.create_from_feedjira_entry(obj)
      end
    end
  end
end
