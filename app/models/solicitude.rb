class Solicitude < ApplicationRecord
	has_many :shippings
	validates_presence_of :fecha

	before_create do
		self.status = 'processing'
	end

	after_create_commit do
		self.shippings.each do |shipping|
	  		SolicitudeJob.perform_now(shipping)
	  	end
	end

end
