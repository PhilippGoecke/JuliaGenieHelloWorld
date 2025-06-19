import Pkg;
Pkg.add("Genie")

using Genie

route("/hello") do
  name = params(:name, "World")

  "Hello $name!"
end

up(8000, async = false)
