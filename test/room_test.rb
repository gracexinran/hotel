require_relative "test_helper"

describe "Room" do 
  
  describe "initialize" do 
    let(:room) {
      Hotel::Room.new(id: 7)
    }
    
    it "establishes the base data structures when instantiated" do
      expect(room.reservations).must_be_instance_of Array
      expect(room.id).must_be_instance_of Integer
      
    end
    
    it "raises ArgumentError if room id is invalid" do
      [nil, 0, -1, '1'].each do |id|
        expect{
          Hotel::Room.new(id: id)
        }.must_raise ArgumentError
      end
    end
    
  end
  
  
end