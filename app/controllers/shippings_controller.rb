class ShippingsController < ApplicationController

	def index
		@shippings = Shipping.where(solicitude_id: params[:solicitude_id])
	end
end
