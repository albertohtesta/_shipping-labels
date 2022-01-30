class CarriersController < ApplicationController

	before_action :set_carrier, only: [:show, :edit, :update]
	def index
		@carriers = Carrier.all
	end

	def new
		@carrier = Carrier.new
	end

	def show
	end

	def edit
	end

	def update
		if @carrier.update(carrier_params)
			flash[:notice] = 'El carrier se ha actualizado'
			redirect_to carrier_path(@carrier)
		else
			render :edit
		end
	end

	def create
		@carrier = Carrier.new(carrier_params)

		if @carrier.save
			flash[:notice] = 'El carrier se ha creado'
			redirect_to carriers_path
		else
			render :new
		end
	end

	private

	def set_carrier
		@carrier = Carrier.where(id: params[:id]).first
	end

	def carrier_params
		params.require(:carrier).permit(:name, :endpoint, :token)
	end

end