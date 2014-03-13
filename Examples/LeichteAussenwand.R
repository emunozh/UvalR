# This example shows a simple use of the function
# from DIN 4108-3
# Konstruktion: Leichte Außenwand mit hinterlüfteter Vorsatzschale

# Set the proper working directory
setwd("~/workspace/R/UvalR")

# Load local functions
source("./Uval.R")

# Layers from Outside to Inside Layer
Layers <- data.frame(
  name = c(
    "Vorgehängte Außenschale",
    "Belüftete Luftschicht",
    "Spanplatte V100",
    "Mineralwolle",
    "Diffusionshemmende Schicht",
    "Spanplatte V20"),
  Thicknes = c(0.02, 0.03, 0.019, 0.16, 0.00005, 0.019),
  Conductivity = c(NaN, NaN, 0.127, 0.04, NaN, 0.127),
  Diffusion = c(NaN, NaN, 100, 1, 40000, 50))
    
CalculateUval(Layers, k.t_e=-5,
              plottemp=TRUE, plotpress=TRUE,
              name="leichteAussenwand_", writetab=TRUE)
