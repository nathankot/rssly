require 'readability'
require 'open-uri'
require 'sanitize'
require 'ots'

module Rssly
  # Represents a single rss article
  class Article
    class << self
      def create_from_feedjira_entry(entry)
        new(title: entry.title, url: entry.url)
      end
    end

    SUMMARY_RATIO = 35

    attr_accessor :title
    attr_accessor :url
    attr_accessor :summary
    attr_accessor :topics

    def initialize(title: nil, url: nil)
      self.title = title
      self.url = url
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
