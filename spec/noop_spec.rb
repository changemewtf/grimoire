require "grimoire/noop"

RSpec.describe "no-op" do
  it "doesn't do anything" do
    expect(NOOP.call("hey")).to eq "hey"
  end
end
