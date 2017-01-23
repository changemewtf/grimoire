require "grimoire/contracts"

class Recipe < Grimoire::ContractObject
  variables do
    Text RO Required name
    List RW Optional ingredients
    Date RO Optional pub_date
  end
end

RSpec.describe "contracts" do
  it "checks argument length" do
    expect(-> { Recipe.new }).to raise_error ArgumentError
  end

  it "sets defaults" do
    expect(Recipe.new("Cake")).to have_attributes(
      ingredients: Grimoire::Contracts::C::List.default,
      pub_date: Grimoire::Contracts::C::Date.default
    )
  end

  it "enforces read-only" do
    expect(Recipe.new("Cake")).to respond_to :name
  end

  it "allows read-write" do
    expect(Recipe.new("Cake")).to respond_to :ingredients=
  end

  it "defines required variables from constructor" do
    expect(Recipe.new("Cake").name).to eq "Cake"
  end

  it "defines optional variables from constructor" do
    expect(Recipe.new("Cake", ["hey"]).ingredients.size).to eq 1
  end

  it "sets contract-based defaults" do
    expect(Recipe.new("Cake").ingredients.size).to eq 0
  end

  it "enforces contracts" do
    expect(-> { Recipe.new "Cake", 10 }).to raise_error Grimoire::ContractViolation
  end

  it "allows casting" do
    expect(Recipe.new("Cake", nil, "11/22").pub_date).to have_attributes(
      day: 22,
      month: 11,
      year: Date.today.year
    )
  end
end
