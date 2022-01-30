class SolicitudesController < ApplicationController

	def index
		@solicitudes = Solicitude.all
	end

	def show
		@solicitude = Solicitude.where(id: params[:id]).first
	end

	private

	def solicitude_params
		params.require(:solicitude).permit(:id)
	end

end