module Hotel
  class Room
    attr_reader :id, :reservations
    
    def initialize(id:, reservations: nil)
      validate_id(id)
      @id = id
      @reservations = reservations || []
    end
    
    def validate_id(id)
      raise ArgumentError.new('ID cannot be blank and must be an integer greater than zero.') if id.class != Integer || id.nil? || id <= 0
      
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