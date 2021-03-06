require 'spec_helper'

describe Shorty::Controllers::Show do
  let(:app) { Shorty::Application.router }

  describe '#call,  GET /:shorten/stats' do
    context 'given a brand new shortcode' do
      before do
        Shorty::Models::Shorty.new(url: 'google.com', shortcode: '111111').create
        get '/111111/stats'
      end

      it 'responds with 200 code' do
        expect(last_response.status).to eq(200)
      end

      it 'has no redirects' do
        body = JSON.parse(last_response.body).symbolize_keys
        expect(body[:redirectCount]).to eq(0)
      end

      it 'has no last seen date' do
        body = JSON.parse(last_response.body).symbolize_keys
        expect(body.keys).to_not include(:lastSeenDate)
      end
    end

    context 'given a shortcode with 3 redirects' do
      before do
        Shorty::Models::Shorty.new(url: 'google.com', shortcode: '111111').create
        3.times { get '/111111' }
        get '/111111/stats'
      end

      it 'responds with 200 code' do
        expect(last_response.status).to eq(200)
      end

      it 'has 3 redirects' do
        body = JSON.parse(last_response.body).symbolize_keys
        expect(body[:redirectCount]).to eq(3)
      end

      it 'has last seen date' do
        body = JSON.parse(last_response.body).symbolize_keys
        expect(body.keys).to include(:lastSeenDate)
      end
    end

    context 'given an unexistent shortcode' do
      before do
        get '/123456/stats'
      end

      it 'responds with 404 code' do
        expect(last_response.status).to eq(404)
      end

      it 'responds with error description body' do
        expected_body = {
          description: 'The shortcode cannot be found in the system'
        }.to_json
        expect(last_response.body).to eq(expected_body)
      end
    end
  end
end
