require 'json'

module Rssly
  # Represents a collection of articles
  class Collection
    class << self
      def create_from_feeds(*feeds)
        if Rssly::CONFIG[:verbose]
          $stderr.puts(
            "Creating collection from #{feeds.map(&:url).join(', ')}"
          )
        end

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

    def length
      articles.length
    end

    def articles
      @articles ||= []

      # Remove all the inaccessible ones
      @articles.select! do |a|
        begin
          a.extracted
          true
        rescue RuntimeError
          false
        end
      end

      @articles
    end

    def filter(filter, **opts)
      self.articles = filter.parse(articles, **opts)
    end

    def to_json
      JSON.generate(articles.map { |a| a.to_h })
    end
  end
end
