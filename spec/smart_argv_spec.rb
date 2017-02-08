require "grimoire/smart_argv"

RSpec.describe "smart command line arguments" do
  subject { Grimoire::SmartArgv }

  it "finds by short option" do
    expect(subject.new(%w[-c hey]).option(:command)).to eq "hey"
  end

  it "finds by long option" do
    expect(subject.new(%w[--command hoi]).option(:command)).to eq "hoi"
  end

  it "finds at end of compound option" do
    expect(subject.new(%w[-ac haay]).option(:command)).to eq "haay"
  end

  it "finds by short flag" do
    expect(subject.new(%w[-c]).flag(:command)).to eq true
  end

  it "finds by long flag" do
    expect(subject.new(%w[--command]).flag(:command)).to eq true
  end

  it "finds all flags" do
    c = subject.new %w[-c -d -ef]
    expect(c.flag(:c)).to eq true
    expect(c.flag(:d)).to eq true
    expect(c.flag(:e)).to eq true
    expect(c.flag(:f)).to eq true
  end
end
