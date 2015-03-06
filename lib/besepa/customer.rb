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
            
    def add_subscription(starts_at, product_code, bank_account_code, setup_fee=0)
      params = {:starts_at => starts_at, :product_id => product_code, :bank_account_id => bank_account_code}
      params[:setup_fee] = setup_fee if setup_fee
      Subscription.create( params, {:customer_id => id} )
    end

    def add_bank_account(iban, bic, bank_name=nil, scheme='CORE', mandate_signature_date=nil, mandate_ref=nil, used=false)
      params = {:iban => iban, :bic => bic }
      if mandate_signature_date
        params[:mandate] = {scheme: scheme, used: used}
        params[:mandate][:signed_at] = mandate_signature_date if mandate_signature_date
        params[:mandate][:reference] = mandate_ref if mandate_ref
      end
      params[:bank_name] = bank_name if bank_name
      BankAccount.create( params, {:customer_id => id} )
    end
    
    def add_debit(debtor_bank_account_id, reference, description, amount, collect_at, creditor_account_id=nil, metadata=nil)
      params = {:reference => reference, :description => description, :debtor_bank_account_id => debtor_bank_account_id,
                :amount => amount, :collect_at => collect_at}
      params[:creditor_account_id] = creditor_account_id if creditor_account_id
      params[:metadata] = metadata if metadata
      Debit.create( params, {:customer_id => id} )
    end
    
  end
end