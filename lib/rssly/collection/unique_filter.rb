require 'bloomfilter-rb'

module Rssly
  class Collection
    # Filters out any articles that have the same url in the set.
    module UniqueFilter
      def self.parse(articles, **args)
        bf = BloomFilter::Redis.new(
          size: 10000
        )

        articles.select do |article|
          unless bf.include?(article.url)
            bf.insert article.url
            true
          end
        end
      end
    end
  end
end
