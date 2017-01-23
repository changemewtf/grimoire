require "grimoire/contracts"

Fizzer = Grimoire::Contract.new %i[fizz], -> { "fizzy" }

RSpec.describe "contracts" do
  it "sets contract-based defaults" do
    expect(Fizzer.default).to eq "fizzy"
  end

  it "enforces contracts" do
    expect(-> { Fizzer.check "" }).to raise_error Grimoire::ContractViolation
  end

  context "dates" do
    it "allows casting" do
      expect(Grimoire::Contracts::Date.check "11/22").to have_attributes(
        day: 22,
        month: 11,
        year: Date.today.year
      )
    end
  end

  context "integers" do
    it "defaults to zero" do
      expect(Grimoire::Contracts::Int.default).to eq 0
    end
  end
end
