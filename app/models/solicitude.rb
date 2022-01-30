class Solicitude < ApplicationRecord
	has_many :shippings
	validates_presence_of :fecha

	before_create do
		self.status = 'processing'
	end
end
