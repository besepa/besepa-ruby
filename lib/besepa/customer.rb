module Besepa
  class Customer < Besepa::Resource

    include Besepa::ApiCalls::List
    include Besepa::ApiCalls::Search
    include Besepa::ApiCalls::Create
    include Besepa::ApiCalls::Update
    include Besepa::ApiCalls::Destroy

    FIELDS = [:id, :name, :taxid, :reference,
              :contact_name, :contact_email, :contact_phone, :contact_language,
              :address_street, :address_city, :address_postalcode, :address_state, :address_country,
              :status, :created_at]

    FIELDS.each do |f|
      attr_accessor f
    end

    # Customer's bank accounts
    #
    # @return collection of Besepa::BankAccount
    def bank_accounts
      BankAccount.all( {:customer_id => id} )
    end

    # Debits sent to this customer
    #
    # @return collection of Besepa::Debits
    def debits
      Debit.all( {:customer_id => id} )
    end

    # Subscriptions from this customer
    #
    # @return collection of Besepa::Subscription
    def subscriptions
      Subscription.all( {:customer_id => id} )
    end

    # List of groups this customers blongs to
    #
    # @return collection of Besepa::Group
    def groups
      Group.all( {:customer_id => id} )
    end

    # Adds this customer to the given group
    #
    # @param group_id The ID of the group to which this user should be added
    #
    # @return true if user is now a member of the group
    def add_to_group(group_id)
      response = post "#{self.class.api_path}/#{id}/memberships/#{group_id}"
      response['response'].select{|c| c['id'] == group_id}.any?
    end

    # Removed this customer from the given group
    #
    # @param group_id The ID of the group from which this user should be removed
    #
    # @return true if user is no longer a member of the group
    def remove_from_group(group_id)
      response = delete "#{self.class.api_path}/#{id}/memberships/#{group_id}"
      response['response'].select{|c| c['id'] == group_id}.empty?
    end

    # Creates a new subscription for this customer
    #
    # @param starts_at The date this subscription should start (Format: YYYY-MM-DD)
    # @param product_code The ID of the product the customer is subscribing to
    # @param bank_account_code The ID of the bank account where debits should be sent to
    # @param setup_fee Initial set-up fee. Optional, default: 0
    # @param metadata Optional Hash with metadata related to this subscription, if any.
    #
    # @return new created Besepa::Subscription
    def add_subscription(starts_at, product_code, bank_account_code, setup_fee=0, metadata=nil)
      params = {:starts_at => starts_at, :product_id => product_code, :debtor_bank_account_id => bank_account_code}
      params[:setup_fee] = setup_fee if setup_fee
      params[:metadata] = metadata if metadata
      Subscription.create( params, {:customer_id => id} )
    end

    # Adds a bank account to this customer.
    # IBAN and BIC are the only mandatory fields. If you already have the mandate signed, you can pass mandate
    # detail's and account will be activated by default. Otherwise BankAccount will be marked as inactive (not usable
    # for creating debits or subscriptions) until mandate is signed. BankAccount includes mandate's info, including
    # signature URL.
    #
    # @param iban
    # @param bic
    # @param bank_name
    # @param mandate_options options to configure mandate
    #        - scheme: CORE|COR1|B2B. Default: CORE
    #        - signature_date: Date in which this mandate was signed if already signed (Format: YYYY-MM-DD)
    #        - reference: Mandate's reference. If none, Besepa will create one.
    #        - used: Says if this mandate has already been used or not.
    #        - signature_type: Signature to be used: checkbox|sms|biometric
    #        - phone_number: Phone number where the signature SMS will be sent in case signature_type==sms is used.
    #        - type: ONETIME | RECURRENT. Default: RECURRENT
    #        - redirect_after_signature: URL the user should be redirect to after mandate is signed. Default: Besepa's thank you page
    #
    # @return new created Besepa::BankAccount
    def add_bank_account(iban, bic=nil, bank_name=nil, mandate_options={})
      params = {:iban => iban }
      params[:bank_name] = bank_name if bank_name
      params[:bic] = bic if bic

      params[:mandate] = {      scheme: (mandate_options[:scheme] || "CORE"),
                                  used:  (mandate_options[:used] || false),
                          mandate_type: (mandate_options[:type] || "RECURRENT") }

      if mandate_options[:signature_date]
        params[:mandate][:signed_at] = mandate_options[:signature_date]
        params[:mandate][:reference] = mandate_options[:reference] if mandate_options[:reference]
      else
        params[:mandate][:signature_type] = mandate_options[:signature_type] || 'checkbox'
        params[:mandate][:phone_number] = mandate_options[:phone_number] if mandate_options[:phone_number]
      end
      params[:mandate][:redirect_after_signature] = mandate_options[:redirect_after_signature] if mandate_options[:redirect_after_signature]

      BankAccount.create( params, {:customer_id => id} )
    end

    # Generates a direct debit that will be charged to this customer.
    #
    # @param debtor_bank_account_id Customer's BankAccount code this Debit shouyd be charged to.
    # @param reference Debit's unique reference
    # @param description Debit's description. Customer will see this in his Bank's statements
    # @param amount Amount to be charged. Integer, last two digits represent decimals: 10.25 should be 1025
    # @param collect_at Date in which the charge should be made (Format: YYYY-MM-DD).
    # @param creditor_account_id Business' BankAccount that should receive the money. If none passed, account marked as default in Besepa's dashboard will be used.
    # @param metadata Optional Hash with metadata related to this debit, if any.
    #
    # @return new created Besepa::Debit
    def add_debit(debtor_bank_account_id, reference, description, amount, collect_at, creditor_account_id=nil, metadata=nil)
      params = {:reference => reference, :description => description, :debtor_bank_account_id => debtor_bank_account_id,
                :amount => amount, :collect_at => collect_at}
      params[:creditor_bank_account_id] = creditor_account_id if creditor_account_id
      params[:metadata] = metadata if metadata
      Debit.create( params, {:customer_id => id} )
    end
  end
end
