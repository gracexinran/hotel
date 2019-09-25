require "csv"
require_relative "hotel_data"

module Hotel
  class Room < HotelData
    attr_reader :id, :reservations
    attr_accessor :rate
    
    CSV_ROOM = 'room.csv'
    ROOM_RATE = 200
    def initialize(id:, reservations: nil, rate: ROOM_RATE)
      super(id: id)
      validate_num(id)
      @id = id
      @reservations = reservations || []
      validate_num(rate)
      @rate = rate
      
      CSV.open(CSV_ROOM, 'a') do |csv|
        csv_array = CSV.read(CSV_ROOM)
        new_csv = ["#{@id}", "#{@reservations}", "#{@rate}"]
        csv << new_csv if !csv_array.include?(new_csv)
      end
      
    end
    
    def add_reservation(reservation)
      @reservations << reservation
    end
    
    def status(start_date, end_date)
      booked_dates = []
      
      @reservations.each do |reservation|
        range = (reservation.end_date - reservation.start_date).to_i
        range.times do |i|
          booked_dates << reservation.start_date + i
        end
      end
      
      range = (end_date - start_date).to_i
      range.times do |i|
        return false if booked_dates.include?(start_date + i)
      end
      return true
    end
    
  end
  
end