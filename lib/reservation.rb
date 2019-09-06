require "date"
require "csv"

module Hotel
  class Reservation
    attr_reader :id, :room_ids, :start_date, :end_date, :block, :cost, :room_rate
    attr_accessor :rooms
    
    CSV_RESERVATION = 'reservation.csv'
    
    def initialize(id:, rooms: nil, room_ids: nil, block: nil, start_date:, end_date:, room_rate: nil, cost: nil)
      
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
        @room_ids = @block.map {|room| room.id}
        room_num = @block.length
      else
        raise ArgumentError.new('Room or block info is required!')
      end
      
      range = range(start_date, end_date)
      @start_date = start_date
      @end_date = end_date
      
      if cost
        validate_num(cost)
        @cost = cost
      elsif room_rate
        validate_num(room_rate)
        @room_rate = room_rate
        @cost = @room_rate * range * room_num
      else
        cost_per_night = 0
        @room_ids.each do |room_id|
          room = find_room(room_id)
          cost_per_night += room.rate 
        end
        @cost = cost_per_night * range
      end
      
      CSV.open(CSV_RESERVATION, 'a') do |csv|
        csv_array = CSV.read(CSV_RESERVATION)
        new_csv = ["#{@id}", "#{rooms}", "#{@room_ids}", "#{block}", "#{@start_date}", "#{@end_date}", "#{room_rate}", "#{@cost}"]
        
        csv << new_csv
      end
      
    end
    
    def validate_num(num)
      raise ArgumentError.new('It cannot be blank and must be an integer greater than zero.') if num.nil? || num.class != Integer || num <= 0
    end
    
    def range(start_date, end_date)
      raise ArgumentError.new("Date range is invalid!") if start_date.nil? || end_date.nil? || start_date.class != Date || end_date.class != Date || start_date >= end_date || start_date < Date.today
      
      return (end_date - start_date).to_i
      
    end
    
    def find_room(room_id)
      room = Hotel::HotelSystem.new.rooms.find {|room| room.id == room_id}
      return room
    end
    
    def connect_reservation(rooms)
      @rooms = rooms
      rooms.each do |room|
        room.add_reservation(self)
      end
    end
    
  end
end