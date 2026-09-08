class Product
  attr_reader :id, :name
  attr_accessor :status

  def initialize(id:, name:)
    @id = id
    @name = name
  end
end
