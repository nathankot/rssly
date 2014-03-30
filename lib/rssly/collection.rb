module Rssly
  # Represents a collection of articles
  class Collection
    class << self
    end

    attr_reader :articles

    def each(&block)
      articles.each(&block)
    end

    def articles
      @articles ||= []
    end
  end
end
