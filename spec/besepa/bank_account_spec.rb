require 'helper'

describe Besepa::BankAccount do

  describe '#all' do
    before do
      stub_get('/bank_accounts?page=1').
        to_return(body:    fixture('bank_accounts.json'),
                  headers: { content_type: 'application/json; charset=utf-8' })
    end

    it 'returns a list of bank_accounts' do
      bank_accounts = Besepa::BankAccount.all(page: 1)
      expect(bank_accounts).to respond_to(:each)
      expect(bank_accounts.first).to be_an Besepa::BankAccount
      expect(bank_accounts.size).to eq(1)
      expect(bank_accounts.per_page).to eq(30)
      expect(bank_accounts.current_page).to eq(1)
      expect(bank_accounts.total).to eq(1)
      expect(bank_accounts.pages).to eq(1)
    end
  end

  describe '#find' do
    before do
      stub_get('/bank_accounts/ban12345').
        to_return(body:    fixture('bank_account.json'),
                  headers: { content_type: 'application/json; charset=utf-8' })
    end

    it 'returns a bank account' do
      bank_account = Besepa::BankAccount.find('ban12345')
      expect(bank_account).to be_an Besepa::BankAccount
      expect(bank_account.iban).to eq("ES6012345678050000000001")
    end
  end

  describe '#create' do
    before do
      stub_post('/bank_accounts').with(
      body: { "bank_account": {
        "bank_name":    "Test Bank",
        "bic":          "TESTXXX",
        "iban":         "ES6012345678050000000001",
        "b2b_enabled":  "false",
        "b2b_suffix":   "000",
        "core_enabled": "true",
        "core_suffix":  "000"
      }}.to_json).to_return(
        body:    fixture('bank_account.json'),
        headers: {content_type: 'application/json; charset=utf-8'})
    end

    it 'returns a bank_account' do
      bank_account = Besepa::BankAccount.create({
        "bank_name":    "Test Bank",
        "bic":          "TESTXXX",
        "iban":         "ES6012345678050000000001",
        "b2b_enabled":  "false",
        "b2b_suffix":   "000",
        "core_enabled": "true",
        "core_suffix":  "000"
      })
      expect(bank_account).to be_an Besepa::BankAccount
      expect(bank_account.iban).to eq("ES6012345678050000000001")
    end
  end

  describe '.generate_signature_request' do
    describe 'with creditor account' do
      before do
        stub_get('/bank_accounts/ban12345').to_return(
          body:    fixture('bank_account.json'),
          headers: {content_type: 'application/json; charset=utf-8'})


        stub_put('/bank_accounts/ban12345/generate_signature_request').to_return(
          body:    fixture('bank_account.json'),
          headers: {content_type: 'application/json; charset=utf-8'})
      end

      it 'returns a bank_account' do
        bank_account = Besepa::BankAccount.find('ban12345')
        result = bank_account.generate_signature_request
        expect(result).to be_an Besepa::BankAccount
        expect(result.iban).to eq("ES6012345678050000000001")
      end
    end
    describe 'with no creditor account' do
      before do
      stub_get('/bank_accounts/ban12345').to_return(
        body:    fixture('bank_account.json'),
        headers: {content_type: 'application/json; charset=utf-8'})

      stub_put('/bank_accounts/ban12345/generate_signature_request').to_return(
        status:  409,
        body: { error: "missing_creditor",
                error_description: "Status: no puede ser activada sin una cuenta de destino"
        }.to_json,
        headers: {content_type: 'application/json; charset=utf-8'}
      )
      end
      it 'raises error' do
        bank_account = Besepa::BankAccount.find('ban12345')
        expect {
          bank_account.generate_signature_request
        }.to raise_error(Besepa::Errors::BesepaError,
                         /no puede ser activada sin una cuenta de destino/)
      end
    end
    describe 'when already signed' do
      before do
      stub_get('/bank_accounts/ban12345').to_return(
        body:    fixture('bank_account.json'),
        headers: {content_type: 'application/json; charset=utf-8'})

      stub_put('/bank_accounts/ban12345/generate_signature_request').to_return(
        status:  409,
        body: { error: "already_signed",
                error_description: "Status: el mandato ya ha sido firmado"
        }.to_json,
        headers: {content_type: 'application/json; charset=utf-8'}
      )
      end
      it 'raises error' do
        bank_account = Besepa::BankAccount.find('ban12345')
        expect {
          bank_account.generate_signature_request
        }.to raise_error(Besepa::Errors::BesepaError,
                         /ya ha sido firmado/)
      end
    end
  end
end
