module Rssly
  class Collection
    # Filters articles out by age
    module AgeFilter
      def self.parse(articles, min: nil, max: nil)
        articles.select do |article|
          if min && article.published < min then false
          elsif max && article.published > max then false
          else true
          end
        end
      end
    end
  end
end
