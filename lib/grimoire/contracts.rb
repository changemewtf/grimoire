require "date"

require "grimoire/contract"

module Grimoire
  ContractViolation = Class.new Exception

  DATE_METHODS = %i[day month year]
  TIME_METHODS = %i[hour min sec zone]
  EPOC_METHODS = DATE_METHODS + TIME_METHODS

  module Contracts
    Text = Contract.new %i[upcase start_with?], -> { "" }
    List = Contract.new %i[size push pop],      -> { ::Array.new }
    Date = Contract.new DATE_METHODS,           -> { ::Date.today }
    Time = Contract.new TIME_METHODS,           -> { ::Time.now }
    Epoc = Contract.new EPOC_METHODS,           -> { ::Time.now }
     Int = Contract.new %i[+ - > <],            -> { 0 }
    Hash = Contract.new %i[keys values fetch],  -> { ::Hash.new }
  end
end
