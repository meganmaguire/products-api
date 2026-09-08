require_relative "models/product"
require_relative "models/user"
require_relative "models/job"

require_relative "stores/product_store"
require_relative "stores/user_store"
require_relative "stores/job_store"

require_relative "jobs/job_queue"
require_relative "jobs/worker_processor"
require_relative "jobs/create_product_worker"

require_relative "serializers/product_serializer"

require_relative "strategies/password_strategy"

require_relative "router"
require_relative "controllers/base_controller"
require_relative "controllers/sessions_controller"
require_relative "controllers/products_controller"
require_relative "controllers/jobs_controller"

class App
  ROUTES = Router.new.tap do |r|
    r.add(:post, "/sessions", SessionsController, :create)
    r.add(:post, "/products", ProductsController, :create)
    r.add(:get, "/products", ProductsController, :index)
    r.add(:get, "/products/:id", ProductsController, :show)
    r.add(:get, "/jobs/:id", JobsController, :show)
  end

  def call(env)
    ROUTES.call(env)
  end
end

UserStore.seed(username: "usuario", password: "12345678")
WorkerProcessor.start
