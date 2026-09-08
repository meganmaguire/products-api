require_relative "base_controller"
require_relative "../stores/job_store"
require_relative "../jobs/job_queue"
require_relative "../serializers/product_serializer"

class ProductsController < BaseController
  def index
    authenticate!

    render(200, ProductStore.all.map { |product| ProductSerializer.new(product).as_json })
  end

  def show
    authenticate!

    product = ProductStore.find(params["id"])
    return render(404, { error: "Product not found" }) unless product

    render(200, ProductSerializer.new(product).as_json)
  end

  def create
    authenticate!

    return render(422, { error: "Missing parameter: name" }) unless valid_params?

    response = create_product
    render(202, response)
  end

  private

  def valid_params?
    !name.nil? && !name.to_s.strip.empty?
  end

  def name
    @name ||= params["name"]
  end

  def create_product
    job = Job.new(id: JobStore.next_id, type: CreateProductWorker, params: { name: name })
    JobStore.save(job)
    JobQueue.enqueue(job.id)
    job_response(job.id)
  end
end
