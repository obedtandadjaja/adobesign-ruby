module AdobeSign
  class Endpoint
    ADOBE_AUTH_API_ROOT_URL = 'https://secure.na1.echosign.com'.freeze
    ADOBE_REST_API_ROOT_URL = 'https://api.na1.echosign.com/api/rest/v5'.freeze

    def self.refresh_token
      "#{ADOBE_AUTH_API_ROOT_URL}/oauth/refresh"
    end

    def self.widgets
      "#{ADOBE_REST_API_ROOT_URL}/widgets"
    end

    def self.widget(widget_id)
      "#{ADOBE_REST_API_ROOT_URL}/widgets/#{widget_id}"
    end

    def self.widget_agreements(widget_id)
      "#{ADOBE_REST_API_ROOT_URL}/widgets/#{widget_id}/agreements"
    end

    def self.agreements
      "#{ADOBE_REST_API_ROOT_URL}/agreements"
    end

    def self.agreement(agreement_id)
      "#{ADOBE_REST_API_ROOT_URL}/agreements/#{agreement_id}"
    end

    def self.agreement_documents(agreement_id)
      "#{ADOBE_REST_API_ROOT_URL}/agreements/#{agreement_id}/documents"
    end

    def self.document_pdf_url(agreement_id, document_id)
      "#{ADOBE_REST_API_ROOT_URL}/agreements/#{agreement_id}/documents/#{document_id}/url"
    end

    def self.agreement_form_data(agreement_id)
      "#{ADOBE_REST_API_ROOT_URL}/agreements/#{agreement_id}/formData"
    end

    def self.create_agreement
      "#{ADOBE_REST_API_ROOT_URL}/agreements"
    end

    def self.library_documents
      "#{ADOBE_REST_API_ROOT_URL}/libraryDocuments"
    end

    def self.library_document(library_document_id)
      "#{ADOBE_REST_API_ROOT_URL}/libraryDocuments/#{library_document_id}"
    end

    def self.agreement_signing_urls(agreement_id)
      "#{ADOBE_REST_API_ROOT_URL}/agreements/#{agreement_id}/signingUrls"
    end
  end
end
