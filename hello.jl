import Pkg;
Pkg.add("Genie")

using Genie, Genie.Renderer.Html

route("/hello") do
  name = params(:name, "World")

  html("Hello $name!")
end

up(8000, "0.0.0.0", async = false)
