require 'rails_helper'

describe Shipping do

  it { should belong_to(:carrier) }
  it { should belong_to(:solicitude) }

  it { should validate_presence_of(:name_from) }
  it { should validate_presence_of(:street_from) }
  it { should validate_presence_of(:city_from) }
  it { should validate_presence_of(:province_from) }
  it { should validate_presence_of(:postal_code_from) }
  it { should validate_presence_of(:countr_code_from) }  

  it { should validate_presence_of(:name_to) }
  it { should validate_presence_of(:street_to) }
  it { should validate_presence_of(:city_to) }
  it { should validate_presence_of(:province_to) }
  it { should validate_presence_of(:postal_code_to) }
  it { should validate_presence_of(:countr_code_to) }

  it { should validate_presence_of(:length) }
  it { should validate_presence_of(:width) } 
  it { should validate_presence_of(:height) }
  it { should validate_presence_of(:dimensions_unit) }
  it { should validate_presence_of(:weight) }
  it { should validate_presence_of(:weight_unit) }


end