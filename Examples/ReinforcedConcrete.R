# This example shows a simple use of the function
# from:
# Keller, B., & Rutz, S. (2010). Pinpoint: Key facts + figures for sustainable
# buildings. Basel: Birkhauser.

# Set the proper working directory
setwd("~/workspace/R/UvalR")

# Load local functions
source("./Uval.R")

Layers <- data.frame(
  name = c("External Plaster", "Expanded Polystyrene", 
           "Reinforced Concrete", "Internal Stuco"),
  Thicknes =     c(0.01, 0.18 , 0.25, 0.01),
  Conductivity = c(0.87, 0.038, 1.8,  0.7),
  Diffusion =    c(15, 30, 80, 6))

CalculateUval(Layers, k.t_e=-5,
              plottemp=TRUE, plotpress=TRUE,
              name="ReinforcedConcrete_", writetab=TRUE)
