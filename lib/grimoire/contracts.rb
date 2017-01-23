require "grimoire/contract"

module Grimoire
  ContractViolation = Class.new Exception

  module Contracts
    Text = Contract.new %i[upcase start_with?], -> { "" }
    List = Contract.new %i[size push pop],      -> { [] }
    Date = Contract.new %i[day month year],     -> { ::Date.today }
  end
end
