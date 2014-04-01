module Rssly
  module Serializers
    # The base serializer class
    class Serializer
      def initialize(collection)
        @collection = collection
      end

      def perform
        fail 'Serializer#perform must be implemented'
      end
    end

    # Transforms a collection into a text representation
    class Text < Serializer
      ARTICLE_TEMPLATE = <<-EOT
      ====== %{title} ======
      Seen @ %{published}

      %{summary}

      Read on: %{url}

      --

      EOT

      def perform
        @collection.reduce('') do |response, article|
          response + ARTICLE_TEMPLATE % {
            title: article.title,
            summary: article.summary,
            published: article.published,
            url: article.url
          }
        end
      end
    end

    # Transforms a collection into a html representation
    class HTML < Text
      ARTICLE_TEMPLATE = <<-EOT
      <article>
        <h1 class="title">%{title}</h1>
        <date>%{published}</date>

        <p>%{summary}</p>

        <a class="read more" href="%{url}">
          Read on.
        </a>
      </article>
      EOT
    end
  end
end
