require 'spec_helper'

RSpec.describe CreateProductWorker do
  let(:worker) { described_class.new(name: 'Cafe') }
  subject { worker.execute }

  before do
    allow(worker).to receive(:sleep)
  end

  describe '#execute' do
    it 'waits for the configured processing delay' do
      subject
      expect(worker).to have_received(:sleep).with(described_class::PROCESSING_DELAY)
    end

    it 'persists a new product' do
      expect { subject }.to change { ProductStore.all.size }.by(1)
    end

    context 'when the worker succeeds' do
      before { subject }

      let(:product) { ProductStore.all.last }

      it 'names the product after the given name' do
        expect(product.name).to eq('Cafe')
      end

      it 'returns a 201 status' do
        expect(subject.first).to eq(201)
      end

      it 'returns the serialized product as the body' do
        expect(subject.last).to eq({ id: product.id, name: product.name })
      end
    end

    context 'when the worker fails' do
      before do
        allow(ProductStore).to receive(:save).and_raise(StandardError)
        subject
      end

      it 'returns a 422 status' do
        expect(subject.first).to eq(422)
      end

      it 'returns an error message' do
        expect(subject.last).to eq({ error: 'An error occured while processing the request' })
      end
    end
  end
end
