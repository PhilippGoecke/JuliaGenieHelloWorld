import Pkg;
Pkg.add("Genie")

using Genie

function greet()
  name = params(:name, "World")

  "Hello $(name)!"
end

route("/", greet) 

route("/hello") do
  greet()
end

up(8000, "0.0.0.0", async = false)
