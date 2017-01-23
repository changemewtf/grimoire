require "grimoire/data_object"

include Grimoire

RSpec.describe "data objects" do
  it "[symbol] -> [symbol]" do
    expect(DataObject.new(hey: "you")[:hey]).to eq "you"
  end

  it "[symbol] -> [string]" do
    expect(DataObject.new(hey: "you")["hey"]).to eq "you"
  end

  it "[string] -> [symbol]" do
    expect(DataObject.new("hey" => "you")[:hey]).to eq "you"
  end

  it "[string] -> [string]" do
    expect(DataObject.new("hey" => "you")["hey"]).to eq "you"
  end

  it "[symbol] -> method" do
    expect(DataObject.new(hey: "you")).to have_attributes(hey: "you")
  end

  it "[string] -> method" do
    expect(DataObject.new("hey" => "you")).to have_attributes(hey: "you")
  end
end
