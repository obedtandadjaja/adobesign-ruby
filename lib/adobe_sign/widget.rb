require 'clients/adobe_sign/agreement'

module AdobeSign
  class Widget
    attr_accessor :client,
                  :widget_id,
                  :javascript,
                  :modified_date,
                  :name,
                  :status,
                  :url,
                  :events,
                  :latest_version_id,
                  :participant_set_infos

    def initialize(client, params)
      @client                = client
      @widget_id             = params.fetch('widgetId', nil)
      @javascript            = params.fetch('javascript', nil)
      @modified_date         = params.fetch('modifiedDate', nil)
      @name                  = params.fetch('name', nil)
      @status                = params.fetch('status', nil)
      @url                   = params.fetch('url', nil)
      @events                = params.fetch('events', nil)
      @latest_version_id     = params.fetch('latestVersionId', nil)
      @participant_set_infos = params.fetch('participantSetInfos', nil)
    end

    def agreements
      @agreements ||= client.widget_agreements(widget_id)
    end
  end
end

