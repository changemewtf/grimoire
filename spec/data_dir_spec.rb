require "grimoire/data_dir"

class Mock
  data_dir "spec/data_dir_config"
end

RSpec.describe "data directories" do
  it "can read hash" do
    expect(Mock.new.foo.feels).to eq "goodman"
  end

  it "can read list" do
    expect(Mock.new.bar.size).to eq 2
    expect(Mock.new.bar[0]).to eq "this is fine"
  end

  it "can read list of hashes" do
    expect(Mock.new.baz.size).to eq 2
    expect(Mock.new.baz[1].hap).to eq "butt"
  end
end
