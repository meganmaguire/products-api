class Job
  attr_reader :id, :type, :params
  attr_accessor :status, :response

  def initialize(id:, type:, params:, status: :pending, response: nil)
    @id = id
    @type = type
    @params = params
    @status = status
    @response = response
  end
end
