# frozen_string_literal: true

RSpec.describe UriToStringBehavior do
  subject { AppIndexer.new(work) }

  let(:work) { double('work') }
  let(:graph) { RDF::Graph.new }
  let(:uri) { 'http://id.loc.gov/authorities/names/n2017180154' }
  let(:rdf_data) do
    <<~RDF
      _:b37iddOtlocdOtgovauthoritiesnamesn2017180154 <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://www.loc.gov/mads/rdf/v1#NameElement> .
      _:b37iddOtlocdOtgovauthoritiesnamesn2017180154 <http://www.loc.gov/mads/rdf/v1#elementValue> \"University of Tennessee (Memphis campus)\" .
      _:b111iddOtlocdOtgovauthoritiesnamesn2017180154 <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://www.loc.gov/mads/rdf/v1#Source> .
      _:b111iddOtlocdOtgovauthoritiesnamesn2017180154 <http://www.loc.gov/mads/rdf/v1#citationNote> \"(system created: 1968; Offices of the university system administration are located on the Knoxville campus. The University system has three parts: 1.  University of Tennessee including the flagship campus at Knoxville, the Health Science Center at Memphis, Institute for Public Service, Institute of Agriculture, and Space Institute at Tullahoma; 2. University of Tennessee at Martin; 3. University of Tennessee at Chattanooga)\" .
      _:b111iddOtlocdOtgovauthoritiesnamesn2017180154 <http://www.loc.gov/mads/rdf/v1#citationSource> \"The University of Tennessee System website, viewed Feb. 24, 2006\" .
      _:b111iddOtlocdOtgovauthoritiesnamesn2017180154 <http://www.loc.gov/mads/rdf/v1#citationStatus> \"found\" .
      <http://id.loc.gov/rwo/agents/n2017180154> <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://www.loc.gov/mads/rdf/v1#RWO> .
      <http://id.loc.gov/rwo/agents/n2017180154> <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://xmlns.com/foaf/0.1/Organization> .
      <http://id.loc.gov/rwo/agents/n2017180154> <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://id.loc.gov/ontologies/bibframe/Organization> .
      <http://id.loc.gov/rwo/agents/n2017180154> <http://id.loc.gov/ontologies/bflc/subjectOf> <http://id.loc.gov/resources/works/22086820> .
      <http://id.loc.gov/rwo/agents/n2017180154> <http://id.loc.gov/ontologies/bflc/contributorTo> <http://id.loc.gov/resources/works/11055169> .
      <http://id.loc.gov/rwo/agents/n2017180154> <http://id.loc.gov/ontologies/bflc/contributorTo> <http://id.loc.gov/resources/works/10800050> .
      <http://id.loc.gov/rwo/agents/n2017180154> <http://id.loc.gov/ontologies/bflc/contributorTo> <http://id.loc.gov/resources/works/17777546> .
      <http://id.loc.gov/rwo/agents/n2017180154> <http://id.loc.gov/ontologies/bflc/contributorTo> <http://id.loc.gov/resources/works/10532783> .
      <http://id.loc.gov/rwo/agents/n2017180154> <http://id.loc.gov/ontologies/bflc/contributorTo> <http://id.loc.gov/resources/works/22506972> .
      <http://id.loc.gov/rwo/agents/n2017180154> <http://id.loc.gov/ontologies/bflc/contributorTo> <http://id.loc.gov/resources/works/11055242> .
      <http://id.loc.gov/rwo/agents/n2017180154> <http://www.w3.org/2000/01/rdf-schema#label> \"University of Tennessee\" .
      <http://id.loc.gov/authorities/names/n80003891> <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://www.loc.gov/mads/rdf/v1#Authority> .
      <http://id.loc.gov/authorities/names/n80003891> <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://www.loc.gov/mads/rdf/v1#CorporateName> .
      <http://id.loc.gov/authorities/names/n80003891> <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://www.w3.org/2004/02/skos/core#Concept> .
      <http://id.loc.gov/authorities/names/n80003891> <http://www.loc.gov/mads/rdf/v1#authoritativeLabel> \"University of Tennessee (System)\" .
      <http://id.loc.gov/authorities/names/n80003891> <http://www.loc.gov/mads/rdf/v1#elementList> _:g377180 .
      <http://id.loc.gov/authorities/names/n80003891> <http://www.w3.org/2004/02/skos/core#prefLabel> \"University of Tennessee (System)\" .
      _:g377160 <http://www.w3.org/1999/02/22-rdf-syntax-ns#rest> <http://www.w3.org/1999/02/22-rdf-syntax-ns#nil> .
      _:g377160 <http://www.w3.org/1999/02/22-rdf-syntax-ns#first> _:b8iddOtlocdOtgovauthoritiesnamesn2017180154 .
      <http://id.loc.gov/resources/works/17777546> <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://id.loc.gov/ontologies/bibframe/Work> .
      <http://id.loc.gov/resources/works/17777546> <http://id.loc.gov/ontologies/bflc/aap> \"University of Tennessee Report of the treasurer\" .
      _:b95iddOtlocdOtgovauthoritiesnamesn2017180154 <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://www.loc.gov/mads/rdf/v1#Source> .
      _:b95iddOtlocdOtgovauthoritiesnamesn2017180154 <http://www.loc.gov/mads/rdf/v1#citationNote> \"t.p. (University of Tennessee)\" .
      _:b95iddOtlocdOtgovauthoritiesnamesn2017180154 <http://www.loc.gov/mads/rdf/v1#citationSource> \"The prophecy of science, 1883:\" .
      _:b95iddOtlocdOtgovauthoritiesnamesn2017180154 <http://www.loc.gov/mads/rdf/v1#citationStatus> \"found\" .
      <http://id.loc.gov/authorities/names/nr95035347> <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://www.loc.gov/mads/rdf/v1#Authority> .
      <http://id.loc.gov/authorities/names/nr95035347> <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://www.loc.gov/mads/rdf/v1#CorporateName> .
      <http://id.loc.gov/authorities/names/nr95035347> <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://www.w3.org/2004/02/skos/core#Concept> .
      <http://id.loc.gov/authorities/names/nr95035347> <http://www.loc.gov/mads/rdf/v1#authoritativeLabel> \"East Tennessee University\" .
      <http://id.loc.gov/authorities/names/nr95035347> <http://www.loc.gov/mads/rdf/v1#elementList> _:g377240 .
      <http://id.loc.gov/authorities/names/nr95035347> <http://www.w3.org/2004/02/skos/core#prefLabel> \"East Tennessee University\" .
      <http://id.loc.gov/authorities/names/n2017180154> <http://www.w3.org/2004/02/skos/core#semanticRelation> <http://id.loc.gov/authorities/names/n80003891> .
      <http://id.loc.gov/authorities/names/n2017180154> <http://www.w3.org/2004/02/skos/core#semanticRelation> <http://id.loc.gov/authorities/names/nr95035347> .
      <http://id.loc.gov/authorities/names/n2017180154> <http://www.w3.org/2004/02/skos/core#semanticRelation> <http://id.loc.gov/authorities/names/n80003883> .
      <http://id.loc.gov/authorities/names/n2017180154> <http://www.w3.org/2004/02/skos/core#semanticRelation> <http://id.loc.gov/authorities/names/n80003887> .
      <http://id.loc.gov/authorities/names/n2017180154> <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://www.loc.gov/mads/rdf/v1#Authority> .
      <http://id.loc.gov/authorities/names/n2017180154> <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://www.loc.gov/mads/rdf/v1#CorporateName> .
      <http://id.loc.gov/authorities/names/n2017180154> <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://www.w3.org/2004/02/skos/core#Concept> .
      <http://id.loc.gov/authorities/names/n2017180154> <http://id.loc.gov/ontologies/bflc/marcKey> \"1102 $aUniversity of Tennessee\" .
      <http://id.loc.gov/authorities/names/n2017180154> <http://www.loc.gov/mads/rdf/v1#hasSource> _:b111iddOtlocdOtgovauthoritiesnamesn2017180154 .
      <http://id.loc.gov/authorities/names/n2017180154> <http://www.loc.gov/mads/rdf/v1#hasSource> _:b95iddOtlocdOtgovauthoritiesnamesn2017180154 .
      <http://id.loc.gov/authorities/names/n2017180154> <http://www.loc.gov/mads/rdf/v1#hasSource> _:b103iddOtlocdOtgovauthoritiesnamesn2017180154 .
      <http://id.loc.gov/authorities/names/n2017180154> <http://www.loc.gov/mads/rdf/v1#hasCloseExternalAuthority> <http://id.worldcat.org/fast/1995123> .
      <http://id.loc.gov/authorities/names/n2017180154> <http://id.loc.gov/vocabulary/identifiers/lccn> \"n 2017180154\" .
      <http://id.loc.gov/authorities/names/n2017180154> <http://www.loc.gov/mads/rdf/v1#identifiesRWO> <http://id.loc.gov/rwo/agents/n2017180154> .
      <http://id.loc.gov/authorities/names/n2017180154> <http://www.loc.gov/mads/rdf/v1#authoritativeLabel> \"University of Tennessee\" .
      <http://id.loc.gov/authorities/names/n2017180154> <http://www.loc.gov/mads/rdf/v1#isMemberOfMADSScheme> <http://id.loc.gov/authorities/names> .
      <http://id.loc.gov/authorities/names/n2017180154> <http://www.loc.gov/mads/rdf/v1#hasExactExternalAuthority> <http://viaf.org/viaf/sourceID/LC%7Cn+2017180154#skos:Concept> .
      <http://id.loc.gov/authorities/names/n2017180154> <http://id.loc.gov/vocabulary/identifiers/local> \"(DNLM)1343319\" .
      <http://id.loc.gov/authorities/names/n2017180154> <http://www.loc.gov/mads/rdf/v1#adminMetadata> _:b119iddOtlocdOtgovauthoritiesnamesn2017180154 .
      <http://id.loc.gov/authorities/names/n2017180154> <http://www.loc.gov/mads/rdf/v1#elementList> _:g377160 .
      <http://id.loc.gov/authorities/names/n2017180154> <http://www.w3.org/2004/02/skos/core#prefLabel> \"University of Tennessee\" .
      <http://id.loc.gov/authorities/names/n2017180154> <http://www.loc.gov/mads/rdf/v1#hasRelatedAuthority> <http://id.loc.gov/authorities/names/n80003891> .
      <http://id.loc.gov/authorities/names/n2017180154> <http://www.loc.gov/mads/rdf/v1#hasRelatedAuthority> <http://id.loc.gov/authorities/names/nr95035347> .
      <http://id.loc.gov/authorities/names/n2017180154> <http://www.loc.gov/mads/rdf/v1#hasRelatedAuthority> <http://id.loc.gov/authorities/names/n80003883> .
      <http://id.loc.gov/authorities/names/n2017180154> <http://www.loc.gov/mads/rdf/v1#hasRelatedAuthority> <http://id.loc.gov/authorities/names/n80003887> .
      <http://id.loc.gov/authorities/names/n2017180154> <http://www.loc.gov/mads/rdf/v1#isMemberOfMADSCollection> <http://id.loc.gov/authorities/names/collection_LCNAF> .
      <http://id.loc.gov/authorities/names/n2017180154> <http://www.loc.gov/mads/rdf/v1#isMemberOfMADSCollection> <http://id.loc.gov/authorities/names/collection_NamesAuthorizedHeadings> .
      <http://id.loc.gov/authorities/names/n2017180154> <http://www.w3.org/2004/02/skos/core#closeMatch> <http://id.worldcat.org/fast/1995123> .
      <http://id.loc.gov/authorities/names/n2017180154> <http://www.w3.org/2004/02/skos/core#exactMatch> <http://viaf.org/viaf/sourceID/LC%7Cn+2017180154#skos:Concept> .
      <http://id.loc.gov/authorities/names/n2017180154> <http://www.w3.org/2004/02/skos/core#changeNote> _:b157iddOtlocdOtgovauthoritiesnamesn2017180154 .
      <http://id.loc.gov/authorities/names/n2017180154> <http://www.w3.org/2004/02/skos/core#inScheme> <http://id.loc.gov/authorities/names> .
      _:b19iddOtlocdOtgovauthoritiesnamesn2017180154 <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://www.loc.gov/mads/rdf/v1#NameElement> .
      _:b19iddOtlocdOtgovauthoritiesnamesn2017180154 <http://www.loc.gov/mads/rdf/v1#elementValue> \"University of Tennessee (System)\" .
      _:b157iddOtlocdOtgovauthoritiesnamesn2017180154 <http://purl.org/vocab/changeset/schema#changeReason> \"new\" .
      _:b157iddOtlocdOtgovauthoritiesnamesn2017180154 <http://purl.org/vocab/changeset/schema#subjectOfChange> <http://id.loc.gov/authorities/names/n2017180154> .
      _:b157iddOtlocdOtgovauthoritiesnamesn2017180154 <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://purl.org/vocab/changeset/schema#ChangeSet> .
      _:b157iddOtlocdOtgovauthoritiesnamesn2017180154 <http://purl.org/vocab/changeset/schema#creatorName> <http://id.loc.gov/vocabulary/organizations/dnlm> .
      _:b157iddOtlocdOtgovauthoritiesnamesn2017180154 <http://purl.org/vocab/changeset/schema#createdDate> \"2017-01-09T00:00:00\"^^<http://www.w3.org/2001/XMLSchema#dateTime> .
      _:b46iddOtlocdOtgovauthoritiesnamesn2017180154 <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://www.loc.gov/mads/rdf/v1#NameElement> .
      _:b46iddOtlocdOtgovauthoritiesnamesn2017180154 <http://www.loc.gov/mads/rdf/v1#elementValue> \"East Tennessee University\" .
      _:b8iddOtlocdOtgovauthoritiesnamesn2017180154 <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://www.loc.gov/mads/rdf/v1#NameElement> .
      _:b8iddOtlocdOtgovauthoritiesnamesn2017180154 <http://www.loc.gov/mads/rdf/v1#elementValue> \"University of Tennessee\" .
      <http://id.loc.gov/resources/works/10532783> <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://id.loc.gov/ontologies/bibframe/Work> .
      <http://id.loc.gov/resources/works/10532783> <http://id.loc.gov/ontologies/bflc/aap> \"University of Tennessee Report ... to the state superintendent of public instruction\" .
      _:g377240 <http://www.w3.org/1999/02/22-rdf-syntax-ns#rest> <http://www.w3.org/1999/02/22-rdf-syntax-ns#nil> .
      _:g377240 <http://www.w3.org/1999/02/22-rdf-syntax-ns#first> _:b46iddOtlocdOtgovauthoritiesnamesn2017180154 .
      _:g377200 <http://www.w3.org/1999/02/22-rdf-syntax-ns#rest> <http://www.w3.org/1999/02/22-rdf-syntax-ns#nil> .
      _:g377200 <http://www.w3.org/1999/02/22-rdf-syntax-ns#first> _:b28iddOtlocdOtgovauthoritiesnamesn2017180154 .
      <http://id.worldcat.org/fast/1995123> <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://www.loc.gov/mads/rdf/v1#Authority> .
      <http://id.worldcat.org/fast/1995123> <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://www.w3.org/2004/02/skos/core#Concept> .
      <http://id.worldcat.org/fast/1995123> <http://www.loc.gov/mads/rdf/v1#authoritativeLabel> \"University of Tennessee\" .
      <http://id.worldcat.org/fast/1995123> <http://www.w3.org/2004/02/skos/core#prefLabel> \"University of Tennessee\" .
      _:b119iddOtlocdOtgovauthoritiesnamesn2017180154 <http://id.loc.gov/ontologies/RecordInfo#recordContentSource> <http://id.loc.gov/vocabulary/organizations/dnlm> .
      _:b119iddOtlocdOtgovauthoritiesnamesn2017180154 <http://id.loc.gov/ontologies/RecordInfo#languageOfCataloging> <http://id.loc.gov/vocabulary/iso639-2/eng> .
      _:b119iddOtlocdOtgovauthoritiesnamesn2017180154 <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://id.loc.gov/ontologies/RecordInfo#RecordInfo> .
      _:b119iddOtlocdOtgovauthoritiesnamesn2017180154 <http://id.loc.gov/ontologies/RecordInfo#recordChangeDate> \"2017-01-09T00:00:00\"^^<http://www.w3.org/2001/XMLSchema#dateTime> .
      _:b119iddOtlocdOtgovauthoritiesnamesn2017180154 <http://id.loc.gov/ontologies/RecordInfo#recordStatus> \"new\" .
      <http://id.loc.gov/resources/works/11055169> <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://id.loc.gov/ontologies/bibframe/Work> .
      <http://id.loc.gov/resources/works/11055169> <http://id.loc.gov/ontologies/bflc/aap> \"University of Tennessee. Annual report of the president\" .
      <http://id.loc.gov/authorities/names/n80003883> <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://www.loc.gov/mads/rdf/v1#Authority> .
      <http://id.loc.gov/authorities/names/n80003883> <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://www.loc.gov/mads/rdf/v1#CorporateName> .
      <http://id.loc.gov/authorities/names/n80003883> <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://www.w3.org/2004/02/skos/core#Concept> .
      <http://id.loc.gov/authorities/names/n80003883> <http://www.loc.gov/mads/rdf/v1#authoritativeLabel> \"University of Tennessee (Memphis campus)\" .
      <http://id.loc.gov/authorities/names/n80003883> <http://www.loc.gov/mads/rdf/v1#elementList> _:g377220 .
      <http://id.loc.gov/authorities/names/n80003883> <http://www.w3.org/2004/02/skos/core#prefLabel> \"University of Tennessee (Memphis campus)\" .
      <http://id.loc.gov/authorities/names/n80003887> <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://www.loc.gov/mads/rdf/v1#Authority> .
      <http://id.loc.gov/authorities/names/n80003887> <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://www.loc.gov/mads/rdf/v1#CorporateName> .
      <http://id.loc.gov/authorities/names/n80003887> <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://www.w3.org/2004/02/skos/core#Concept> .
      <http://id.loc.gov/authorities/names/n80003887> <http://www.loc.gov/mads/rdf/v1#authoritativeLabel> \"University of Tennessee (Knoxville campus)\" .
      <http://id.loc.gov/authorities/names/n80003887> <http://www.loc.gov/mads/rdf/v1#elementList> _:g377200 .
      <http://id.loc.gov/authorities/names/n80003887> <http://www.w3.org/2004/02/skos/core#prefLabel> \"University of Tennessee (Knoxville campus)\" .
      <http://id.loc.gov/resources/works/10800050> <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://id.loc.gov/ontologies/bibframe/Work> .
      <http://id.loc.gov/resources/works/10800050> <http://id.loc.gov/ontologies/bflc/aap> \"University of Tennessee. General catalog\" .
      _:g377220 <http://www.w3.org/1999/02/22-rdf-syntax-ns#rest> <http://www.w3.org/1999/02/22-rdf-syntax-ns#nil> .
      _:g377220 <http://www.w3.org/1999/02/22-rdf-syntax-ns#first> _:b37id//www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://www.loc.gov/mads/rdf/v1#Source> .
      _:b103iddOtlocdOtgovauthoritiesnamesn2017180154 <http://www.loc.gov/mads/rdf/v1#citationNote> \"p. 164, etc. (University of Tennessee established 1794 as Blount College; 1807 name changed to East Tennessee College; 1840 became East Tennessee University; 1879 name changed to University of Tennessee)\" .
      _:b103iddOtlocdOtgovauthoritiesnamesn2017180154 <http://www.loc.gov/mads/rdf/v1#citationSource> \"Creekmore, B.B. Knoxville, 1958:\" .
      _:b103iddOtlocdOtgovauthoritiesnamesn2017180154 <http://www.loc.gov/mads/rdf/v1#citationStatus> \"found\" .
      _:g377180 <http://www.w3.org/1999/02/22-rdf-syntax-ns#rest> <http://www.w3.org/1999/02/22-rdf-syntax-ns#nil> .
      _:g377180 <http://www.w3.org/1999/02/22-rdf-syntax-ns#first> _:b19iddOtlocdOtgovauthoritiesnamesn2017180154 .
      <http://id.loc.gov/resources/works/22086820> <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://id.loc.gov/ontologies/bibframe/Work> .
      <http://id.loc.gov/resources/works/22086820> <http://id.loc.gov/ontologies/bflc/aap> \"Newman, Marvin E. [Image from LOOK - Job 57-7538 titled Bowden Wyatt -- Tennessee football]\" .
      <http://id.loc.gov/resources/works/11055242> <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://id.loc.gov/ontologies/bibframe/Work> .
      <http://id.loc.gov/resources/works/11055242> <http://id.loc.gov/ontologies/bflc/aap> \"University of Tennessee. Summer school\" .
      _:b28iddOtlocdOtgovauthoritiesnamesn2017180154 <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://www.loc.gov/mads/rdf/v1#NameElement> .
      _:b28iddOtlocdOtgovauthoritiesnamesn2017180154 <http://www.loc.gov/mads/rdf/v1#elementValue> \"University of Tennessee (Knoxville campus)\" .
      <http://id.loc.gov/resources/works/22506972> <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://id.loc.gov/ontologies/bibframe/Work> .
      <http://id.loc.gov/resources/works/22506972> <http://id.loc.gov/ontologies/bflc/aap> \"Annual financial report\" .
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

        expect(subject.uri_to_value_for(uri)).to eq 'University of Tennessee'
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
          .to eq 'http://id.loc.gov/authorities/names/n2017180154 (Failed to load URI)'
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
