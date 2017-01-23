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

  it "cannot be changed" do
    violation = -> do
      DataObject.new("hey" => "you").instance_eval do
        @hey = "um"
      end
    end
    expect(violation).to raise_error RuntimeError
  end

  it "acts like a hash" do
    expect(DataObject.new(hey: "you").keys).to eq [:hey]
    expect(DataObject.new(hey: "you").values).to eq ["you"]
  end

  it "symbols win when duplicate keys" do
    o = DataObject.new "hey" => "me", :hey => "you"
    expect(o.hey).to eq "you"
    expect(o[:hey]).to eq "you"
    expect(o["hey"]).to eq "you"
    o = DataObject.new :hey => "you", "hey" => "me"
    expect(o.hey).to eq "you"
    expect(o[:hey]).to eq "you"
    expect(o["hey"]).to eq "you"
  end
end
