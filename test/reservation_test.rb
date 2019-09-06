require_relative "test_helper"

describe "Reservation" do 
  let(:reservation) {
    Hotel::Reservation.new(id: 7, room_ids: [7], start_date: Date.today, end_date: Date.today + 1)
  }
  let(:block_reservation) {
    Hotel::Reservation.new(id: 8, block: Hotel::HotelSystem.new.rooms.slice(0, 3), start_date: Date.today, end_date: Date.today + 1, room_rate: 180)
  }
  
  describe "initialize" do 
    it "establishes the base data structures when instantiated" do
      
      [reservation, block_reservation].each do |reservation|
        expect(reservation).must_be_instance_of Hotel::Reservation
        expect(reservation.id).must_be_instance_of Integer
        expect(reservation.start_date).must_be_instance_of Date
        expect(reservation.end_date).must_be_instance_of Date
        expect(reservation.cost).must_be_instance_of Integer
      end
      
      expect(reservation.room_ids).must_be_instance_of Array
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
    
    it "assigns a cost for each reservation" do 
      range = reservation.range(reservation.start_date, reservation.end_date)
      reservation_cost = 0
      reservation.room_ids.each do |room_id|
        room = reservation.find_room(room_id)
        reservation_cost += room.rate * range
      end
      expect(reservation.cost).must_equal reservation_cost
      
      room_num = block_reservation.block.length
      range = block_reservation.range(block_reservation.start_date, block_reservation.end_date)
      cost_block = range * block_reservation.room_rate * room_num
      
      expect(block_reservation.cost).must_equal cost_block
      
    end
  end
  
  describe "range" do 
    it "returns an integer of reservation range" do 
      start_date = reservation.start_date
      end_date = reservation.end_date
      range = (end_date - start_date).to_i
      
      expect(reservation.range(start_date, end_date)).must_be_instance_of Integer
      expect(reservation.range(start_date, end_date)).must_equal range
    end
    
    it "raises ArgumentError if start date or end date is nil" do 
      expect{
        Hotel::Reservation.new(id: 7, room_ids: [7], start_date: Date.today, end_date: nil)
      }.must_raise ArgumentError
      
      expect{
        Hotel::Reservation.new(id: 7, room_ids: [7], start_date: nil, end_date: Date.today + 3)
      }.must_raise ArgumentError
      
    end
    
    it "raises ArgumentError if start date is before today" do 
      expect{
        Hotel::Reservation.new(id: 7, room_ids: [7],start_date: Date.new(2019, 9, 2), end_date: Date.new(2019, 9, 3))
      }.must_raise ArgumentError
    end
    
  end
  
  describe "find_room" do
    it "find the room with room_id" do 
      reservation.room_ids.each do |room_id|
        room_find = reservation.find_room(room_id)
        
        expect(room_find).must_be_instance_of Hotel::Room
        expect(room_find.id).must_equal room_id
        
      end
    end
  end
  
  describe "connect_reservation" do 
    it "adds reservation to the reservation list of this room" do
      rooms = reservation.room_ids.map {
        |room_id| Hotel::HotelSystem.new.rooms.find {|room| room.id == room_id}
      }
      
      rooms_reservations_before_connect = rooms.map {
        |room| room.reservations.dup 
      }
      
      reservation.connect_reservation(rooms)
      
      rooms.each_with_index do |room, index|
        reservations_after_connect = room.reservations
        
        expect(reservations_after_connect.length).must_equal rooms_reservations_before_connect[index].length + 1
        
        expect(reservations_after_connect.last).must_equal reservation
      end
    end
    
  end
  
  
end