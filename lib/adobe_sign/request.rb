require 'clients/adobe_sign/endpoint'

module AdobeSign
  class Request
    attr_accessor :access_token

    def initialize(access_token)
      @access_token = access_token
    end

    ##################
    # AUTHENTICATION #
    ##################

    def self.refresh_access_token(params)
      post(AdobeSign::Endpoint.refresh_token, params, headers)
    end

    ##########
    # WIDGET #
    ##########

    def get_widgets
      get(AdobeSign::Endpoint.widgets)
    end

    def get_widget(widget_id)
      get(AdobeSign::Endpoint.widget(widget_id))
    end

    def get_widget_agreements(widget_id)
      get(AdobeSign::Endpoint.widget_agreements(widget_id))
    end

    #############
    # AGREEMENT #
    #############

    def get_agreements
      get(AdobeSign::Endpoint.agreements)
    end

    def get_agreement(agreement_id)
      get(AdobeSign::Endpoint.agreement(agreement_id))
    end

    def get_agreement_documents(agreement_id)
      get(AdobeSign::Endpoint.agreement_documents(agreement_id))
    end

    def get_agreement_form_data(agreement_id)
      get(AdobeSign::Endpoint.agreement_form_data(agreement_id), json_parsed: false)
    end

    def post_create_agreement(params)
      post(AdobeSign::Endpoint.create_agreement, params.to_json)
    end

    ############
    # DOCUMENT #
    ############

    def get_document_pdf_url(agreement_id, document_id)
      get(AdobeSign::Endpoint.document_pdf_url(agreement_id, document_id))
    end

    ####################
    # LIBRARY DOCUMENT #
    ####################

    def get_library_documents
      get(AdobeSign::Endpoint.library_documents)
    end

    def get_library_document(library_document_id)
      get(AdobeSign::Endpoint.library_document(library_document_id))
    end

    def get_agreement_signing_urls(agreement_id)
      get(AdobeSign::Endpoint.agreement_signing_urls(agreement_id))
    end

    private

    def get(endpoint, headers = { access_token: @access_token })
      response = RestClient.get(endpoint, headers)
      build_parsed_response(response)
    rescue StandardError => e
      raise_error(e)
    end

    def post(endpoint, body, headers = { access_token: @access_token,
                                         content_type: 'application/json' })
      response = RestClient.post(endpoint, body, headers)
      build_parsed_response(response)
    rescue StandardError => e
      raise_error(e)
    end

    def build_parsed_response(response)
      parsed_response = try_parse_json(response)
      parsed_response = try_parse_csv(response) if parsed_response.nil?
      parsed_response = response if parsed_response.nil?
      parsed_response
    end

    def try_parse_json(json)
      JSON.parse(json)
    rescue JSON::ParserError
      nil
    end

    def try_parse_csv(csv)
      CSV.parse(csv)
    rescue CSV::ParserError
      nil
    end

    def raise_error(error)
      parsed_response = JSON.parse(error.response.body)

      raise InvalidAccessToken, parsed_response['code'] if parsed_response['code'] == 'INVALID_ACCESS_TOKEN'

      raise RequestFailure.new(error.response.code, parsed_response['code'], parsed_response['message']), parsed_response
    end

    class InvalidAccessToken < StandardError; end

    class RequestFailure < StandardError
      attr_reader :status_code, :code, :message

      def initialize(status_code, code, message)
        @status_code = status_code
        @code = code
        @message = message
      end
    end
  end
end
