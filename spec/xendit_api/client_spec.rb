require 'spec_helper'

module XenditApi
  describe Client do
    it 'takes an API key on initialization and convert it into token' do
      require "base64"
      api_key = 'xnd_development_P4qDfOss0OCpl8RSiCwZ3jw=='

      client = Client.new(api_key: api_key)

      appended_api_key = api_key + ':'
      tokenized_api_key = Base64.encode64(appended_api_key)

      expect(client.token).to eq tokenized_api_key 
    end

    describe '.get_balance' do
      context 'valid request' do
        before do
          @stub = stub_request(:get, "https://api.xendit.co/balance")
            .to_return(:status => 200, :body => '{"balance": 1241231}', :headers => {})          
        end

        it 'should return the current balance of the merchant account' do
          api_key = 'xnd_development_P4qDfOss0OCpl8RSiCwZ3jw=='
          client =  Client.new(api_key: api_key)

          result = client.get_cash_balance 

          expect(result.balance).to eq 1241231
          expect(result.balance_cents).to eq 124123100
          expect(@stub).to have_been_requested
        end
      end

      context 'no token provided' do
        it 'should return authentication failed as the response' do
          client =  Client.new(api_key: '')

          result = client.get_cash_balance 

          expect(result).to eq nil
        end
      end    
    end

    describe '.get_bank_account_data' do
      context 'valid request' do
        before do
          @stub = stub_request(:post, "https://api.xendit.co/bank_account_data_requests")
            .to_return(:status => 200, :body => '{}', :headers => {})          
        end

        it 'should return empty hash' do
          api_key = 'xnd_development_P4qDfOss0OCpl8RSiCwZ3jw=='
          client =  Client.new(api_key: api_key)

          result = client.get_bank_account_data(account_number: 'stubbed_number', bank_code: 'MANDIRI')

          expect(result).to eq Hash.new
          expect(@stub).to have_been_requested
        end
      end

      context 'no token provided' do
        it 'should return authentication failed as the response' do
          client =  Client.new(api_key: '')

          result = client.get_bank_account_data(account_number: 'stubbed_number', bank_code: 'MANDIRI')

          expect(result).to eq nil
        end
      end    
    end    
  end
end