module Besepa

  class Customer < Besepa::Resource
    
    include Besepa::ApiCalls::List
    include Besepa::ApiCalls::Create
    include Besepa::ApiCalls::Update
    include Besepa::ApiCalls::Destroy
        
    FIELDS = [:id, :name, :taxid, :reference,
              :contact_name, :contact_email, :contact_phone, :contact_language,
              :address_street, :address_city, :address_postalcode, :address_state, :address_country,
              :status]
    
    FIELDS.each do |f|
      attr_accessor f
    end
    
    def bank_accounts
      BankAccount.all( {:customer_id => id} )
    end
    
    def debits
      Debit.all( {:customer_id => id} )
    end
    
    def subscriptions
      Subscription.all( {:customer_id => id} )
    end

    def add_bank_account(iban, bic, bank_name=nil)
      params = {:iban => iban, :bic => bic }
      params[:bank_name] = bank_name if bank_name
      BankAccount.create( params, {:customer_id => id} )
    end
    
    def add_debit(mandate_id, reference, description, amount, collect_at, creditor_account_id=nil, metadata=nil)
      params = {:reference => reference, :description => description, :mandate_id => mandate_id,
                :amount => amount, :collect_at => collect_at}
      params[:creditor_account_id] = creditor_account_id if creditor_account_id
      params[:metadata] = metadata if metadata
      Debit.create( params, {:customer_id => id} )
    end
    
  end
end