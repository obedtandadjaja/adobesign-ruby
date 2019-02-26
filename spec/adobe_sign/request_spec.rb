require 'spec_helper'
require 'clients/adobe_sign/request'
require 'clients/adobe_sign/endpoint'
require 'rest-client'

RSpec.describe AdobeSign::Request do
  let(:request) { described_class.new('access_token') }

  describe '.refresh_access_token' do
    let(:headers) { { content_type: 'application/x-www-form-urlencoded' } }
    let(:body_params) do
      {
        grant_type: 'refresh_token',
        client_id: 'client_id',
        client_secret: 'client_secret',
        refresh_token: 'refresh_token'
      }
    end
    let(:response) { { code: 200, body: File.read('spec/fixtures/adobe_sign/refresh_access_token.json') } }

    before do
      allow(ENV).to receive(:fetch).with('ADOBE_SIGN_CLIENT_ID').and_return 'client_id'
      allow(ENV).to receive(:fetch).with('ADOBE_SIGN_CLIENT_SECRET').and_return 'client_secret'
      allow(ENV).to receive(:fetch).with('ADOBE_SIGN_REFRESH_TOKEN').and_return 'refresh_token'
    end

    it 'sends request with correct url, body, and headers' do
      expect(RestClient).to receive(:post).with(
        AdobeSign::Endpoint.refresh_token,
        body_params,
        headers
      ).and_return(response[:body])
      described_class.refresh_access_token(
        {
          grant_type: 'refresh_token',
          client_id: 'client_id',
          client_secret: 'client_secret',
          refresh_token: 'refresh_token'
        }
      )
    end
  end

  describe '.get_widgets' do
    let(:headers) { { access_token: 'access_token' } }
    let(:response) { { code: 200, body: File.read('spec/fixtures/adobe_sign/widgets.json') } }

    it 'sends request with correct url, body, and headers' do
      expect(RestClient).to receive(:get).with(AdobeSign::Endpoint.widgets, headers)
        .and_return(response[:body])
      request.get_widgets
    end

    context 'when error response returned' do
      let(:response_body) { { 'code' => 'error msg' } }
      let(:error_response) { RestClient::Response.new(response_body.to_json) }
      let(:error) { RestClient::ExceptionWithResponse.new(error_response) }

      before do
        allow(RestClient).to receive(:get).and_raise(error)
        allow(error_response).to receive(:code).and_return(404)
      end

      it 'logs a statsd event' do
        begin
          expect(Fair::ServiceKit::Statsd.client).to receive(:event).with(
            'AdobeSign request failed to complete',
            'get_widgets',
            tags: ['adobe_sign_request:get_widgets'],
            alert_type: 'error'
          )
          request.get_widgets
        rescue
        end
      end

      it 'logs the error' do
        begin
          expect(Fair::ServiceKit::Logging.log).to receive(:error).twice
          request.get_widgets
        rescue
        end
      end

      it 'raises the error as RequestFailure' do
        expect { request.get_widgets }.to raise_error(described_class::RequestFailure)
      end
    end
  end

  describe '.get_widget' do
    let(:headers) { { access_token: 'access_token' } }
    let(:response) { { code: 200, body: File.read('spec/fixtures/adobe_sign/widget.json') } }

    it 'sends request with correct url, body, and headers' do
      expect(RestClient).to receive(:get).with(AdobeSign::Endpoint.widget('123'), headers)
        .and_return(response[:body])
      request.get_widget('123')
    end

    context 'when error response returned' do
      let(:response_body) { { 'code' => 'error msg' } }
      let(:error_response) { RestClient::Response.new(response_body.to_json) }
      let(:error) { RestClient::ExceptionWithResponse.new(error_response) }

      before do
        allow(RestClient).to receive(:get).and_raise(error)
        allow(error_response).to receive(:code).and_return(404)
      end

      it 'logs a statsd event' do
        begin
          expect(Fair::ServiceKit::Statsd.client).to receive(:event).with(
            'AdobeSign request failed to complete',
            'get_widget',
            tags: ['adobe_sign_request:get_widget'],
            alert_type: 'error'
          )
          request.get_widget('123')
        rescue
        end
      end

      it 'logs the error' do
        begin
          expect(Fair::ServiceKit::Logging.log).to receive(:error).twice
          request.get_widget('123')
        rescue
        end
      end

      it 'raises the error as RequestFailure' do
        expect { request.get_widget('123') }.to raise_error(described_class::RequestFailure)
      end
    end
  end

  describe '.get_widget_agreements' do
    let(:headers) { { access_token: 'access_token' } }
    let(:response) { { code: 200, body: File.read('spec/fixtures/adobe_sign/widget_agreements.json') } }

    it 'sends request with correct url, body, and headers' do
      expect(RestClient).to receive(:get).with(AdobeSign::Endpoint.widget_agreements('123'), headers)
        .and_return(response[:body])
      request.get_widget_agreements('123')
    end

    context 'when error response returned' do
      let(:response_body) { { 'code' => 'error msg' } }
      let(:error_response) { RestClient::Response.new(response_body.to_json) }
      let(:error) { RestClient::ExceptionWithResponse.new(error_response) }

      before do
        allow(RestClient).to receive(:get).and_raise(error)
        allow(error_response).to receive(:code).and_return(404)
      end

      it 'logs a statsd event' do
        begin
          expect(Fair::ServiceKit::Statsd.client).to receive(:event).with(
            'AdobeSign request failed to complete',
            'get_widget_agreements',
            tags: ['adobe_sign_request:get_widget_agreements'],
            alert_type: 'error'
          )
          request.get_widget_agreements('123')
        rescue
        end
      end

      it 'logs the error' do
        begin
          expect(Fair::ServiceKit::Logging.log).to receive(:error).twice
          request.get_widget_agreements('123')
        rescue
        end
      end

      it 'raises the error as RequestFailure' do
        expect { request.get_widget_agreements('123') }.to raise_error(described_class::RequestFailure)
      end
    end
  end

  describe '.get_agreements' do
    let(:headers) { { access_token: 'access_token' } }
    let(:response) { { code: 200, body: File.read('spec/fixtures/adobe_sign/agreements.json') } }

    it 'sends request with correct url, body, and headers' do
      expect(RestClient).to receive(:get).with(AdobeSign::Endpoint.agreements, headers)
        .and_return(response[:body])
      request.get_agreements
    end

    context 'when error response returned' do
      let(:response_body) { { 'code' => 'error msg' } }
      let(:error_response) { RestClient::Response.new(response_body.to_json) }
      let(:error) { RestClient::ExceptionWithResponse.new(error_response) }

      before do
        allow(RestClient).to receive(:get).and_raise(error)
        allow(error_response).to receive(:code).and_return(404)
      end

      it 'logs a statsd event' do
        begin
          expect(Fair::ServiceKit::Statsd.client).to receive(:event).with(
            'AdobeSign request failed to complete',
            'get_agreements',
            tags: ['adobe_sign_request:get_agreements'],
            alert_type: 'error'
          )
          request.get_agreements
        rescue
        end
      end

      it 'logs the error' do
        begin
          expect(Fair::ServiceKit::Logging.log).to receive(:error).twice
          request.get_agreements
        rescue
        end
      end

      it 'raises the error as RequestFailure' do
        expect { request.get_agreements }.to raise_error(described_class::RequestFailure)
      end
    end
  end

  describe '.get_agreement' do
    let(:headers) { { access_token: 'access_token' } }
    let(:response) { { code: 200, body: File.read('spec/fixtures/adobe_sign/agreement.json') } }

    it 'sends request with correct url, body, and headers' do
      expect(RestClient).to receive(:get).with(AdobeSign::Endpoint.agreement('123'), headers)
        .and_return(response[:body])
      request.get_agreement('123')
    end

    context 'when error response returned' do
      let(:response_body) { { 'code' => 'error msg' } }
      let(:error_response) { RestClient::Response.new(response_body.to_json) }
      let(:error) { RestClient::ExceptionWithResponse.new(error_response) }

      before do
        allow(RestClient).to receive(:get).and_raise(error)
        allow(error_response).to receive(:code).and_return(404)
      end

      it 'logs a statsd event' do
        begin
          expect(Fair::ServiceKit::Statsd.client).to receive(:event).with(
            'AdobeSign request failed to complete',
            'get_agreement',
            tags: ['adobe_sign_request:get_agreement'],
            alert_type: 'error'
          )
          request.get_agreement('123')
        rescue
        end
      end

      it 'logs the error' do
        begin
          expect(Fair::ServiceKit::Logging.log).to receive(:error).twice
          request.get_agreement('123')
        rescue
        end
      end

      it 'raises the error as RequestFailure' do
        expect { request.get_agreement('123') }.to raise_error(described_class::RequestFailure)
      end
    end
  end

  describe '.get_agreement_documents' do
    let(:headers) { { access_token: 'access_token' } }
    let(:response) { { code: 200, body: File.read('spec/fixtures/adobe_sign/agreement.json') } }

    it 'sends request with correct url, body, and headers' do
      expect(RestClient).to receive(:get).with(AdobeSign::Endpoint.agreement_documents('123'), headers)
        .and_return(response[:body])
      request.get_agreement_documents('123')
    end

    context 'when error response returned' do
      let(:response_body) { { 'code' => 'error msg' } }
      let(:error_response) { RestClient::Response.new(response_body.to_json) }
      let(:error) { RestClient::ExceptionWithResponse.new(error_response) }

      before do
        allow(RestClient).to receive(:get).and_raise(error)
        allow(error_response).to receive(:code).and_return(404)
      end

      it 'logs a statsd event' do
        begin
          expect(Fair::ServiceKit::Statsd.client).to receive(:event).with(
            'AdobeSign request failed to complete',
            'get_agreement_documents',
            tags: ['adobe_sign_request:get_agreement_documents'],
            alert_type: 'error'
          )
          request.get_agreement_documents('123')
        rescue
        end
      end

      it 'logs the error' do
        begin
          expect(Fair::ServiceKit::Logging.log).to receive(:error).twice
          request.get_agreement_documents('123')
        rescue
        end
      end

      it 'raises the error as RequestFailure' do
        expect { request.get_agreement_documents('123') }.to raise_error(described_class::RequestFailure)
      end
    end
  end

  describe '.get_document_pdf_url' do
    let(:headers) { { access_token: 'access_token' } }
    let(:response) { { code: 200, body: File.read('spec/fixtures/adobe_sign/agreement.json') } }

    it 'sends request with correct url, body, and headers' do
      expect(RestClient).to receive(:get).with(AdobeSign::Endpoint.document_pdf_url('123', '456'), headers)
        .and_return(response[:body])
      request.get_document_pdf_url('123', '456')
    end

    context 'when error response returned' do
      let(:response_body) { { 'code' => 'error msg' } }
      let(:error_response) { RestClient::Response.new(response_body.to_json) }
      let(:error) { RestClient::ExceptionWithResponse.new(error_response) }

      before do
        allow(RestClient).to receive(:get).and_raise(error)
        allow(error_response).to receive(:code).and_return(404)
      end

      it 'logs a statsd event' do
        begin
          expect(Fair::ServiceKit::Statsd.client).to receive(:event).with(
            'AdobeSign request failed to complete',
            'get_document_pdf_url',
            tags: ['adobe_sign_request:get_document_pdf_url'],
            alert_type: 'error'
          )
          request.get_document_pdf_url('123', '456')
        rescue
        end
      end

      it 'logs the error' do
        begin
          expect(Fair::ServiceKit::Logging.log).to receive(:error).twice
          request.get_document_pdf_url('123', '456')
        rescue
        end
      end

      it 'raises the error as RequestFailure' do
        expect { request.get_document_pdf_url('123', '456') }.to raise_error(described_class::RequestFailure)
      end
    end
  end

  describe '.get_agreement_form_data' do
    let(:headers) { { access_token: 'access_token' } }
    let(:response) { { code: 200, body: File.read('spec/fixtures/adobe_sign/agreement_form_data.csv') } }

    it 'sends request with correct url, body, and headers' do
      expect(RestClient).to receive(:get).with(AdobeSign::Endpoint.agreement_form_data('123'), headers)
        .and_return(response[:body])
      request.get_agreement_form_data('123')
    end

    context 'when error response returned' do
      let(:response_body) { { 'code' => 'error msg', 'message' => 'msg' } }
      let(:error_response) { RestClient::Response.new(response_body.to_json) }
      let(:error) { RestClient::ExceptionWithResponse.new(error_response) }

      before do
        allow(RestClient).to receive(:get).and_raise(error)
        allow(error_response).to receive(:code).and_return(404)
      end

      it 'logs a statsd event' do
        begin
          expect(Fair::ServiceKit::Statsd.client).to receive(:event).with(
            'AdobeSign request failed to complete',
            'get_agreement_form_data',
            tags: ['adobe_sign_request:get_agreement_form_data'],
            alert_type: 'error'
          )
          request.get_agreement_form_data('123')
        rescue
        end
      end

      it 'logs the error' do
        begin
          expect(Fair::ServiceKit::Logging.log).to receive(:error).twice
          request.get_agreement_form_data('123')
        rescue
        end
      end

      it 'raises the error as RequestFailure' do
        expect { request.get_agreement_form_data('123') }.to raise_error(described_class::RequestFailure)
      end
    end
  end
end
