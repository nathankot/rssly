require 'json'

module Rssly
  # Represents a collection of articles
  class Collection
    class << self
      def create_from_feeds(*feeds)
        instance = new(
          feeds.map { |f| f.articles }.flatten
        )

        instance.filter(UniqueFilter)
        instance
      end
    end

    attr_accessor :articles

    def initialize(items)
      self.articles = items
    end

    def each(&block)
      articles.each(&block)
    end

    def length
      articles.length
    end

    def articles
      @articles ||= []
    end

    def filter(filter, **opts)
      self.articles = filter.parse(articles, **opts)
    end

    def to_json
      JSON.generate(articles.map { |a| a.to_h })
    end
  end
end
