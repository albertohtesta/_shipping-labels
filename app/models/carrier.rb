class Carrier < ApplicationRecord
	
	has_many :shippings
	validates_presence_of :name, :endpoint, :token

end