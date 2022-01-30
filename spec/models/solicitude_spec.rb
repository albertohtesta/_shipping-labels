require 'rails_helper'

describe Solicitude do
  
  it { should validate_presence_of(:fecha) }
  it { should have_many(:shippings) }

end