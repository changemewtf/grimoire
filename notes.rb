
# contracts have defaults List => Array#new
# contracts have casts Date "month/day" => mm/dd/currentyy

# before_init, after_init hooks
# before_call, after_call hooks

  # has :name,        Name, Read,      Required
  # has :ingredients, List, ReadWrite, Default[nil]
  # has :pub_date,    Date, Private,   Default[nil]

  # has Name RO :name,             Required
  # has List, RW, :ingredients, Default[nil]
  # has Date, NR, :pub_date,      Default[nil]



