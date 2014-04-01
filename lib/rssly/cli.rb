require 'thor'
require 'rssly'

module Rssly
  # The rssly CLI
  class CLI < Thor
    desc 'fetch URL1 URL2', 'Fetch feeds and output them in a given format.'

    option :format, default: 'text', desc: <<-EOT
      Choose from one of the following serializers:

      `text` : Output articles in a simple text layout.
      `html` : Output articles in an html format.
    EOT

    def fetch(*feed_urls)
      feeds = feed_urls.map do |url|
        Rssly::Feed.new url: url
      end

      collection = Rssly::Collection.create_from_feeds(*feeds)

      serializer = case options[:format]
                   when 'text' then Rssly::Serializers::Text
                   when 'html' then Rssly::Serializers::HTML
                   else fail "Serializer #{options[:format]} not found."
                   end

      puts serializer.new(collection).perform
    end
  end
end
