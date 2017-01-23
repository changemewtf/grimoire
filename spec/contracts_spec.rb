require "grimoire/contracts"

RSpec.describe "contracts" do
  it "sets contract-based defaults" do
    expect(Grimoire::Contracts::List.default.size).to eq 0
  end

  it "enforces contracts" do
    expect(-> { Grimoire::Contracts::List.check "" }).to raise_error Grimoire::ContractViolation
  end

  it "allows casting" do
    expect(Grimoire::Contracts::Date.check "11/22").to have_attributes(
      day: 22,
      month: 11,
      year: Date.today.year
    )
  end
end
