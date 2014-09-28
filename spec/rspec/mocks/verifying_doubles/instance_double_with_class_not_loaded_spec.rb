require 'support/doubled_classes'

module RSpec
  module Mocks
    RSpec.describe 'An instance double with the doubled class not loaded' do
      include_context "with isolated configuration"

      before do
        RSpec::Mocks.configuration.verify_doubled_constant_names = false
      end

      it 'includes the double name in errors for unexpected messages' do
        o = instance_double("NonLoadedClass")
        expect {
          o.foo
        }.to fail_matching('Double "NonLoadedClass (instance)"')
      end

      it 'allows any instance method to be stubbed' do
        o = instance_double('NonloadedClass')
        allow(o).to receive(:undefined_instance_method).with(:arg).and_return(true)
        expect(o.undefined_instance_method(:arg)).to eq(true)
      end

      it 'allows any instance method to be expected' do
        o = instance_double("NonloadedClass")

        expect(o).to receive(:undefined_instance_method).
                       with(:arg).
                       and_return(true)

        expect(o.undefined_instance_method(:arg)).to eq(true)
      end

      it 'handles classes that are materialized after mocking' do
        stub_const "A::B", Object.new
        o = instance_double "A", :undefined_instance_method => true

        expect(o.undefined_instance_method).to eq(true)
      end

      context 'for null objects' do
        let(:o) { instance_double('NonLoadedClass').as_null_object }

        it 'returns self from any message' do
          expect(o.a.b.c).to be(o)
        end

        it 'reports it responds to any message' do
          expect(o.respond_to?(:a)).to be true
          expect(o.respond_to?(:a, false)).to be true
          expect(o.respond_to?(:a, true)).to be true
        end
      end
    end
  end
end