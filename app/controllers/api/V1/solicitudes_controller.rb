module Api
  module V1
    class SolicitudesController < ApplicationController
      require 'rubygems'
      require 'zip'

      skip_before_action :verify_authenticity_token

      def create
        solicitude = crea_solicitud_con_shippings()
        if solicitude.save      
          render json: { message: "Created", id_solicitud: solicitude.id }, status: :created
        else
          render json: { errors: solicitude.errors }, status: :unprocessable_entity
        end
      end


      def crea_solicitud_con_shippings
        nueva_solicitud = Solicitude.new(fecha: Date.today, tracking_number: '11111', status: 'pending')
        params[:_json].each_with_index do |r, i|
          nueva_solicitud = get_data_from_params(nueva_solicitud, i)
        end
        return nueva_solicitud
      end

      private

      def get_data_from_params(nueva_solicitud, i)

          carrier_id = Carrier.find_by(name: params[:_json][i][:carrier]).id
          if !carrier_id
            carrier_id = 1
          end
          name_from = params[:_json][i][:shipment][:address_from][:name]
          street_from = params[:_json][i][:shipment][:address_from][:street1]
          city_from = params[:_json][i][:shipment][:address_from][:city]
          province_from = params[:_json][i][:shipment][:address_from][:province]
          postal_code_from = params[:_json][i][:shipment][:address_from][:postal_code]
          countr_code_from = params[:_json][i][:shipment][:address_from][:country_code]

          name_to = params[:_json][i][:shipment][:address_to][:name]
          street_to = params[:_json][i][:shipment][:address_to][:street1]
          city_to = params[:_json][i][:shipment][:address_to][:city]
          province_to = params[:_json][i][:shipment][:address_to][:province]
          postal_code_to = params[:_json][i][:shipment][:address_to][:postal_code]
          countr_code_to = params[:_json][i][:shipment][:address_to][:country_code]

          dimensions = params[:_json][i][:shipment][:parcels]
          length = dimensions[0][:length]
          width = dimensions[0][:width]
          height = dimensions[0][:height]
          dimensions_unit = dimensions[0][:dimensions_unit]
          weight = dimensions[0][:weight]
          weight_unit = dimensions[0][:weight_unit]
          # añade el shipping a la solicitud
          ship = nueva_solicitud.shippings.new(carrier_id: carrier_id, name_from: name_from, street_from: street_from, city_from: city_from, province_from: province_from, postal_code_from: postal_code_from, countr_code_from: countr_code_from, name_to: name_to, street_to: street_to, city_to: city_to, province_to: province_to, postal_code_to: postal_code_to, countr_code_to: countr_code_to, length: length, width: width, height: height, dimensions_unit: dimensions_unit, weight: weight, weight_unit: weight_unit)
          return nueva_solicitud

      end
        
    end
  end
end