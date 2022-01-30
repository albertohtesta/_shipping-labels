require 'rails_helper'

describe 'SolicitudesController', type: :request do

  describe 'POST /create' do

    context 'when the request is null' do
      let(:seed_data) { }

      it 'returns no data' do
        Carrier.create(name: "fake_carrier", endpoint: "https://fake-carrier-api.skydropx.com/v1/labels", 
          token: "vgEOaYn0LItk5K9FBEP9j9EUjZwcZvvL")
        post '/api/v1/solicitudes#create', params: {_json: seed_data}
        expect(response.status).to eq(422)
      end
    end

    context 'when the request is invalid (no name_from)' do
      let(:seed_data) do
        [
          {
            "carrier": "fake_carrier",
            "shipment": {
              "address_from": {
                "street1": "Av. Principal #123",
                "city": "Azcapotzalco",
                "province": "Ciudad de México",
                "postal_code": "02900",
                "country_code": "MX"
              },
              "address_to": {
                "name": "Isabel Arredondo",
                "street1": "Av. Las Torres #123",
                "city": "Puebla",
                "province": "Puebla",
                "postal_code": "72450",
                "country_code": "MX"
              },
              "parcels": [
                {
                  "length": 40,
                  "width": 40,
                  "height": 40,
                  "dimensions_unit": "CM",
                  "weight": 5,
                  "weight_unit": "KG"
                }
              ]
            }
          }
        ]
      end
      it 'returns no data' do
        Carrier.create(name: "fake_carrier", endpoint: "https://fake-carrier-api.skydropx.com/v1/labels", 
          token: "vgEOaYn0LItk5K9FBEP9j9EUjZwcZvvL")
        post '/api/v1/solicitudes#create', params: {_json: seed_data}
        expect(response.status).to eq(422)
      end
    end

    context 'when the request is valid' do
      let(:seed_data) do
        [
          {
            "carrier": "fake_carrier",
            "shipment": {
              "address_from": {
                "name": "Fernando López",
                "street1": "Av. Principal #123",
                "city": "Azcapotzalco",
                "province": "Ciudad de México",
                "postal_code": "02900",
                "country_code": "MX"
              },
              "address_to": {
                "name": "Isabel Arredondo",
                "street1": "Av. Las Torres #123",
                "city": "Puebla",
                "province": "Puebla",
                "postal_code": "72450",
                "country_code": "MX"
              },
              "parcels": [
                {
                  "length": 40,
                  "width": 40,
                  "height": 40,
                  "dimensions_unit": "CM",
                  "weight": 5,
                  "weight_unit": "KG"
                }
              ]
            }
          }
        ]
      end
      it 'returns message data and response status of Created' do
        Carrier.create(name: "fake_carrier", endpoint: "https://fake-carrier-api.skydropx.com/v1/labels", 
          token: "vgEOaYn0LItk5K9FBEP9j9EUjZwcZvvL")
        post '/api/v1/solicitudes#create', params: {_json: seed_data}
        expect(response.status).to eq(201)
        expect(JSON.parse(response.body)["message"]).to eq("Created")
        expect(Solicitude.first.shippings.first.name_from).to eq("Fernando López")             
      end
      it 'creates the solicitude record' do
        Carrier.create(name: "fake_carrier", endpoint: "https://fake-carrier-api.skydropx.com/v1/labels", 
          token: "vgEOaYn0LItk5K9FBEP9j9EUjZwcZvvL")
        post '/api/v1/solicitudes#create', params: {_json: seed_data}
        expect(Solicitude.first.shippings.first.name_from).to eq("Fernando López")             
      end
    end

  end

    describe 'GET /status' do
      context 'when the solicitude is valid' do

        it 'returns the status of the solicitude' do
          Carrier.create(name: "fake_carrier", endpoint: "https://fake-carrier-api.skydropx.com/v1/labels", 
          token: "vgEOaYn0LItk5K9FBEP9j9EUjZwcZvvL")
          Solicitude.create(fecha: Date.today, status: 'completed')
          id = Solicitude.first.id
          get '/api/v1/status', params: {"id": id}
          expect(['processing', 'error', 'completed'].include?(JSON.parse(response.body)["status"])).to be true
          expect(JSON.parse(response.body)["url"]).to eq("http://localhost:3000/api/v1/download_pdf?solicitud_id=#{id}")
        end

        it 'returns the url of the zip file' do
          Carrier.create(name: "fake_carrier", endpoint: "https://fake-carrier-api.skydropx.com/v1/labels", 
          token: "vgEOaYn0LItk5K9FBEP9j9EUjZwcZvvL")
          Solicitude.create(fecha: Date.today, status: 'completed')
          id = Solicitude.first.id
          get '/api/v1/status', params: {"id": id}
          expect(JSON.parse(response.body)["url"]).to eq("http://localhost:3000/api/v1/download_pdf?solicitud_id=#{id}")
        end
      end

      context 'when the solicitude is invalid' do

        it 'returns response unprocessable entity' do
          Carrier.create(name: "fake_carrier", endpoint: "https://fake-carrier-api.skydropx.com/v1/labels", 
          token: "vgEOaYn0LItk5K9FBEP9j9EUjZwcZvvL")
          Solicitude.create(fecha: Date.today, status: 'completed')
          id = Solicitude.first.id
          get '/api/v1/status', params: {"id": 999}
          expect(response.status).to eq(422)
        end

        it 'returns a text error' do
          Carrier.create(name: "fake_carrier", endpoint: "https://fake-carrier-api.skydropx.com/v1/labels", 
          token: "vgEOaYn0LItk5K9FBEP9j9EUjZwcZvvL")
          Solicitude.create(fecha: Date.today, status: 'completed')
          id = Solicitude.first.id
          get '/api/v1/status', params: {"id": 999}
          expect(JSON.parse(response.body)["errors"]).to eq("No existe la solicitud")
        end
      end
    end

end
