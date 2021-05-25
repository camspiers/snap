(fn create [mod fnc]
  (setmetatable mod {:__call fnc}))
