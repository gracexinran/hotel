require_relative "test_helper"

describe "HotelSystem class" do
  before do 
    @hotel_system = Hotel::HotelSystem.new
    
    reservation_1 = @hotel_system.make_reservation(Date.new(2019,9,9), Date.new(2019,9,12))
    reservation_2 = @hotel_system.make_reservation(Date.new(2019,9,9), Date.new(2019,9,10))
    reservation_3 = @hotel_system.make_reservation(Date.new(2019,9,15), Date.new(2019,9,16))
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
      expect(@hotel_system.rooms.length).must_equal 20
    end
  end
  
  describe "make_reservation" do
    it "adds the new created reservation to reservations and returns an instance of Reservation" do
      reservations_before_request = @hotel_system.reservations.length.dup
      
      start_date = Date.today
      end_date = start_date + 1
      
      reservation = @hotel_system.make_reservation(start_date, end_date)
      
      expect(reservation).must_be_instance_of Hotel::Reservation
      
      reservations_after_request = @hotel_system.reservations.length
      
      expect(reservations_after_request).must_equal reservations_before_request + 1
    end
    
  end
  
  describe "list reservations" do 
    it "raises ArgumentError if the date provided is not Date class" do 
      date = '2019, 9, 9'
      expect{@hotel_system.list_reservations(date)}.must_raise ArgumentError
    end
    
    it "lists all the reservations for a certain date" do 
      date = Date.new(2019,9,9)
      list = @hotel_system.list_reservations(date)
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
      date = Date.new(2019,9,20)
      expect(@hotel_system.list_reservations(date)).must_be_nil
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
      p cost_of_reservation

      expect(@hotel_system.cost(reservation_id)).must_be_instance_of Integer
      expect(@hotel_system.cost(reservation_id)).must_equal cost_of_reservation
      
    end
  end
  
end