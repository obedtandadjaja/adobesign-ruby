require 'adobe_sign/request'
require 'adobe_sign/agreement'
require 'adobe_sign/widget'
require 'adobe_sign/document'
require 'adobe_sign/authentication'
require 'adobe_sign/library_document'
require 'open-uri'

module AdobeSign
  class Client
    include Fair::ServiceKit::ErrorHandler
    include Fair::ServiceKit::Logging

    RETRY_COUNT = 3

    attr_accessor :client_id,
                  :client_secret,
                  :refresh_token,
                  :request

    def initialize(
      client_id     = ENV.fetch('ADOBE_SIGN_CLIENT_ID'),
      client_secret = ENV.fetch('ADOBE_SIGN_CLIENT_SECRET'),
      refresh_token = ENV.fetch('ADOBE_SIGN_REFRESH_TOKEN')
    )
      @client_id     = client_id
      @client_secret = client_secret
      @refresh_token = refresh_token

      renew_request_with_new_access_token
    end

    ###########
    # WIDGETS #
    ###########

    def widgets
      initiate_request do
        response = @request.get_widgets
        if response.is_a?(Array)
          response.fetch('userWidgetList').map { |widget| AdobeSign::Widget.new(self, widget) }
        else
          AdobeSign::Widget.new(self, response.fetch('userWidgetList'))
        end
      end
    end

    def widget(widget_id)
      initiate_request do
        response = @request.get_widget(widget_id)
        AdobeSign::Widget.new(self, response)
      end
    end

    def widget_agreements(widget_id)
      initiate_request do
        response = @request.get_widget_agreements(widget_id)
        if response.fetch('userAgreementList').is_a?(Array)
          response.fetch('userAgreementList').map { |agreement| AdobeSign::Agreement.new(self, agreement) }
        else
          AdobeSign::Agreement.new(self, response.fetch('userAgreementList'))
        end
      end
    end

    #############
    # AGREEMENT #
    #############

    def agreement(agreement_id)
      initiate_request do
        response = @request.get_agreement(agreement_id)
        AdobeSign::Agreement.new(self, response)
      end
    end

    def agreement_documents(agreement_id)
      initiate_request do
        response = @request.get_agreement_documents(agreement_id)
        response.fetch('documents').map { |document| AdobeSign::Document.new(self, agreement_id, document) }
      end
    end

    def agreement_form_data(agreement_id)
      initiate_request do
        @request.get_agreement_form_data(agreement_id)
      end
    end

    def create_agreement(document_name, template_id, fields, email, signing_deadline_days)
      initiate_request do
        params = {
          documentCreationInfo: {
            fileInfos: [
              {
                libraryDocumentId: template_id
              }
            ],
            name: document_name,
            daysUntilSigningDeadline: signing_deadline_days,
            recipientSetInfos: [
              {
                recipientSetMemberInfos: [
                  {
                    email: email
                  }
                ],
                recipientSetRole: 'SIGNER'
              }
            ],
            signatureType: 'ESIGN',
            signatureFlow: 'SENDER_SIGNATURE_NOT_REQUIRED',
            mergeFieldInfo: prepare_agreement_fields(fields)
          }
        }
        response = @request.post_create_agreement(params)
        agreement(response.fetch('agreementId'))
      end
    end

    def agreement_signing_urls(agreement_id)
      initiate_request do
        response = @request.get_agreement_signing_urls(agreement_id)
        response.fetch('signingUrlSetInfos')
      end
    end

    ############
    # DOCUMENT #
    ############

    def document_pdf_url(agreement_id, document_id)
      initiate_request do
        response = @request.get_document_pdf_url(agreement_id, document_id)
        response.fetch('url')
      end
    end

    ####################
    # LIBRARY DOCUMENT #
    ####################

    def library_documents
      initiate_request do
        response = @request.get_library_documents
        if response.fetch('libraryDocumentList').is_a?(Array)
          response.fetch('libraryDocumentList').map do |library_document|
            AdobeSign::LibraryDocument.new(self, library_document)
          end
        else
          AdobeSign::LibraryDocument.new(self, response.fetch('libraryDocumentList'))
        end
      end
    end

    private

    def initiate_request
      retries ||= 0
      yield
    rescue AdobeSign::Request::InvalidAccessToken
      # access token expires in 1 hour
      renew_request_with_new_access_token
      retry if (retries += 1) < RETRY_COUNT
    end

    def renew_request_with_new_access_token
      access_token = AdobeSign::Authentication.new_access_token(@client_id, @client_secret, @refresh_token)
      @request = AdobeSign::Request.new(access_token)
    end

    def prepare_agreement_fields(fields)
      fields.map do |field|
        {
          fieldName: field.field_name,
          defaultValue: field.default_value
        }
      end.compact
    end
  end
end
