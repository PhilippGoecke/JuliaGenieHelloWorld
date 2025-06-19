using Genie

route("/hello") do
  name = params(:name, "World")

  "Hello $name!"
end
