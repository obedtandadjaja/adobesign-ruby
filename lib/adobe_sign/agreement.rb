require 'clients/adobe_sign/document'

module AdobeSign
  class Agreement
    RETRY_COUNT = 3

    attr_accessor :client,
                  :display_date,
                  :display_user_set_infos,
                  :esign,
                  :agreement_id,
                  :latest_version_id,
                  :agreement_name,
                  :status,
                  :events,
                  :participant_set_infos

    def initialize(client, params)
      @client                 = client
      @display_date           = params.fetch('displayDate', nil)
      @display_user_set_infos = params.fetch('displayUserSetInfos', nil)
      @esign                  = params.fetch('esign', nil)
      @agreement_id           = params.fetch('agreementId', nil)
      @latest_version_id      = params.fetch('latestVersionId', nil)
      @agreement_name         = params.fetch('name', nil)
      @status                 = params.fetch('status', nil)
      @events                 = params.fetch('events', nil)
      @participant_set_infos  = params.fetch('participantSetInfos', nil)
    end

    def documents
      @documents ||= client.agreement_documents(agreement_id)
    end

    def form_data
      @form_data ||= client.agreement_form_data(agreement_id)
    end

    def signing_urls
      retries ||= 0
      @signing_urls ||= client.agreement_signing_urls(agreement_id)
    rescue AdobeSign::Request::RequestFailure => e
      retry if (retries += 1) < RETRY_COUNT
    end

    def latest_esign_url
      signing_urls.last&.fetch('signingUrls')&.last&.fetch('esignUrl')
    end
  end
end

