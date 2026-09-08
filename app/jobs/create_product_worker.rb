require_relative "../stores/product_store"
require_relative "../serializers/product_serializer"

class CreateProductWorker
  attr_accessor :name

  PROCESSING_DELAY = 5

  def initialize(params)
    @name = params[:name]
  end

  def execute
    sleep(PROCESSING_DELAY)

    product = Product.new(id: ProductStore.next_id, name: name)
    ProductStore.save(product)
    [201, succesful_response(product)]
  rescue StandardError
    [422, error_response]
  end

  private

  attr_accessor :product

  def succesful_response(product)
    ProductSerializer.new(product).as_json
  end

  def error_response
    { error: 'An error occured while processing the request' }
  end
end
