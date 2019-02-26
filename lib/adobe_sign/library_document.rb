module AdobeSign
  class LibraryDocument
    attr_accessor :client,
                  :name,
                  :modified_date,
                  :scope,
                  :library_document_id,
                  :library_template_types

    def initialize(client, params)
      @client                 = client
      @name                   = params.fetch('name', nil)
      @modified_date          = params.fetch('modifiedDate', nil)
      @scope                  = params.fetch('scope', nil)
      @library_document_id    = params.fetch('libraryDocumentId', nil)
      @library_template_types = params.fetch('libraryTemplateTypes', nil)
    end
  end
end
