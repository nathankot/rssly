require 'spec_helper'
require 'rssly'
require 'active_support/core_ext'

describe 'Rssly::Collection' do

  COLLECTION_TEST_URL = 'https://news.ycombinator.com/rss'
  COLLECTION_ARTICLE_TEST_URL = \
    'http://blog.ycombinator.com/meet-the-people-taking-over-hacker-news'

  before do
    @feed = Rssly::Feed.new(url: COLLECTION_TEST_URL)
    @feed2 = Rssly::Feed.new(url: COLLECTION_TEST_URL)
  end

  describe 'class' do
    describe '#create_from_feeds' do
      before do
        @feed_count = @feed.articles.length
        @collection = Rssly::Collection.create_from_feeds(
          @feed, @feed2
        )
      end

      it 'filters out duplicate articles' do
        expect(@collection.length).to <= @feed_count
      end
    end
  end

  describe 'instance' do
    before do
      @articles = []
      3.times do
        @articles << Rssly::Article.new(url: COLLECTION_ARTICLE_TEST_URL)
      end

      @collection = Rssly::Collection.new(@articles)
    end

    it 'should respond to #length' do
      expect(@collection.length).to eq(3)
    end

    describe 'filtering' do
      it 'can filter by age' do
        @collection.filter(
          Rssly::Collection::AgeFilter, min: 1.hour.from_now
        )

        expect(@collection.length).to eq(0)

        @collection.filter(
          Rssly::Collection::AgeFilter, max: 1.hour.ago
        )

        expect(@collection.length).to eq(0)
      end
    end
  end
end
