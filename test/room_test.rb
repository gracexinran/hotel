require_relative "test_helper"

describe "Room" do 
  let(:room) {
    Hotel::Room.new(id: 1)
  }
  
  let(:reservation) {
    Hotel::Reservation.new(id: 1, room_ids: [room.id], start_date: Date.today, end_date: Date.today + 1)
  }
  
  describe "initialize" do   
    it "establishes the base data structures when instantiated" do
      expect(room.reservations).must_be_instance_of Array
      expect(room.id).must_be_instance_of Integer
      
    end
  end
  
  describe "validate_num" do
    it "raises ArgumentError if room id is invalid" do
      [nil, 0, -1, '1'].each do |id|
        expect{
          Hotel::Room.new(id: id)
        }.must_raise ArgumentError
      end
    end
  end
  
  describe "add reservation" do 
    it "adds reservation to the array of reservations of specific room" do
      
      before_add_reservation = room.reservations.dup
      
      room.add_reservation(reservation)
      
      expect(room.reservations.length).must_equal before_add_reservation.length + 1
      
    end
  end
  
  describe "status" do 
    it "checks the availablility for the room" do 
      start_date = reservation.start_date
      end_date = reservation.end_date
      
      expect(room.status(start_date, end_date)).must_equal true
      
      room.add_reservation(reservation)
      
      expect(room.status(start_date, end_date)).must_equal false
      
    end
    
  end
end