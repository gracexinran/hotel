require "date"

module Hotel
  class Reservation
    attr_reader :id, :room_ids, :start_date, :end_date, :room_rate, :block, :cost
    attr_accessor :rooms
    
    def initialize(id:, rooms: nil, room_ids: nil, block: nil, start_date:, end_date:, room_rate: 200, cost: nil)
      
      validate_num(id)
      @id = id
      
      if rooms
        @rooms = rooms
        @room_ids = @rooms.map {|room| room.id}
        room_num = @rooms.length
      elsif room_ids
        @room_ids = room_ids
        room_num = @room_ids.length
      elsif block
        @block = block
        room_num = @block.length
      else
        raise ArgumentError.new('Room or block info is required!')
      end
      
      range = range(start_date, end_date)
      @start_date = start_date
      @end_date = end_date
      
      validate_num(room_rate)
      @room_rate = room_rate
      
      @cost = cost || room_num * @room_rate * range
      
    end
    
    def validate_num(num)
      raise ArgumentError.new('It cannot be blank and must be an integer greater than zero.') if num.nil? || num.class != Integer || num <= 0
    end
    
    def range(start_date, end_date)
      raise ArgumentError.new("Date range is invalid!") if start_date.nil? || end_date.nil? || start_date.class != Date || end_date.class != Date || start_date >= end_date || start_date < Date.today
      
      return (end_date - start_date).to_i
      
    end
    
    def connect_reservation(rooms)
      @rooms = rooms
      rooms.each do |room|
        room.add_reservation(self)
      end
    end
    
  end
end