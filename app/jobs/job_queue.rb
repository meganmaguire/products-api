class JobQueue
  class << self
    def init!
      @queue = Queue.new
    end

    def enqueue(id)
      @queue << id
    end

    def pop
      @queue.pop
    end
  end

  init!
end
