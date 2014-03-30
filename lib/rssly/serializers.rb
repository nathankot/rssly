module Rssly
  module Serializers
    class Serializer
      def initialize(collection)
        @collection = collection
      end

      def perform
        fail 'Serializer#perform must be implemented'
      end
    end

    class HTML < Serializer
    end
  end
end
