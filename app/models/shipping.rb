class Shipping < ApplicationRecord
	belongs_to :solicitude
	belongs_to :carrier
  	validates_presence_of :name_from, :street_from, :city_from, :province_from, :postal_code_from, 
  	:countr_code_from, :name_to, :street_to, :city_to, :province_to, :postal_code_to, :countr_code_to, 
  	:length, :width, :height, :dimensions_unit, :weight, :weight_unit
end