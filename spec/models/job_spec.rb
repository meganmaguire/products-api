require 'spec_helper'

RSpec.describe Job do
  describe '#initialize' do
    context 'with default status and response' do
      let(:job) { Job.new(id: 1, type: CreateProductWorker, params: { name: 'Cafe' }) }

      it 'sets id' do
        expect(job.id).to eq(1)
      end

      it 'sets type' do
        expect(job.type).to eq(CreateProductWorker)
      end

      it 'sets params' do
        expect(job.params).to eq({ name: 'Cafe' })
      end

      it 'defaults to pending status' do
        expect(job.status).to eq(:pending)
      end

      it 'defaults to a nil response' do
        expect(job.response).to be_nil
      end
    end

    context 'with an explicit status and response' do
      let(:job) do
        Job.new(id: 2,type: CreateProductWorker, params: {}, status: :finished, 
                response: { status: 201, body: {} })
      end

      it 'sets status' do
        expect(job.status).to eq(:finished)
      end

      it 'sets response' do
        expect(job.response).to eq({ status: 201, body: {} })
      end
    end
  end
end
