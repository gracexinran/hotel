require_relative "test_helper"

describe "Reservation" do 
  
  describe "initialize" do 
    let(:reservation) {
      Hotel::Reservation.new(id: 7, room_id: 7, start_date: Date.today, end_date: Date.today + 1)
    }
    
    it "establishes the base data structures when instantiated" do
      expect(reservation).must_be_instance_of Hotel::Reservation
      expect(reservation.id).must_be_instance_of Integer
      expect(reservation.start_date).must_be_instance_of Date
      expect(reservation.end_date).must_be_instance_of Date
      expect(reservation.cost).must_be_instance_of Integer
    end
    
    it "raises ArgumentError if reservation id is invalid" do
      [nil, 0, -1].each do |id|
        expect{
          Hotel::Reservation.new(id: id, start_date: Date.today, end_date: Date.today + 1)
        }.must_raise ArgumentError
      end
    end
    
    it "raises ArgumentError if both room and room_id are not provided" do 
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
      room_rate = 200
      cost = (reservation.end_date - reservation.start_date).to_i * 200
      expect(reservation.cost).must_equal cost
      
    end
  end
  
  
end