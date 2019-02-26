module AdobeSign
  class Document
    attr_accessor :client,
                  :agreement_id,
                  :document_id,
                  :mime_type,
                  :name,
                  :num_pages

    def initialize(client, agreement_id, params)
      @client       = client
      @agreement_id = agreement_id
      @document_id  = params.fetch('documentId', nil)
      @mime_type    = params.fetch('mimeType', nil)
      @name         = params.fetch('name', nil)
      @num_pages    = params.fetch('numPages', nil)
    end

    def pdf_url
      @pdf_url ||= client.document_pdf_url(agreement_id, document_id)
    end

    def file
      @file ||= begin
        url = pdf_url
        download(url)
      end
    end

    private

    def download(url)
      URI(url).open
    end
  end
end

