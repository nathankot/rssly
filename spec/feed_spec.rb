require 'rssly'

describe 'Rssly::Feed' do

  FEED_TEST_URL = 'news.ycombinator.com/rss'

  before do
    @feed = Rssly::Feed.new(url: FEED_TEST_URL)
  end

  it 'should set the @url' do
    expect(@feed.url).to eq(FEED_TEST_URL)
  end

  describe '#fetch_articles' do
    before do
      allow(Rssly::Article).to receive(:create_from_feedjira_entry) do |entry|
        entry
      end
    end

    it 'should call Article#create_from_feedjira_entry' do
      expect(Rssly::Article).to receive(:create_from_feedjira_entry)
      @feed.fetch_articles
    end

    it 'should set @articles' do
      @feed.fetch_articles
      expect(@feed.articles.length).to be > 0
    end

    it 'articles should have titles' do
      @feed.fetch_articles
      expect(@feed.articles.first.title).to_not eq(nil)
    end
  end

end
