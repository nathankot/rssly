require 'addressable/uri'
require 'readability'
require 'open-uri'
require 'open_uri_redirections'
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

    attr_accessor :title
    attr_accessor :url
    attr_accessor :summary
    attr_accessor :topics
    attr_accessor :published

    def initialize(title: nil,
                   url: nil,
                   published: nil,
                   summary: nil,
                   topics: nil)
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
        percent: Rssly::CONFIG[:summary_ratio]
      ).reduce('') do |text, o|
        text << o[:sentence].strip + ' '
      end.strip
    end

    def topics
      @topics ||= summarized.topics
    end

    def url=(url)
      normalized = Addressable::URI.parse(url).normalize
      @url = normalized.to_s
    end

    def published
      @published ||= Time.now
    end

    def to_h
      { title: title,
        url: url,
        summary: summary,
        topics: topics,
        published: published }
    end

    def summarized
      @summarized ||= begin
        $stderr.puts "Summarizing article at #{url}" if Rssly::CONFIG[:verbose]
        text = Sanitize.clean(extracted.content)
        OTS.parse(text)
      end
    end

    def extracted
      @extracted ||= begin
        $stderr.puts "Fetching article at #{url}" if Rssly::CONFIG[:verbose]
        source = open(url, allow_redirections: :safe).read
        Readability::Document.new(source)
      end
    rescue OpenURI::HTTPError
      raise Rssly::HTTPError,
            "Could not retrieve document for article at: #{url}"
    end
  end
end
