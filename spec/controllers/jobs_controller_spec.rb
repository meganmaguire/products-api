require 'spec_helper'

RSpec.describe JobsController do
  describe '#show' do
    let(:job_id) { '1' }
    let(:env) { env_for("/jobs/#{job_id}") }
    subject(:response) { described_class.new(env, 'id' => job_id).show }
    let(:status) { response[0] }
    let(:body) { response[2] }
    let(:parsed_body) { JSON.parse(body.first) }

    it 'authenticates the request' do
      response
      expect(warden).to have_received(:authenticate!)
    end

    context 'when the job does not exist' do
      let(:job_id) { '999' }

      it 'returns a 404 status' do
        expect(status).to eq(404)
      end

      it 'returns a not found error' do
        expect(parsed_body).to eq({ 'error' => 'Job not found' })
      end
    end

    context 'when the job is still pending' do
      before { JobStore.save(Job.new(id: 1, type: CreateProductWorker, params: {})) }

      it 'returns a 202 status' do
        expect(status).to eq(202)
      end

      it 'returns a processing status body' do
        expect(parsed_body).to eq({ 'status' => 'processing' })
      end
    end

    context 'when the job has finished' do
      let(:job) do
        Job.new(id: 1, type: CreateProductWorker, params: {}, status: :finished).tap do |job|
          job.response = { status: 201, body: { id: 1, name: 'Cafe' } }
        end
      end

      before { JobStore.save(job) }

      it "returns the worker's response status" do
        expect(status).to eq(201)
      end

      it "returns the worker's response body" do
        expect(parsed_body).to eq({ 'id' => 1, 'name' => 'Cafe' })
      end
    end

    context 'when the job has failed' do
      let(:job) do
        Job.new(id: 1, type: CreateProductWorker, params: {}, status: :failed).tap do |job|
          job.response = { status: 422, body: { error: 'boom' } }
        end
      end

      before { JobStore.save(job) }

      it "returns the worker's error status" do
        expect(status).to eq(422)
      end

      it "returns the worker's error body" do
        expect(parsed_body).to eq({ 'error' => 'boom' })
      end
    end
  end
end
