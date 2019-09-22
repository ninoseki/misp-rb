# frozen_string_literal: true

RSpec.shared_examples "list example" do
  let(:subject) { described_class }

  describe ".list" do
    it do
      res = subject.list
      expect(res).to be_an(Array)
    end
  end
end
