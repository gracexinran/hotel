require_relative "test_helper"

describe "Reservation" do 
  let(:reservation) {
    Hotel::Reservation.new(id: 7, room_id: 7, start_date: Date.today, end_date: Date.today + 1)
  }
  let(:block_reservation) {
    Hotel::Reservation.new(id: 8, block: Hotel::HotelSystem.new.rooms[1..3], start_date: Date.today, end_date: Date.today + 1, room_rate: 180)
  }
  
  describe "initialize" do 
    it "establishes the base data structures when instantiated" do
      expect(reservation).must_be_instance_of Hotel::Reservation
      expect(reservation.id).must_be_instance_of Integer
      expect(reservation.start_date).must_be_instance_of Date
      expect(reservation.end_date).must_be_instance_of Date
      expect(reservation.cost).must_be_instance_of Integer
      
      expect(block_reservation.block).must_be_instance_of Array
    end
    
    it "raises ArgumentError if reservation id is invalid" do
      [nil, 0, -1, '1'].each do |id|
        expect{
          Hotel::Reservation.new(id: id, start_date: Date.today, end_date: Date.today + 1)
        }.must_raise ArgumentError
      end
    end
    
    it "raises ArgumentError if room, room_id and block are all nil" do 
      expect{
        Hotel::Reservation.new(id: 7, start_date: Date.today, end_date: Date.today + 1)
      }.must_raise ArgumentError
    end
    
    it "raises ArgumentError if start date or end date is nil" do 
      expect{
        Hotel::Reservation.new(id: 7, room_id: 7, start_date: Date.today, end_date: nil)
      }.must_raise ArgumentError
    end
    
    it "raises ArgumentError if start date is before today" do 
      expect{
        Hotel::Reservation.new(id: 7, room_id: 7,start_date: Date.new(2019, 9, 2), end_date: Date.new(2019, 9, 3))
      }.must_raise ArgumentError
    end
    
    it "assigns a cost for each reservation" do 
      cost_room = (reservation.end_date - reservation.start_date).to_i * reservation.room_rate
      
      expect(reservation.cost).must_equal cost_room

      cost_block = (block_reservation.end_date - block_reservation.start_date).to_i * block_reservation.room_rate * block_reservation.block.length
      
      expect(block_reservation.cost).must_equal cost_block
      p block_reservation
    end
  end
  
  describe "connect_reservation" do 
    it "adds reservation to the reservation list of this room" do
      room = Hotel::HotelSystem.new.rooms.find{|room| room.id == reservation.room_id}
      reservations_before_connect = room.reservations.dup  
      reservation.connect_reservation(room)
      reservations_after_connect = room.reservations
      
      expect(reservations_after_connect.length).must_equal reservations_before_connect.length + 1
      
      expect(reservations_after_connect.last).must_equal reservation
    end
    
  end
  
  
end