require_relative "base_controller"
require_relative "../stores/job_store"
require_relative "../jobs/job_queue"
require_relative "../serializers/product_serializer"

class ProductsController < BaseController
  def index
    authenticate!

    render(200, products)
  end

  def show
    authenticate!
    return not_found_response unless product

    render(200, ProductSerializer.new(product).as_json)
  end

  def create
    authenticate!
    return missing_param_response unless valid_params?

    render(202, create_product)
  end

  private

  def products
    @products ||= ProductStore.all.map { |product| ProductSerializer.new(product).as_json }
  end

  def product
    @product ||= ProductStore.find(params["id"])
  end

  def missing_param_response
    render(422, { error: "Missing parameter: name" })
  end

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

  def entity
    'Product'
  end
end
