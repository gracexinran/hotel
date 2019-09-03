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

  end
  
end