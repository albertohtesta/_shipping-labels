module Interfaceable
  extend ActiveSupport::Concern

  def getResponse(shipping)
      object_for_carrier = format_object_for_carrier(shipping)
      endpoint = shipping.carrier.endpoint
      token = shipping.carrier.token
      @response = Carrierservice::SendSolicitude.send(object_for_carrier, endpoint, token)
      check_response_and_save_shippings_status(@response, shipping)
  end

  def downloadPdf(shipping)
        solicitude = shipping.solicitude
        Down.download(shipping.label_url, destination: "#{Rails.root}/public/pdfs/#{solicitude.id}-#{shipping.id}.pdf")
        #solicitude.label_pdfs.attach(io: File.open("#{Rails.root}/public/pdfs/#{solicitude.id}-#{shipping.id}.pdf"), filename: "#{solicitude.id}-#{shipping.id}.pdf")
  end

  def check_response_and_save_shippings_status(response, shipping)
    if response
      shipping.status = response.code.to_s
      resp = JSON.parse(response, symbolize_names: true)
        shipping.label_url = resp[:data][:attributes][:file_url]
        shipping.id_response = resp[:data][:id]
        shipping.shipment_id = resp[:data][:attributes][:shipment_id]
        shipping.tracking_number = resp[:data][:attributes][:tracking_number]
    else
      shipping.status = "503"
    end
    shipping.save
  end

  def format_object_for_carrier(shipping)

    address_from = Carrierservice::Address_from.new()
    address_from.name = shipping.name_from
    address_from.street1 = shipping.street_from
    address_from.city = shipping.city_from
    address_from.province = shipping.province_from
    address_from.postal_code = shipping.postal_code_from
    address_from.country_code = shipping.countr_code_from

    address_to = Carrierservice::Address_to.new()    
    address_to.name = shipping.name_to
    address_to.street1 = shipping.street_to
    address_to.city = shipping.city_to
    address_to.province = shipping.province_to
    address_to.postal_code = shipping.postal_code_to
    address_to.country_code = shipping.countr_code_to

    parcels = []
    data_parcels = Carrierservice::Data_parcels.new
    data_parcels.length = shipping.length
    data_parcels.width = shipping.width
    data_parcels.height = shipping.height
    data_parcels.dimensions_unit = shipping.dimensions_unit
    data_parcels.weight = shipping.weight
    data_parcels.weight_unit = shipping.weight_unit
    parcels << data_parcels

    shipment = Carrierservice::Shipment.new()
    shipment.address_from = address_from
    shipment.address_to = address_from
    shipment.parcels = parcels
    object_formatted = Carrierservice::CarrierServiceCall.new()
    object_formatted.shipment = shipment
    return object_formatted.to_json
  end
end