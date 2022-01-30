class Solicitude < ApplicationRecord
	has_many :shippings
	validates_presence_of :fecha
end
