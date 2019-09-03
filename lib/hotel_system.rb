require_relative "room"
require_relative "reservation"

require "date"

module Hotel
  class HotelSystem
    attr_reader :rooms, :reservations
    
    def initialize
      @rooms = []
      20.times do |i|
        room = Hotel::Room.new(id: i + 1)
        @rooms << room
      end

      @reservations = []
    end
    
    def make_reservation(start_date, end_date)
      reservation_id = @reservations.length + 1
      room = @rooms.shuffle.first
      reservation = Hotel::Reservation.new(id: reservation_id, room: room, room_id: nil, start_date: start_date, end_date: end_date, cost: nil)
      @reservations << reservation
      return reservation
    end


    def list_reservations(date)
      raise ArgumentError.new("Date is invalid") if date.class != Date
      list = []
      @reservations.each do |reservation|
        list << reservation if reservation.start_date == date
      end
      return nil if list.empty?
      return list
    end

    def cost(reservation_id)
      raise ArgumentError.new("Reservation id is invalid") if reservation_id.class != Integer
      reservation = @reservations.find {|reservation| reservation.id == reservation_id}
      return reservation.cost
    end
  end
end