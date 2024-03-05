# frozen_string_literal: true

RSpec.describe UriToStringBehavior do
  subject { AppIndexer.new(work) }

  let(:work) { double('work') }
  let(:graph) { RDF::Graph.new }
  let(:uri) { 'http://id.loc.gov/vocabulary/iso639-2/eng' }
  let(:rdf_data) do
    <<~RDF
      <http://id.loc.gov/vocabulary/iso639-2/eng> <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://www.loc.gov/mads/rdf/v1#Language> .
      <http://id.loc.gov/vocabulary/iso639-2/eng> <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <//www.loc.gov/mads/rdf/v1#Authority> .
      <http://id.loc.gov/vocabulary/iso639-2/eng> <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://id.loc.gov/vocabulary/iso639-2/iso639-2_Language> .
      <http://id.loc.gov/vocabulary/iso639-2/eng> <http://www.loc.gov/mads/rdf/v1#authoritativeLabel> "English"@en .
      <http://id.loc.gov/vocabulary/iso639-2/eng> <http://www.loc.gov/mads/rdf/v1#authoritativeLabel> "anglais"@fr .
      <http://id.loc.gov/vocabulary/iso639-2/eng> <http://www.loc.gov/mads/rdf/v1#authoritativeLabel> "Englisch"@de .
      <http://id.loc.gov/vocabulary/iso639-2/eng> <http://www.loc.gov/mads/rdf/v1#hasVariant> _:b13iddOtlocdOtgovvocabularyiso639-2eng .
      _:b13iddOtlocdOtgovvocabularyiso639-2eng <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://www.loc.gov/mads/rdf/v1#Language> .
      _:b13iddOtlocdOtgovvocabularyiso639-2eng <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <//www.loc.gov/mads/rdf/v1#Variant> .
      _:b13iddOtlocdOtgovvocabularyiso639-2eng <http://www.loc.gov/mads/rdf/v1#variantLabel> "English"@en .
      <http://id.loc.gov/vocabulary/iso639-2/eng> <http://www.loc.gov/mads/rdf/v1#hasVariant> _:b23iddOtlocdOtgovvocabularyiso639-2eng .
      _:b23iddOtlocdOtgovvocabularyiso639-2eng <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://www.loc.gov/mads/rdf/v1#Language> .
      _:b23iddOtlocdOtgovvocabularyiso639-2eng <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <//www.loc.gov/mads/rdf/v1#Variant> .
      _:b23iddOtlocdOtgovvocabularyiso639-2eng <http://www.loc.gov/mads/rdf/v1#variantLabel> "anglais"@fr .
      <http://id.loc.gov/vocabulary/iso639-2/eng> <http://www.loc.gov/mads/rdf/v1#hasVariant> _:b33iddOtlocdOtgovvocabularyiso639-2eng .
      _:b33iddOtlocdOtgovvocabularyiso639-2eng <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://www.loc.gov/mads/rdf/v1#Language> .
      _:b33iddOtlocdOtgovvocabularyiso639-2eng <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <//www.loc.gov/mads/rdf/v1#Variant> .
      _:b33iddOtlocdOtgovvocabularyiso639-2eng <http://www.loc.gov/mads/rdf/v1#variantLabel> "Englisch"@de .
      <http://id.loc.gov/vocabulary/iso639-2/eng> <http://www.loc.gov/mads/rdf/v1#isMemberOfMADSCollection> <http://id.loc.gov/vocabulary/iso639-2/collection_iso639-2_Bibliographic_Codes> .
      <http://id.loc.gov/vocabulary/iso639-2/eng> <http://www.loc.gov/mads/rdf/v1#isMemberOfMADSCollection> <http://id.loc.gov/vocabulary/iso639-2/collection_PastPresentISO639-2Entries> .
      <http://id.loc.gov/vocabulary/iso639-2/eng> <http://www.loc.gov/mads/rdf/v1#isMemberOfMADSCollection> <http://id.loc.gov/vocabulary/iso639-2/collection_iso639-2> .
      <http://id.loc.gov/vocabulary/iso639-2/eng> <http://www.loc.gov/mads/rdf/v1#hasExactExternalAuthority> <http://id.loc.gov/vocabulary/languages/eng> .
      <http://id.loc.gov/vocabulary/iso639-2/eng> <http://www.loc.gov/mads/rdf/v1#hasExactExternalAuthority> <http://id.loc.gov/vocabulary/iso639-1/en> .
      <http://id.loc.gov/vocabulary/iso639-2/eng> <http://www.loc.gov/mads/rdf/v1#isMemberOfMADSScheme> <http://id.loc.gov/vocabulary/iso639-2> .
      <http://id.loc.gov/vocabulary/iso639-2/eng> <http://www.loc.gov/mads/rdf/v1#note> "Bibliographic Code"@en .
      <http://id.loc.gov/vocabulary/iso639-2/eng> <http://www.loc.gov/mads/rdf/v1#code> "eng"^^<http://www.w3.org/2001/XMLSchema#string> .
      <http://id.loc.gov/vocabulary/iso639-2/eng> <http://www.loc.gov/mads/rdf/v1#adminMetadata> _:b53iddOtlocdOtgovvocabularyiso639-2eng .
      _:b53iddOtlocdOtgovvocabularyiso639-2eng <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://id.loc.gov/ontologies/RecordInfo#RecordInfo> .
      _:b53iddOtlocdOtgovvocabularyiso639-2eng <http://id.loc.gov/ontologies/RecordInfo#recordChangeDate> "1970-01-01T00:00:00"^^<http://www.w3.org/2001/XMLSchema#dateTime> .
      _:b53iddOtlocdOtgovvocabularyiso639-2eng <http://id.loc.gov/ontologies/RecordInfo#recordStatus> "new"^^<http://www.w3.org/2001/XMLSchema#string> .
      _:b53iddOtlocdOtgovvocabularyiso639-2eng <http://id.loc.gov/ontologies/RecordInfo#recordContentSource> <http://id.loc.gov/vocabulary/organizations/dlc> .
      <http://id.loc.gov/vocabulary/iso639-2/eng> <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://www.w3.org/2004/02/skos/core#Concept> .
      <http://id.loc.gov/vocabulary/iso639-2/eng> <http://www.w3.org/2004/02/skos/core#prefLabel> "English"@en .
      <http://id.loc.gov/vocabulary/iso639-2/eng> <http://www.w3.org/2004/02/skos/core#prefLabel> "anglais"@fr .
      <http://id.loc.gov/vocabulary/iso639-2/eng> <http://www.w3.org/2004/02/skos/core#prefLabel> "Englisch"@de .
      <http://id.loc.gov/vocabulary/iso639-2/eng> <http://www.w3.org/2008/05/skos-xl#altLabel> _:b72iddOtlocdOtgovvocabularyiso639-2eng .
      _:b72iddOtlocdOtgovvocabularyiso639-2eng <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://www.w3.org/2008/05/skos-xl#Label> .
      _:b72iddOtlocdOtgovvocabularyiso639-2eng <http://www.w3.org/2008/05/skos-xl#literalForm> "English"@en .
      <http://id.loc.gov/vocabulary/iso639-2/eng> <http://www.w3.org/2008/05/skos-xl#altLabel> _:b77iddOtlocdOtgovvocabularyiso639-2eng .
      _:b77iddOtlocdOtgovvocabularyiso639-2eng <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://www.w3.org/2008/05/skos-xl#Label> .
      _:b77iddOtlocdOtgovvocabularyiso639-2eng <http://www.w3.org/2008/05/skos-xl#literalForm> "anglais"@fr .
      <http://id.loc.gov/vocabulary/iso639-2/eng> <http://www.w3.org/2008/05/skos-xl#altLabel> _:b82iddOtlocdOtgovvocabularyiso639-2eng .
      _:b82iddOtlocdOtgovvocabularyiso639-2eng <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://www.w3.org/2008/05/skos-xl#Label> .
      _:b82iddOtlocdOtgovvocabularyiso639-2eng <http://www.w3.org/2008/05/skos-xl#literalForm> "Englisch"@de .
      <http://id.loc.gov/vocabulary/iso639-2/eng> <http://www.w3.org/2004/02/skos/core#exactMatch> <http://id.loc.gov/vocabulary/languages/eng> .
      <http://id.loc.gov/vocabulary/iso639-2/eng> <http://www.w3.org/2004/02/skos/core#exactMatch> <http://id.loc.gov/vocabulary/iso639-1/en> .
      <http://id.loc.gov/vocabulary/iso639-2/eng> <http://www.w3.org/2004/02/skos/core#note> "Bibliographic Code"@en .
      <http://id.loc.gov/vocabulary/iso639-2/eng> <http://www.w3.org/2004/02/skos/core#notation> "eng"^^<http://www.w3.org/2001/XMLSchema#string> .
      <http://id.loc.gov/vocabulary/iso639-2/eng> <http://www.w3.org/2004/02/skos/core#inScheme> <http://id.loc.gov/vocabulary/iso639-2> .
      <http://id.loc.gov/vocabulary/iso639-2/eng> <http://www.w3.org/2004/02/skos/core#altLabel> "English"@en .
      <http://id.loc.gov/vocabulary/iso639-2/eng> <http://www.w3.org/2004/02/skos/core#altLabel> "anglais"@fr .
      <http://id.loc.gov/vocabulary/iso639-2/eng> <http://www.w3.org/2004/02/skos/core#altLabel> "Englisch"@de .
      <http://id.loc.gov/vocabulary/iso639-2/eng> <http://www.w3.org/2004/02/skos/core#changeNote> _:b100iddOtlocdOtgovvocabularyiso639-2eng .
      _:b100iddOtlocdOtgovvocabularyiso639-2eng <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://purl.org/vocab/changeset/schema#ChangeSet> .
      _:b100iddOtlocdOtgovvocabularyiso639-2eng <http://purl.org/vocab/changeset/schema#subjectOfChange> <http://id.loc.gov/vocabulary/iso639-2/eng> .
      _:b100iddOtlocdOtgovvocabularyiso639-2eng <http://purl.org/vocab/changeset/schema#creatorName> <http://id.loc.gov/vocabulary/organizations/dlc> .
      _:b100iddOtlocdOtgovvocabularyiso639-2eng <http://purl.org/vocab/changeset/schema#createdDate> "1970-01-01T00:00:00"^^<http://www.w3.org/2001/XMLSchema#dateTime> .
      _:b100iddOtlocdOtgovvocabularyiso639-2eng <http://purl.org/vocab/changeset/schema#changeReason> "new"^^<http://www.w3.org/2001/XMLSchema#string> .
    RDF
  end

  describe '#uri_to_value_for' do
    context 'when the URI is an RDF resource' do
      before do
        RDF::Reader.for(:ntriples).new(rdf_data) do |reader|
          reader.each_statement { |statement| graph << statement }
        end
      end

      it 'retrieves a value for a given URI' do
        allow(RDF::Graph).to receive(:load).with(uri).and_return(graph)

        expect(subject.uri_to_value_for(uri)).to eq 'English'
      end
    end

    context 'when the URI is just a string' do
      it 'returns the value' do
        expect(subject.uri_to_value_for('Doe, John')).to eq 'Doe, John'
      end
    end

    context 'when the URI is not an RDF resource' do
      before do
        allow(RDF::Graph).to receive(:load).with(uri).and_raise(StandardError, 'Test error')
      end

      it 'returns the URI and a message' do
        expect(Rails.logger).to receive(:error).with('Failed to load RDF data: Test error')
        expect(subject.uri_to_value_for(uri))
          .to eq 'http://id.loc.gov/vocabulary/iso639-2/eng (Failed to load URI)'
      end
    end

    context 'when the URI does not have a label', skip: 'currently failing in CI but not locally' do
      before do
        stub_request(:get, "http://example.com/")
          .with(
            # rubocop:disable Metrics/LineLength
            headers: {
              'Accept' => 'text/turtle, text/rdf+turtle, application/turtle;q=0.2, application/x-turtle;q=0.2, application/ld+json, application/x-ld+json, application/n-triples, text/plain;q=0.2, application/rdf+xml, application/n-quads, text/x-nquads;q=0.2, */*;q=0.1',
              'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'User-Agent' => 'Ruby RDF.rb/3.1.15'
            }
            # rubocop:enable Matrics/LineLength
          )
          .to_return(status: 200, body: "", headers: {})
      end
      it 'returns the URI and a message' do
        expect(subject.uri_to_value_for('http://example.com')).to eq 'http://example.com (No label found)'
      end
    end
  end
end
