require_relative "test_helper"

ROOM_NUM_TOTAL = 20
ROOM_RATE = 200

describe "HotelSystem class" do
  before do 
    @hotel_system = Hotel::HotelSystem.new
    
    reservation_1 = @hotel_system.make_reservation(Date.today, Date.today + 3)
    reservation_2 = @hotel_system.make_reservation(Date.today, Date.today + 3)
    reservation_3 = @hotel_system.make_reservation(Date.today + 5, Date.today + 6)
  end
  
  describe "initialize" do
    it "is an instance of HotelSystem" do 
      expect(@hotel_system).must_be_instance_of Hotel::HotelSystem
    end
    
    it "establishes the base data structures when instantiated" do
      [:rooms, :reservations].each do |prop|
        expect(@hotel_system).must_respond_to prop
      end
      
      expect(@hotel_system.rooms).must_be_kind_of Array
      @hotel_system.rooms.each do |room|
        expect(room).must_be_instance_of Hotel::Room
      end
      
      expect(@hotel_system.reservations).must_be_kind_of Array
    end
    
    it "contains 20 rooms in total" do 
      expect(@hotel_system.rooms.length).must_equal ROOM_NUM_TOTAL
    end
  end
  
  describe "make_reservation" do
    let(:block_reservation){
      start_date = Date.today
      end_date = start_date + 1
      @hotel_system.make_reservation(start_date, end_date, 5, 190)
    }
    
    it "makes a new reservation and adds the new created reservation to reservations" do
      reservations_before_request = @hotel_system.reservations.length.dup
      
      start_date = Date.today
      end_date = start_date + 1
      
      reservation = @hotel_system.make_reservation(start_date, end_date)
      
      expect(reservation).must_be_instance_of Hotel::Reservation
      
      reservations_after_request = @hotel_system.reservations.length
      
      expect(reservations_after_request).must_equal reservations_before_request + 1
    end
    
    it "makes a new reservation for block if a discounted room rate is provided" do
      
      range = (block_reservation.end_date - block_reservation.start_date).to_i
      
      cost_per_night_per_room = block_reservation.cost / (range * block_reservation.block.length)
      
      expect(block_reservation).must_be_instance_of Hotel::Reservation
      
      expect(cost_per_night_per_room).must_be :<, ROOM_RATE
    end
    
    it "changes the status of rooms to unavailable after making a noraml reservation" do
      start_date = Date.today
      end_date = Date.today + 3

      room_num_for_reservation = 1

      available_rooms = @hotel_system.available_rooms(start_date, end_date)

      rooms = available_rooms.slice(0, room_num_for_reservation).dup
      
      rooms.each {
        |room| expect(room.status(start_date, end_date)).must_equal true
      }
      
      reservation = @hotel_system.make_reservation(start_date, end_date)
      
      reservation.rooms.each {
        |room| expect(room.status(start_date, end_date)).must_equal false
      }

    end

    it "changes the status of all rooms in the block to unavailable after making the block reservation" do
      
      block_reservation.block.each do |room| 
        expect(room.status(block_reservation.start_date, block_reservation.end_date)).must_equal false
      end
      
    end
    
    it "makes a normal reservation for multiple rooms if a discounted room rate is not provided for block reservation" do
      start_date = Date.today
      end_date = start_date + 1
      range = (end_date - start_date).to_i
      
      reservation = @hotel_system.make_reservation(start_date, end_date, 5)
      
      expect(reservation).must_be_instance_of Hotel::Reservation
      
      cost_per_night = reservation.cost / range
      
      rooms_rate_sum = 0
      reservation.rooms.each do |room|
        rooms_rate_sum += room.rate
      end
      
      expect(reservation).must_be_instance_of Hotel::Reservation
      expect(cost_per_night).must_equal rooms_rate_sum
      
    end
  end
  
  describe "cost" do 
    it "raises ArgumentError if the reservation provided is not Date class" do 
      reservation_id = '2'
      expect{@hotel_system.cost(reservation_id)}.must_raise ArgumentError
    end
    
    it "must return an integer of the cost of a reservation" do 
      reservation_id = 2 
      
      cost_of_reservation = @hotel_system.reservations.find {|reservation| reservation.id == reservation_id}.cost
      
      expect(@hotel_system.cost(reservation_id)).must_be_instance_of Integer
      expect(@hotel_system.cost(reservation_id)).must_equal cost_of_reservation
      
    end
  end
  
  describe "reservations_by_date" do 
    it "raises ArgumentError if the date provided is not Date class" do 
      date = "#{Date.today}"
      expect{@hotel_system.reservations_by_date(date)}.must_raise ArgumentError
    end
    
    it "lists all the reservations for a certain date" do 
      date = Date.today
      list = @hotel_system.reservations_by_date(date)
      expect(list).must_be_instance_of Array
      
      reservation_num = 0
      @hotel_system.reservations.each do |reservation|
        reservation_num += 1 if reservation.start_date == date
      end
      
      expect(list.length).must_equal reservation_num
      
      list.each do |reservation|
        expect(reservation).must_be_instance_of Hotel::Reservation
      end

    end
    
    it "returns nil if no reservation is found" do 
      date = Date.today + 20
      expect(@hotel_system.reservations_by_date(date)).must_be_nil
    end
    
  end
  
  describe "available_rooms" do
    it "returns all availabe rooms" do
      start_date = Date.today
      end_date = Date.today + 3
      
      rooms_available_status = @hotel_system.rooms.select {
        |room| room.status(start_date, end_date)
      }

      available_rooms = @hotel_system.available_rooms(start_date, end_date)

      expect(available_rooms.length).must_equal rooms_available_status.length

      available_rooms.each {
        |room| expect(room.status(start_date, end_date)).must_equal true
      }
      
    end
    
    # it "must raise exception if no available room is found" do 
    #   start_date = Date.today
    #   end_date = Date.today + 3

    #   18.times {
    #     @hotel_system.make_reservation(start_date, end_date)
    #   }
    #   expect{
    #     @hotel_system.make_reservation(start_date, end_date)
    #   }.must_raise StandardError
    # end
    
  end
  
  describe "available_block" do 
    it "returns the collection of rooms" do
      start_date = Date.today
      end_date = Date.today + 3
      block = @hotel_system.available_block(start_date, end_date, 5, 180)
      
      expect(block).must_be_instance_of Array
      
      block.each do |room|
        expect(room).must_be_instance_of Hotel::Room
        expect(room.status(start_date, end_date)).must_equal true
      end
      
    end
    
    it "raises exception if no available block is found" do 
      start_date = Date.today
      end_date = Date.today + 3
      
      3.times {
        @hotel_system.make_reservation(start_date, end_date, 5, 180)
      }
      
      expect{
        @hotel_system.make_reservation(start_date, end_date, 5, 180)
      }.must_raise StandardError
      
    end
  end
  
end