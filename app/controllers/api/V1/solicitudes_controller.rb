module Api
  module V1
    class SolicitudesController < ApplicationController
      require 'rubygems'
      require 'zip'

      skip_before_action :verify_authenticity_token

      def create
        # primer request
        if params[:_json] != nil && params[:_json].length > 0
          solicitude = crea_solicitud_con_shippings()
          if solicitude.save      
            render json: { message: "Created", id_solicitud: solicitude.id }, status: :created
          else
            render json: { errors: solicitude.errors }, status: :unprocessable_entity
          end
        else
          render json: { errors: 'No data' }, status: :unprocessable_entity
        end
      end

      def status
        # 2o. request da el estaus y la url
        solicitude = Solicitude.where(id: params[:id]).first
        if solicitude
          update_status(solicitude)
           if solicitude     
            render json: { status: solicitude.status, url: solicitude.status == "completed" ? "http://localhost:3000/api/v1/download_pdf?solicitud_id=#{solicitude.id}" : "" }, status: :ok
          else
            render json: { errors: solicitude.errors }, status: :unprocessable_entity
          end
        else
          render json: { errors: "No existe la solicitud" }, status: :unprocessable_entity
        end
      end

      def download_pdf
        # 3er request descarga el zip
        solicitude = Solicitude.where(id: params[:solicitud_id]).first
        if solicitude
          send_file "#{Rails.root}/public/zips/#{params[:solicitud_id]}.zip", type: "application/zip", x_sendfile: true
        else
          render json: { errors: "No existe la solicitud" }, status: :unprocessable_entity
        end
      end

      private

      def update_status(solicitude)

        return solicitude unless (solicitude.status != "completed" && solicitude.status != "error")

          if solicitude.status = 'processing'
            solicitude.status = 'completed'
            create_zip(solicitude)
          else
            solicitude.status = 'error'
          end
          if solicitude.save
            return solicitude
          else
            return nil
          end 
       
      end

      def create_zip(solicitude)

        folder_to_zip = "#{Rails.root}/public/pdfs"
        input_filenames = []
        solicitude.shippings.each do |ship|
          file = "#{solicitude.id}-#{ship.id}.pdf"
          input_filenames << file
        end

        zipfile_name = "#{Rails.root}/public/zips/#{solicitude.id}.zip"       

        Zip::File.open(zipfile_name, create: true) do |zipfile|
          input_filenames.each do |filename|
            # Two arguments:
            # - The name of the file as it will appear in the archive
            # - The original file, including the path to find it
            zipfile.add(filename, File.join(folder_to_zip, filename))
          end
          zipfile.get_output_stream("myFile") { |f| f.write "myFile contains just this" }
        end

      end

      def crea_solicitud_con_shippings
        nueva_solicitud = Solicitude.new(fecha: Date.today, tracking_number: '11111', status: 'pending')
        params[:_json].each_with_index do |r, i|
          nueva_solicitud = get_data_from_params(nueva_solicitud, i)
        end
        return nueva_solicitud
      end

      def get_data_from_params(nueva_solicitud, i)

          if !(params[:_json][i][:carrier])
            carrier = Carrier.where(name: "fake_carrier").first
          else
            carrier = Carrier.where(name: params[:_json][i][:carrier]).first
            if !carrier
              carrier = Carrier.where(name: "fake_carrier").first
            end
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
          ship = nueva_solicitud.shippings.new(carrier: carrier, name_from: name_from, street_from: street_from, city_from: city_from, province_from: province_from, postal_code_from: postal_code_from, countr_code_from: countr_code_from, name_to: name_to, street_to: street_to, city_to: city_to, province_to: province_to, postal_code_to: postal_code_to, countr_code_to: countr_code_to, length: length, width: width, height: height, dimensions_unit: dimensions_unit, weight: weight, weight_unit: weight_unit)
          return nueva_solicitud

      end
        
    end
  end
end