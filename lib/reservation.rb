require "date"

module Hotel
  class Reservation
    attr_reader :id, :room_id, :start_date, :end_date, :room_rate
    attr_accessor :cost, :room, :block
    
    def initialize(id:, room: nil, room_id: nil, block: nil, start_date:, end_date:, room_rate: 200, cost: nil)
      validate_id(id)
      @id = id
      
      if room
        @room = room
        @room_id = room.id
        room_num = 1
      elsif room_id
        @room_id = room_id
        room_num = 1
      elsif block
        @block = block
        room_num = block.length
      else
        raise ArgumentError.new('Room or room_id is required')
      end
      
      raise ArgumentError.new("Date range is invalid") if start_date.nil? || end_date.nil? || start_date >= end_date || start_date < Date.today
      @start_date = start_date
      @end_date = end_date
      
      @room_rate = room_rate
      @cost = cost || room_num * @room_rate * (end_date - start_date).to_i
      
    end
    
    def validate_id(id)
      raise ArgumentError.new('ID cannot be blank and must be an integer greater than zero.') if id.class != Integer || id.nil? || id <= 0
        
    end

    def connect_reservation(room)
      @room = room
      room.add_reservation(self)
    end

  end
end