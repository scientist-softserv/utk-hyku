module Stanford
  module Importer
    class PurlRetriever
      def self.get(druid)
        new(druid).get
      end

      def initialize(druid)
        @druid = druid
      end

      def get
        conn.get("/#{@druid}.xml").body
      end

      def conn
        @conn ||= Faraday.new(url: 'https://purl.stanford.edu')
      end
    end
  end
end
