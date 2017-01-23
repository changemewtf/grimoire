require "date"

require "grimoire/contract"

module Grimoire
  ContractViolation = Class.new Exception

  module Contracts
    Text = Contract.new %i[upcase start_with?], -> { "" }
    List = Contract.new %i[size push pop],      -> { ::Array.new }
    Date = Contract.new %i[day month year],     -> { ::Date.today }
     Int = Contract.new %i[+ - > <],            -> { 0 }
    Hash = Contract.new %i[keys values fetch],  -> { ::Hash.new }
  end
end
