require 'addressable'
require 'readability'
require 'open-uri'
require 'sanitize'
require 'ots'

module Rssly
  # Represents a single rss article
  class Article
    class << self
      def create_from_feedjira_entry(entry)
        new(title: entry.title, url: entry.url, published: entry.published)
      end
    end

    SUMMARY_RATIO = 35

    attr_accessor :title
    attr_accessor :url
    attr_accessor :summary
    attr_accessor :topics
    attr_accessor :published

    def initialize(
      title: nil,
      url: nil,
      published: nil,
      summary: nil,
      topics: nil
    )
      self.title = title
      self.url = url
      self.published = published
      self.summary = summary
      self.topics = topics
    end

    def title
      @title ||= extracted.title
    end

    def summary
      @summary ||= summarized.summarize(
        percent: SUMMARY_RATIO
      ).reduce('') do |text, o|
        text << o[:sentence].strip + ' '
      end.strip
    end

    def topics
      @topics ||= summarized.topics
    end

    def url=(url)
      normalized = Addressable::URI.parse(url).normalize
      @url = normalized.scheme + '://' + normalized.host + normalized.path
    end

    def published
      @published ||= Time.now
    end

    private

    def summarized
      @summarized ||= begin
                        text = Sanitize.clean(extracted.content)
                        OTS.parse(text)
                      end
    end

    def extracted
      @extracted ||= begin
                       source = open(url).read
                       Readability::Document.new(source)
                     end
    end
  end
end
