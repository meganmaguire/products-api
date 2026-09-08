require 'byebug'

class WorkerProcessor
  def self.start
    Thread.new { new.run }
  end

  def run
    loop do
      id = JobQueue.pop
      job = JobStore.find(id)
      status, response = job.type.new(job.params).execute
      job.response = { status: status, body: response }
      next job.status = :finished if sucessful_response?(status)
      job.status = :failed
    end
  end

  private

  def sucessful_response?(status)
    status >= 200 && status <400
  end
end