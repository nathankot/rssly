require 'rssly/version'
require 'rssly/article'
require 'rssly/feed'
require 'rssly/deserializers'
require 'rssly/serializers'
require 'rssly/http_error'
require 'rssly/collection'
require 'rssly/collection/unique_filter'
require 'rssly/collection/age_filter'

# Rssly namespace
module Rssly
  CONFIG = {
    summary_ratio: 35,
    discover_feeds: true,
    verbose: false
  }
end
