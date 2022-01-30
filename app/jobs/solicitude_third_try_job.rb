class SolicitudeThirdTryJob < ApplicationJob
  queue_as :default
  include Interfaceable

  def perform(shipping)
      getResponse(shipping)
      # fin de los intentos por alcanzar el server
      if shipping.status == "200"
        downloadPdf(shipping)
      else
      	solicitude = shipping.solicitude
      	solicitude.status= 'error'
      	solicitude.save
      end
  end

end
