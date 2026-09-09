require_relative '../models/job'

class JobStore
  class << self
    def init!
      @jobs = {}
      @next_id = 0
    end

    def next_id
      @next_id += 1
    end

    def save(job)
      @jobs[job.id] = job
    end

    def find(id)
      @jobs[id.to_i]
    end
  end

  init!
end