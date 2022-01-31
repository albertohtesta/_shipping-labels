class SolicitudeJob < ApplicationJob

  require "down"
  queue_as :default
  include Interfaceable

  def perform(shipping)
      getResponse(shipping)
      if shipping.status != "200"
        # manda a status 2 processing
        SolicitudeSecondTryJob.set(wait_until: 1.minutes.from_now(Time.now)).perform_later(shipping)
      else 
        downloadPdf(shipping)
      end
	end

end
