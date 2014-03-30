require 'rssly'
require 'feedjira'

describe 'Rssly::Article' do

  ARTICLE_TEST_FEED_URL = 'news.ycombinator.com/rss'
  ARTICLE_TEST_URL = \
    'http://blog.ycombinator.com/meet-the-people-taking-over-hacker-news'

  describe 'class' do
    describe '#create_from_feedjira_entry' do
      before do
        @article = Rssly::Article.create_from_feedjira_entry(
          @entry = Feedjira::Feed.fetch_and_parse(ARTICLE_TEST_FEED_URL).entries.first
        )
      end

      it 'should set the title' do
        expect(@article.title).to eq(@entry.title)
      end

      it 'should set the url' do
        expect(@article.url).to eq(@entry.url)
      end
    end
  end

  describe 'instance' do
    before do
      @article = Rssly::Article.new(url: ARTICLE_TEST_URL)
    end

    it 'should fetch the title if not given' do
      expect(@article.title).not_to eq(nil)
    end

    it 'should fetch the summary if not given' do
      expect(@article.summary).not_to eq(nil)
    end
  end
end
