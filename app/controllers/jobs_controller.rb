require_relative "base_controller"
require_relative "../jobs/job_queue"
require_relative "../stores/job_store"

class JobsController < BaseController
  def show
    authenticate!

    return processing_response if in_progress?
    complete_response
  end

  private

  def job
    @job ||= JobStore.find(params["id"])
  end

  def in_progress?
    job.status == :pending
  end

  def processing_response
    render(202, { status: 'processing' })
  end

  def complete_response
    render(job.response[:status], job.response[:body])
  end
end