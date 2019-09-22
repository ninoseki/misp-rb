# frozen_string_literal: true

RSpec.shared_examples "update example" do
  let(:subject) { described_class }

  describe "#update" do
    let(:new_one) { subject.create(attributes) }

    it do
      res = new_one.update(attributes)
      expect(res).to be_a(described_class)
    end
  end
end
