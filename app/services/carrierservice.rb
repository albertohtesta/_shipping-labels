module Carrierservice
  class SendSolicitude

   def self.send(data, endpoint, token)
	 	datos = data
		begin
			response = RestClient.post endpoint, datos, 
			{ content_type: :json, accept: :json, :Authorization => "Token #{token}" }
		rescue RestClient::ServiceUnavailable
			return nil
		end
   end

  end

  class Address_from
  	attr_accessor :name, :street1, :city, :province, :postal_code, :country_code
  end

  class Address_to
  	attr_accessor :name, :street1, :city, :province, :postal_code, :country_code
  end

  class Data_parcels
  	attr_accessor :length, :width, :height, :dimensions_unit, :weight, :weight_unit
  end

  class Shipment
  	attr_accessor :address_from, :address_to, :parcels
  end

  class CarrierServiceCall
  	attr_accessor :shipment
  end

end
