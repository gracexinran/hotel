require_relative "test_helper"

describe "HotelData class" do
  let(:hoteldata){
    Hotel::HotelData.new(id: 100)
  }

  describe "initialize" do   
    it "establishes the base data structures when instantiated" do
      expect(hoteldata).must_be_instance_of Hotel::HotelData
      expect(hoteldata.id).must_be_instance_of Integer
    end
  end
  
  describe "validate_num" do
    it "raises ArgumentError if room id is invalid" do
      [nil, 0, -1, '1'].each do |id|
        expect{
          Hotel::HotelData.new(id: id)
        }.must_raise ArgumentError
      end
    end
  end
  
end