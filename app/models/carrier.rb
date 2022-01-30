class Carrier < ApplicationRecord
	validates_presence_of :name, :endpoint, :token
end