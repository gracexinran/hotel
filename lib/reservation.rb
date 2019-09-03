require "date"

module Hotel
  class Reservation
    attr_reader :id, :room, :room_id, :start_date, :end_date
    attr_accessor :cost
    ROOM_RATE = 200
    
    def initialize(id:, room: nil, room_id: nil, start_date:, end_date:, cost: nil)
      validate_id(id)
      @id = id
      
      if room
        @room = room
        @room_id = room.id
      elsif room_id
        @room_id = room_id
      else
        raise ArgumentError.new('Room or room_id is required')
      end
      
      raise ArgumentError.new("Date range is invalid") if start_date.nil? || end_date.nil? || start_date >= end_date || start_date < Date.today
      @start_date = start_date
      @end_date = end_date
      
      @cost = cost || ROOM_RATE * (end_date - start_date).to_i
      
    end
    
    def validate_id(id)
      raise ArgumentError.new('ID cannot be blank and must be an integer greater than zero.') if id.class != Integer || id.nil? || id <= 0
        
    end


  end
end