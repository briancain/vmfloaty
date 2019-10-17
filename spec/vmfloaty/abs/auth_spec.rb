# frozen_string_literal: true

require 'spec_helper'
require_relative '../../../lib/vmfloaty/auth'

describe Pooler do
  before :each do
    @abs_url = 'https://abs.example.com'
  end

  describe '#get_token' do
    before :each do
      @get_token_response = '{"ok": true,"token":"utpg2i2xswor6h8ttjhu3d47z53yy47y"}'
      @token = 'utpg2i2xswor6h8ttjhu3d47z53yy47y'
    end

    it 'returns a token from vmpooler' do
      stub_request(:post, 'https://first.last:password@abs.example.com/api/v2/token')
        .with(:headers => { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Length' => '0', 'User-Agent' => 'Faraday v0.9.2' })
        .to_return(:status => 200, :body => @get_token_response, :headers => {})

      token = Auth.get_token(false, @abs_url, 'first.last', 'password')
      expect(token).to eq @token
    end

    it 'raises a token error if something goes wrong' do
      stub_request(:post, 'https://first.last:password@abs.example.com/api/v2/token')
        .with(:headers => { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Length' => '0', 'User-Agent' => 'Faraday v0.9.2' })
        .to_return(:status => 500, :body => '{"ok":false}', :headers => {})

      expect { Auth.get_token(false, @abs_url, 'first.last', 'password') }.to raise_error(TokenError)
    end
  end

  describe '#delete_token' do
    before :each do
      @delete_token_response = '{"ok":true}'
      @token = 'utpg2i2xswor6h8ttjhu3d47z53yy47y'
    end

    it 'deletes the specified token' do
      stub_request(:delete, 'https://first.last:password@abs.example.com/api/v2/token/utpg2i2xswor6h8ttjhu3d47z53yy47y')
        .with(:headers => { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent' => 'Faraday v0.9.2' })
        .to_return(:status => 200, :body => @delete_token_response, :headers => {})

      expect(Auth.delete_token(false, @abs_url, 'first.last', 'password', @token)).to eq JSON.parse(@delete_token_response)
    end

    it 'raises a token error if something goes wrong' do
      stub_request(:delete, 'https://first.last:password@abs.example.com/api/v2/token/utpg2i2xswor6h8ttjhu3d47z53yy47y')
        .with(:headers => { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent' => 'Faraday v0.9.2' })
        .to_return(:status => 500, :body => '{"ok":false}', :headers => {})

      expect { Auth.delete_token(false, @abs_url, 'first.last', 'password', @token) }.to raise_error(TokenError)
    end

    it 'raises a token error if no token provided' do
      expect { Auth.delete_token(false, @abs_url, 'first.last', 'password', nil) }.to raise_error(TokenError)
    end
  end

  describe '#token_status' do
    before :each do
      @token_status_response = '{"ok":true,"utpg2i2xswor6h8ttjhu3d47z53yy47y":{"created":"2015-04-28 19:17:47 -0700"}}'
      @token = 'utpg2i2xswor6h8ttjhu3d47z53yy47y'
    end

    it 'checks the status of a token' do
      stub_request(:get, "#{@abs_url}/token/utpg2i2xswor6h8ttjhu3d47z53yy47y")
        .with(:headers => { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent' => 'Faraday v0.9.2' })
        .to_return(:status => 200, :body => @token_status_response, :headers => {})

      expect(Auth.token_status(false, @abs_url, @token)).to eq JSON.parse(@token_status_response)
    end

    it 'raises a token error if something goes wrong' do
      stub_request(:get, "#{@abs_url}/token/utpg2i2xswor6h8ttjhu3d47z53yy47y")
        .with(:headers => { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent' => 'Faraday v0.9.2' })
        .to_return(:status => 500, :body => '{"ok":false}', :headers => {})

      expect { Auth.token_status(false, @abs_url, @token) }.to raise_error(TokenError)
    end

    it 'raises a token error if no token provided' do
      expect { Auth.token_status(false, @abs_url, nil) }.to raise_error(TokenError)
    end
  end
end
