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
    
    def make_reservation(start_date, end_date, room_num = 1, room_rate = 200)
      reservation_id = @reservations.length + 1
      if room_rate == 200 && room_num == 1
        room = available_room(start_date, end_date)
        reservation = Hotel::Reservation.new(id: reservation_id, room: room, start_date: start_date, end_date: end_date)
        @reservations << reservation
        reservation.connect_reservation(room)
      else
        block = available_block(start_date, end_date, room_num, room_rate)
        reservation = Hotel::Reservation.new(id: reservation_id, block: block, start_date: start_date, end_date: end_date)
        @reservations << reservation
        block.each do |room|
          reservation.connect_reservation(room)
        end
      end
      return reservation
    end
    
    def cost(reservation_id)
      raise ArgumentError.new("Reservation id is invalid") if reservation_id.class != Integer
      reservation = @reservations.find {|reservation| reservation.id == reservation_id}
      return reservation.cost
    end
    
    def reservations_by_date(date)
      raise ArgumentError.new("Date is invalid") if date.class != Date
      list = []
      @reservations.each do |reservation|
        list << reservation if reservation.start_date == date
      end
      return nil if list.empty?
      return list
    end
    
    def available_room(start_date, end_date)
      room = @rooms.find {|room| room.status(start_date, end_date)}
      raise ArgumentError.new("No available rooms!") if !room
      return room
    end
    
    def available_block(start_date, end_date, room_num, room_rate)
      raise ArgumentError.new("Please provide a valid number of rooms you want to book!") if room_num.class != Integer || room_num > 5
      raise ArgumentError.new("You must provide a discounted room rate to create a block!") if room_rate.class!= Integer || room_rate >= 200
      block = []
      @rooms.each do |room|
        block << room if room.status(start_date, end_date)
        break if block.length == room_num
      end
      raise ArgumentError.new("No available block now!") if block.length < room_num
      return block
    end
    
  end
  
end