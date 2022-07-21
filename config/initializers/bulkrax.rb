# frozen_string_literal: true

if ENV.fetch('HYKU_BULKRAX_ENABLED', 'true') == 'true'

  Bulkrax.setup do |config|
    # Add or remove local parsers
    config.parsers -= [
      { name: "OAI - Dublin Core", class_name: "Bulkrax::OaiDcParser", partial: "oai_fields" },
      { name: "OAI - Qualified Dublin Core", class_name: "Bulkrax::OaiQualifiedDcParser", partial: "oai_fields" },
      { name: "XML", class_name: "Bulkrax::XmlParser", partial: "xml_fields" },
      { name: "Bagit", class_name: "Bulkrax::BagitParser", partial: "bagit_fields" }
    ]


    # Field to use during import to identify if the Work or Collection already exists.
    # Default is 'source'.
    # config.system_identifier_field = 'source'

    # WorkType to use as the default if none is specified in the import
    # Default is the first returned by Hyrax.config.curation_concerns
    # config.default_work_type = MyWork

    # Path to store pending imports
    # config.import_path = 'tmp/imports'

    # Path to store exports before download
    # config.export_path = 'tmp/exports'

    # Server name for oai request header
    # config.server_name = 'my_server@name.com'

    # Field_mapping for establishing a parent-child relationship (FROM parent TO child)
    # This can be a Collection to Work, or Work to Work relationship
    # This value IS NOT used for OAI, so setting the OAI Entries here will have no effect
    # The mapping is supplied per Entry, provide the full class name as a string, eg. 'Bulkrax::CsvEntry'
    # Example:
    #   {
    #     'Bulkrax::RdfEntry'  => 'http://opaquenamespace.org/ns/contents',
    #     'Bulkrax::CsvEntry'  => 'children'
    #   }
    # By default no parent-child relationships are added
    # config.parent_child_field_mapping = { }

    # Field_mapping for establishing a collection relationship (FROM work TO collection)
    # This value IS NOT used for OAI, so setting the OAI parser here will have no effect
    # The mapping is supplied per Entry, provide the full class name as a string, eg. 'Bulkrax::CsvEntry'
    # The default value for CSV is collection
    # Add/replace parsers, for example:
    # config.collection_field_mapping['Bulkrax::RdfEntry'] = 'http://opaquenamespace.org/ns/set'

    config.fill_in_blank_source_identifiers = ->(obj, index) { "#{Site.instance.account.name}-#{obj.importerexporter.id}-#{index}" }

    # Field mappings
    parser_mapping = {
    'admin_set_id' => { from: ['admin_set_id'], generated: true },
    'based_near' => { from: ['based_near'], split: '\|' },
    'bibliographic_citation' => { from: ['bibliographic_citation'], split: '\|', generated: true },
    'bulkrax_identifier' => { from: ['source_identifier'], source_identifier: true, generated: true },
    'children' => { from: ['children'], split: /\s*[;|]\s*/, related_children_field_mapping: true },
    'contributor' => { from: ['contributor'], split: '\|' },
    'creator' => { from: ['creator'], split: '\|' },
    'date_created' => { from: ['date_created'], split: '\|' },
    'description' => { from: ['description'], split: '\|' },
    'file' => { from: ['file'], split: '\|' },
    'identifier' => { from: ['identifier'], split: '\|' },
    'import_url' => { from: ['import_url'], split: '\|', generated: true },
    'keyword' => { from: ['keyword'], split: '\|' },
    'language' => { from: ['language'], split: '\|' },
    'lease_id' => { from: ['lease_id'], generated: true },
    'license' => { from: ['license'], split: '\|' },
    'parents' => { from: ['parents'], split: /\s*[;|]\s*/, related_parents_field_mapping: true },
    'publisher' => { from: ['publisher'], split: '\|' },
    'related_url' => { from: ['related_url'], split: '\|' },
    'rendering_ids' => { from: ['rendering_ids'], split: '\|', generated: true },
    'representative_id' => { from: ['representative_id'], generated: true },
    'resource_type' => { from: ['resource_type'], split: '\|' },
    'rights_statement' => { from: ['rights_statement'], split: '\|', generated: true },
    'subject' => { from: ['subject'], split: '\|' },
    'title' => { from: ['title'], split: '\|' }
    }

    config.field_mappings['Bulkrax::CsvParser'] = parser_mapping

    # Create a completely new set of mappings by replacing the whole set as follows
    #   config.field_mappings = {
    #     "Bulkrax::OaiDcParser" => { **individual field mappings go here*** }
    #   }

    # Add to, or change existing mappings as follows
    #   e.g. to exclude date
    #   config.field_mappings["Bulkrax::OaiDcParser"]["date"] = { from: ["date"], excluded: true  }

    # To duplicate a set of mappings from one parser to another
    #   config.field_mappings["Bulkrax::OaiOmekaParser"] = {}
    #   config.field_mappings["Bulkrax::OaiDcParser"].each {|key,value| config.field_mappings["Bulkrax::OaiOmekaParser"][key] = value }

    # Properties that should not be used in imports/exports. They are reserved for use by Hyrax.
    # config.reserved_properties += ['my_field']
  end
end
