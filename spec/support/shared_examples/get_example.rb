# frozen_string_literal: true

RSpec.shared_examples "get example" do
  let(:subject) { described_class }

  describe ".get" do
    let(:new_one) { subject.create(**attributes) }

    it do
      res = subject.get(new_one.id)
      expect(res).to be_a(described_class)
    end
  end
end
