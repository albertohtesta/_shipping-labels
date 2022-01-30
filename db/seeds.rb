# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Shipping.destroy_all
Solicitude.destroy_all
Carrier.destroy_all
Carrier.create(name: "fake_carrier", endpoint: "https://fake-carrier-api.skydropx.com/v1/labels",
	token: "vgEOaYn0LItk5K9FBEP9j9EUjZwcZvvL")