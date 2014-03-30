require 'spec_helper'
require 'rssly'
require 'feedjira'
require 'addressable/uri'

describe 'Rssly::Article' do

  ARTICLE_TEST_FEED_URL = 'news.ycombinator.com/rss'
  ARTICLE_TEST_URL = \
    'http://blog.ycombinator.com/meet-the-people-taking-over-hacker-news'

  describe 'class' do
    describe '#create_from_feedjira_entry' do
      before do
        @entry = Feedjira::Feed.fetch_and_parse(ARTICLE_TEST_FEED_URL).entries.first
        allow(@entry).to receive(:published).and_return(Time.now)
        @article = Rssly::Article.create_from_feedjira_entry @entry
      end

      it 'should set the title' do
        expect(@article.title).to eq(@entry.title)
      end

      it 'should set the url' do
        expect(@article.url).to eq(@entry.url)
      end

      it 'should set the publish date' do
        expect(@article.published).to eq(@entry.published)
      end
    end
  end

  describe 'instance' do
    before do
      @article = Rssly::Article.new(url: ARTICLE_TEST_URL)
    end

    it 'should standardize the url' do
      article = Rssly::Article.new url: 'http://notstandard.com/123123/?test=hello/'
      expect(article.url).to eq('http://notstandard.com/123123/')
    end

    it 'should standardize a file url' do
      article = Rssly::Article.new url: 'http://notstandard.com/123123.html?hello'
      expect(article.url).to eq('http://notstandard.com/123123.html')
    end

    it 'should fetch the title if not given' do
      expect(@article.title).not_to eq(nil)
    end

    it 'should fetch the summary if not given' do
      expect(@article.summary).not_to eq(nil)
    end

    it 'should always have a published date' do
      expect(@article.published).not_to eq(nil)
    end
  end
end
