$LOAD_PATH.unshift(File.expand_path("../app", __dir__))

require "rack"
require "warden"

require_relative "../app/models/job"
require_relative "../app/models/product"
require_relative "../app/models/user"

require_relative "../app/stores/job_store"
require_relative "../app/stores/product_store"
require_relative "../app/stores/user_store"

require_relative "../app/jobs/job_queue"
require_relative "../app/jobs/worker_processor"
require_relative "../app/jobs/create_product_worker"

require_relative "../app/serializers/product_serializer"

require_relative "../app/controllers/base_controller"
require_relative "../app/controllers/sessions_controller"
require_relative "../app/controllers/products_controller"
require_relative "../app/controllers/jobs_controller"

Dir[File.join(__dir__, "support", "**", "*.rb")].sort.each { |f| require f }

RSpec.configure do |config|
  config.define_derived_metadata(file_path: %r{/spec/controllers/}) do |metadata|
    metadata[:type] = :controller
  end

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.example_status_persistence_file_path = "spec/examples.txt"
  config.disable_monkey_patching!
  config.order = :random
  Kernel.srand config.seed

  config.before do
    JobStore.init!
    ProductStore.init!
    UserStore.init!
    JobQueue.init!
  end
end
