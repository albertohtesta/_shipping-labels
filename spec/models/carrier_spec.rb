require 'rails_helper'

describe Carrier do
  
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:endpoint) }
  it { should validate_presence_of(:token) }
  it { should have_many(:shippings) }

end