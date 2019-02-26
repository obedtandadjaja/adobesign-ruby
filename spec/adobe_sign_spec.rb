require 'spec_helper'
require 'clients/adobe_sign'
require 'rest-client'
require 'csv'

RSpec.describe AdobeSign::Client do
  let(:client) { described_class.new }
  let(:request) { AdobeSign::Request.new('access_token') }
  let(:agreement_params) do
    "{\"documentCreationInfo\":{\"fileInfos\":[{\"libraryDocumentId\":\"id\"}],"\
    "\"name\":\"name\",\"daysUntilSigningDeadline\":15,\"recipientSetInfos\":[{\""\
    "recipientSetMemberInfos\":[{\"email\":\"email\"}],\"recipientSetRole\":\"SIG"\
    "NER\"}],\"signatureType\":\"ESIGN\",\"signatureFlow\":\"SENDER_SIGNATURE_NOT"\
    "_REQUIRED\",\"mergeFieldInfo\":[]}}"
  end

  before do
    allow(AdobeSign::Authentication).to receive(:new_access_token).and_return('access_token')
    client.instance_variable_set(:@request, request)
  end

  describe '#widgets' do
    context 'with successful response' do
      let(:response) { JSON.parse(File.read('spec/fixtures/adobe_sign/widgets.json')) }

      before do
        allow(request).to receive(:get_widgets).and_return(response)
      end

      it 'creates an array of widget objects' do
        allow(request).to receive(:get_widgets).and_return(response)
        expect(client.widgets).to be_a(Array)
      end

      it 'creates an array with the correct count' do
        expect(client.widgets.count).to eq 1
      end

      it 'creates a widget object' do
        expect(client.widgets.first).to be_a(AdobeSign::Widget)
      end
    end

    context 'when request returns an error' do
      before do
        allow(request).to receive(:get_widgets)
          .and_raise(AdobeSign::Request::RequestFailure.new('status_code', 'code', 'message'))
      end

      it 'raises the error' do
        expect { client.widgets }.to raise_error(AdobeSign::Request::RequestFailure)
      end
    end

    context 'when invalid token error returned' do
      let(:response_body) { { 'code' => 'INVALID_ACCESS_TOKEN' } }
      let(:error_response) { RestClient::Response.new(response_body.to_json) }
      let(:error) { RestClient::ExceptionWithResponse.new(error_response) }

      before do
        allow(RestClient).to receive(:get).with(AdobeSign::Endpoint.widgets, { access_token: 'access_token' })
          .and_raise(error)
      end

      it 'calls refresh access token twice' do
        expect(AdobeSign::Authentication).to receive(:new_access_token).exactly(AdobeSign::Client::RETRY_COUNT).times
        client.widgets
      end

      it 'retries the request with new access_token' do
        expect(RestClient).to receive(:get).with(AdobeSign::Endpoint.widgets, { access_token: 'access_token' })
          .exactly(AdobeSign::Client::RETRY_COUNT).times
        client.widgets
      end
    end
  end

  describe '#widget' do
    context 'with successful response' do
      let(:response) { JSON.parse(File.read('spec/fixtures/adobe_sign/widget.json')) }

      before do
        allow(request).to receive(:get_widget).and_return(response)
      end

      it 'creates a widget object' do
        expect(client.widget('123')).to be_a(AdobeSign::Widget)
      end
    end

    context 'when request returns an error' do
      before do
        allow(request).to receive(:get_widget)
          .and_raise(AdobeSign::Request::RequestFailure.new('status_code', 'code', 'message'))
      end

      it 'raises the error' do
        expect { client.widget('123') }.to raise_error(AdobeSign::Request::RequestFailure)
      end
    end

    context 'when invalid token error returned' do
      let(:response_body) { { 'code' => 'INVALID_ACCESS_TOKEN' } }
      let(:error_response) { RestClient::Response.new(response_body.to_json) }
      let(:error) { RestClient::ExceptionWithResponse.new(error_response) }

      before do
        allow(RestClient).to receive(:get).with(AdobeSign::Endpoint.widget('123'), { access_token: 'access_token' })
          .and_raise(error)
      end

      it 'calls refresh access token twice' do
        expect(AdobeSign::Authentication).to receive(:new_access_token).exactly(AdobeSign::Client::RETRY_COUNT).times
        client.widget('123')
      end

      it 'retries the request with new access_token' do
        expect(RestClient).to receive(:get).with(AdobeSign::Endpoint.widget('123'), { access_token: 'access_token' })
          .exactly(AdobeSign::Client::RETRY_COUNT).times
        client.widget('123')
      end
    end
  end

  describe '#widget_agreements' do
    context 'with successful response' do
      context 'when it returns an agreement object' do
        let(:response) { JSON.parse(File.read('spec/fixtures/adobe_sign/widget_agreement.json')) }

        before do
          allow(request).to receive(:get_widget_agreements).and_return(response)
        end

        it 'creates a widget object' do
          expect(client.widget_agreements('123')).to be_a(AdobeSign::Agreement)
        end
      end

      context 'when it returns an array of agreements' do
        let(:response) { JSON.parse(File.read('spec/fixtures/adobe_sign/widget_agreements.json')) }

        before do
          allow(request).to receive(:get_widget_agreements).and_return(response)
        end

        it 'creates an array of widget objects' do
          expect(client.widget_agreements('123')).to be_a(Array)
        end

        it 'creates an array with the correct count' do
          expect(client.widget_agreements('123').count).to eq 1
        end

        it 'creates a widget object' do
          expect(client.widget_agreements('123').first).to be_a(AdobeSign::Agreement)
        end
      end
    end

    context 'when request returns an error' do
      before do
        allow(request).to receive(:get_widget_agreements)
          .and_raise(AdobeSign::Request::RequestFailure.new('status_code', 'code', 'message'))
      end

      it 'raises the error' do
        expect { client.widget_agreements('123') }.to raise_error(AdobeSign::Request::RequestFailure)
      end
    end

    context 'when invalid token error returned' do
      let(:response_body) { { 'code' => 'INVALID_ACCESS_TOKEN' } }
      let(:error_response) { RestClient::Response.new(response_body.to_json) }
      let(:error) { RestClient::ExceptionWithResponse.new(error_response) }

      before do
        allow(RestClient).to receive(:get).with(
          AdobeSign::Endpoint.widget_agreements('123'),
          { access_token: 'access_token' }
        ).and_raise(error)
      end

      it 'calls refresh access token twice' do
        expect(AdobeSign::Authentication).to receive(:new_access_token).exactly(AdobeSign::Client::RETRY_COUNT).times
        client.widget_agreements('123')
      end

      it 'retries the request with new access_token' do
        expect(RestClient).to receive(:get).with(
          AdobeSign::Endpoint.widget_agreements('123'),
          { access_token: 'access_token' }
        ).exactly(AdobeSign::Client::RETRY_COUNT).times
        client.widget_agreements('123')
      end
    end
  end

  describe '#agreement' do
    context 'with successful response' do
      let(:response) { JSON.parse(File.read('spec/fixtures/adobe_sign/agreement.json')) }

      before do
        allow(request).to receive(:get_agreement).and_return(response)
      end

      it 'creates a agreement object' do
        expect(client.agreement('123')).to be_a(AdobeSign::Agreement)
      end
    end

    context 'when request returns an error' do
      before do
        allow(request).to receive(:get_agreement)
          .and_raise(AdobeSign::Request::RequestFailure.new('status_code', 'code', 'message'))
      end

      it 'raises the error' do
        expect { client.agreement('123') }.to raise_error(AdobeSign::Request::RequestFailure)
      end
    end

    context 'when invalid token error returned' do
      let(:response_body) { { 'code' => 'INVALID_ACCESS_TOKEN' } }
      let(:error_response) { RestClient::Response.new(response_body.to_json) }
      let(:error) { RestClient::ExceptionWithResponse.new(error_response) }

      before do
        allow(RestClient).to receive(:get).with(AdobeSign::Endpoint.agreement('123'), { access_token: 'access_token' })
          .and_raise(error)
      end

      it 'calls refresh access token twice' do
        expect(AdobeSign::Authentication).to receive(:new_access_token).exactly(AdobeSign::Client::RETRY_COUNT).times
        client.agreement('123')
      end

      it 'retries the request with new access_token' do
        expect(RestClient).to receive(:get).with(AdobeSign::Endpoint.agreement('123'), { access_token: 'access_token' })
          .exactly(AdobeSign::Client::RETRY_COUNT).times
        client.agreement('123')
      end
    end
  end

  describe '#agreement_documents' do
    context 'with successful response' do
      let(:response) { JSON.parse(File.read('spec/fixtures/adobe_sign/agreement_documents.json')) }

      before do
        allow(request).to receive(:get_agreement_documents).and_return(response)
      end

      it 'creates an array of widget objects' do
        expect(client.agreement_documents('123')).to be_a(Array)
      end

      it 'creates an array with the correct count' do
        expect(client.agreement_documents('123').count).to eq 1
      end

      it 'creates a widget object' do
        expect(client.agreement_documents('123').first).to be_a(AdobeSign::Document)
      end
    end

    context 'when request returns an error' do
      before do
        allow(request).to receive(:get_agreement_documents)
          .and_raise(AdobeSign::Request::RequestFailure.new('status_code', 'code', 'message'))
      end

      it 'raises the error' do
        expect { client.agreement_documents('123') }.to raise_error(AdobeSign::Request::RequestFailure)
      end
    end

    context 'when invalid token error returned' do
      let(:response_body) { { 'code' => 'INVALID_ACCESS_TOKEN' } }
      let(:error_response) { RestClient::Response.new(response_body.to_json) }
      let(:error) { RestClient::ExceptionWithResponse.new(error_response) }

      before do
        allow(RestClient).to receive(:get).with(
          AdobeSign::Endpoint.agreement_documents('123'),
          { access_token: 'access_token' }
        ).and_raise(error)
      end

      it 'calls refresh access token twice' do
        expect(AdobeSign::Authentication).to receive(:new_access_token).exactly(AdobeSign::Client::RETRY_COUNT).times
        client.agreement_documents('123')
      end

      it 'retries the request with new access_token' do
        expect(RestClient).to receive(:get).with(
          AdobeSign::Endpoint.agreement_documents('123'),
          { access_token: 'access_token' }
        ).exactly(AdobeSign::Client::RETRY_COUNT).times
        client.agreement_documents('123')
      end
    end
  end

  describe '#document_pdf_url' do
    context 'with successful response' do
      let(:response) { JSON.parse(File.read('spec/fixtures/adobe_sign/agreement_document_url.json')) }

      before do
        allow(request).to receive(:get_document_pdf_url).and_return(response)
      end

      it 'returns a url of pdf location' do
        expect(client.document_pdf_url('123', '456')).to include('.pdf')
      end
    end

    context 'when request returns an error' do
      before do
        allow(request).to receive(:get_document_pdf_url)
          .and_raise(AdobeSign::Request::RequestFailure.new('status_code', 'code', 'message'))
      end

      it 'raises the error' do
        expect { client.document_pdf_url('123', '456') }.to raise_error(AdobeSign::Request::RequestFailure)
      end
    end

    context 'when invalid token error returned' do
      let(:response_body) { { 'code' => 'INVALID_ACCESS_TOKEN' } }
      let(:error_response) { RestClient::Response.new(response_body.to_json) }
      let(:error) { RestClient::ExceptionWithResponse.new(error_response) }

      before do
        allow(RestClient).to receive(:get).with(
          AdobeSign::Endpoint.document_pdf_url('123', '456'),
          { access_token: 'access_token' }
        ).and_raise(error)
      end

      it 'calls refresh access token twice' do
        expect(AdobeSign::Authentication).to receive(:new_access_token).exactly(AdobeSign::Client::RETRY_COUNT).times
        client.document_pdf_url('123', '456')
      end

      it 'retries the request with new access_token' do
        expect(RestClient).to receive(:get).with(
          AdobeSign::Endpoint.document_pdf_url('123', '456'),
          { access_token: 'access_token' }
        ).exactly(AdobeSign::Client::RETRY_COUNT).times
        client.document_pdf_url('123', '456')
      end
    end
  end

  describe '#agreement_form_data' do
    context 'with successful response' do
      let(:response) { File.read('spec/fixtures/adobe_sign/agreement_form_data.csv') }

      before do
        allow(request).to receive(:get_agreement_form_data).and_return(response)
      end

      it 'returns a CSV parsed data' do
        expect(client.agreement_form_data('123')).to be_a(CSV::Table)
      end
    end

    context 'when request returns an error' do
      before do
        allow(request).to receive(:get_agreement_form_data)
          .and_raise(AdobeSign::Request::RequestFailure.new('status_code', 'code', 'message'))
      end

      it 'raises the error' do
        expect { client.agreement_form_data('123') }.to raise_error(AdobeSign::Request::RequestFailure)
      end
    end

    context 'when invalid token error returned' do
      let(:response_body) { { 'code' => 'INVALID_ACCESS_TOKEN' } }
      let(:error_response) { RestClient::Response.new(response_body.to_json) }
      let(:error) { RestClient::ExceptionWithResponse.new(error_response) }

      before do
        allow(RestClient).to receive(:get).with(
          AdobeSign::Endpoint.agreement_form_data('123'),
          { access_token: 'access_token' }
        ).and_raise(error)
      end

      it 'calls refresh access token twice' do
        expect(AdobeSign::Authentication).to receive(:new_access_token).exactly(AdobeSign::Client::RETRY_COUNT).times
        client.agreement_form_data('123')
      end

      it 'retries the request with new access_token' do
        expect(RestClient).to receive(:get).with(
          AdobeSign::Endpoint.agreement_form_data('123'),
          { access_token: 'access_token' }
        ).exactly(AdobeSign::Client::RETRY_COUNT).times
        client.agreement_form_data('123')
      end
    end
  end

  describe '#library_documents' do
    context 'with successful response' do
      let(:response) { JSON.parse(File.read('spec/fixtures/adobe_sign/library_documents.json')) }

      before do
        allow(request).to receive(:get_library_documents).and_return(response)
      end

      it 'creates an array of library_document objects' do
        allow(request).to receive(:get_library_documents).and_return(response)
        expect(client.library_documents).to be_a(Array)
      end

      it 'creates an array with the correct count' do
        expect(client.library_documents.count).to eq 8
      end

      it 'creates a library_document object' do
        expect(client.library_documents.first).to be_a(AdobeSign::LibraryDocument)
      end
    end

    context 'when request returns an error' do
      before do
        allow(request).to receive(:get_library_documents)
          .and_raise(AdobeSign::Request::RequestFailure.new('status_code', 'code', 'message'))
      end

      it 'raises the error' do
        expect { client.library_documents }.to raise_error(AdobeSign::Request::RequestFailure)
      end
    end

    context 'when invalid token error returned' do
      let(:response_body) { { 'code' => 'INVALID_ACCESS_TOKEN' } }
      let(:error_response) { RestClient::Response.new(response_body.to_json) }
      let(:error) { RestClient::ExceptionWithResponse.new(error_response) }

      before do
        allow(RestClient).to receive(:get).with(
          AdobeSign::Endpoint.library_documents,
          { access_token: 'access_token' }
        ).and_raise(error)
      end

      it 'calls refresh access token twice' do
        expect(AdobeSign::Authentication).to receive(:new_access_token).exactly(AdobeSign::Client::RETRY_COUNT).times
        client.library_documents
      end

      it 'retries the request with new access_token' do
        expect(RestClient).to receive(:get).with(
          AdobeSign::Endpoint.library_documents,
          { access_token: 'access_token' }
        ).exactly(AdobeSign::Client::RETRY_COUNT).times
        client.library_documents
      end
    end
  end

  describe '#agreement_signing_urls' do
    context 'with successful response' do
      let(:response) { JSON.parse(File.read('spec/fixtures/adobe_sign/agreement_signing_urls.json')) }

      before do
        allow(request).to receive(:get_agreement_signing_urls).and_return(response)
      end

      it 'returns a url of pdf location' do
        expect(client.agreement_signing_urls('123')).to be_a(Array)
      end
    end

    context 'when request returns an error' do
      before do
        allow(request).to receive(:get_agreement_signing_urls)
          .and_raise(AdobeSign::Request::RequestFailure.new('status_code', 'code', 'message'))
      end

      it 'raises the error' do
        expect { client.agreement_signing_urls('123') }.to raise_error(AdobeSign::Request::RequestFailure)
      end
    end

    context 'when invalid token error returned' do
      let(:response_body) { { 'code' => 'INVALID_ACCESS_TOKEN' } }
      let(:error_response) { RestClient::Response.new(response_body.to_json) }
      let(:error) { RestClient::ExceptionWithResponse.new(error_response) }

      before do
        allow(RestClient).to receive(:get).with(
          AdobeSign::Endpoint.agreement_signing_urls('123'),
          { access_token: 'access_token' }
        ).and_raise(error)
      end

      it 'calls refresh access token twice' do
        expect(AdobeSign::Authentication).to receive(:new_access_token).exactly(AdobeSign::Client::RETRY_COUNT).times
        client.agreement_signing_urls('123')
      end

      it 'retries the request with new access_token' do
        expect(RestClient).to receive(:get).with(
          AdobeSign::Endpoint.agreement_signing_urls('123'),
          { access_token: 'access_token' }
        ).exactly(AdobeSign::Client::RETRY_COUNT).times
        client.agreement_signing_urls('123')
      end
    end
  end

  describe '#create_agreement' do
    context 'with successful response' do
      let(:response) { File.read('spec/fixtures/adobe_sign/create_agreement.json') }
      let(:agreement_response) { JSON.parse(File.read('spec/fixtures/adobe_sign/agreement.json')) }

      before do
        allow(RestClient).to receive(:post).with(
          AdobeSign::Endpoint.create_agreement,
          agreement_params,
          { access_token: 'access_token', content_type: 'application/json' }
        ).and_return(response)
        allow(request).to receive(:get_agreement).and_return(agreement_response)
      end

      it 'returns a url of pdf location' do
        expect(client.create_agreement('name', 'id', [], 'email', 15)).to be_a(AdobeSign::Agreement)
      end
    end

    context 'when request returns an error' do
      before do
        allow(request).to receive(:post_create_agreement)
          .and_raise(AdobeSign::Request::RequestFailure.new('status_code', 'code', 'message'))
      end

      it 'raises the error' do
        expect { client.create_agreement('name', 'id', [], 'email', 15) }.to raise_error(AdobeSign::Request::RequestFailure)
      end
    end

    context 'when invalid token error returned' do
      let(:response_body) { { 'code' => 'INVALID_ACCESS_TOKEN' } }
      let(:error_response) { RestClient::Response.new(response_body.to_json) }
      let(:error) { RestClient::ExceptionWithResponse.new(error_response) }

      before do
        allow(RestClient).to receive(:post).with(
          AdobeSign::Endpoint.create_agreement,
          agreement_params,
          { access_token: 'access_token', content_type: 'application/json' }
        ).and_raise(error)
      end

      it 'calls refresh access token twice' do
        expect(AdobeSign::Authentication).to receive(:new_access_token).exactly(AdobeSign::Client::RETRY_COUNT).times
        client.create_agreement('name', 'id', [], 'email', 15)
      end

      it 'retries the request with new access_token' do
        expect(RestClient).to receive(:post).with(
          AdobeSign::Endpoint.create_agreement,
          agreement_params,
          { access_token: 'access_token', content_type: 'application/json' }
        ).exactly(AdobeSign::Client::RETRY_COUNT).times
        client.create_agreement('name', 'id', [], 'email', 15)
      end
    end
  end
end
