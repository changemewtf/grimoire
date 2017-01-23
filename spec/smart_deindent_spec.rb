require "grimoire/smart_deindent"

RSpec.describe "smart deindent" do
  it "removes first line indent completely" do
    expect(<<-EOL.smart_deindent).to start_with "hey"
      hey buddy
    EOL
  end

  it "removes subsequent indents up to the first line" do
    expect(<<-EOL.smart_deindent.split("\n")[1]).to start_with "  even"
      hey buddy
        even more indented
    EOL
  end
end
