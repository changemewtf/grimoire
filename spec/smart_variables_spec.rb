require "grimoire/smart_variables"

class Recipe
  smart_variables do
    Text RO Required name
    List RW Optional ingredients
    Date RO Optional pub_date
  end
end

RSpec.describe "smart variables" do
  it "checks argument length" do
    expect(-> { Recipe.new }).to raise_error ArgumentError
  end

  it "sets defaults" do
    expect(Recipe.new("Cake")).to have_attributes(
      ingredients: Grimoire::Contracts::List.default,
      pub_date: Grimoire::Contracts::Date.default
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
end

