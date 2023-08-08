-- P(v: <obj>) is a helper function that inspects a given object and prints it in a
-- human readable format.
-- e.g P(package.loaded)
P = function(v)
  print(vim.inspect(v))
  return v
end

-- R(<name>: string) is a helper function that will force a lua package to be
-- reloaded.
R = function(name)
  package.loaded[name] = nil
  require(name)
end
