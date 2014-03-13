# This example shows a simple use of the function
# from DIN 4108-3
# B.5 Beispiel 4: Außenwand mit nachträglicher raumseitiger Wärmedämmung
# Konstruktion: Außenwand mit nachträglicher Innendämmung

# Set the proper working directory
setwd("~/workspace/R/UvalR")

# Load local functions
source("./Uval.R")

# Layers from Outside to Inside Layer
Layers <- data.frame(
  name = c(
    "Außenputz",
    "Mauerwerk",
    "EPS-Dämmstoff",
    "HWL-Platte",
    "Innenputz"),
  Thicknes = c(0.02,0.24,0.04,0.025,0.015),
  Conductivity = c(1,0.4,0.04,0.08,0.7),
  Diffusion = c(40,8,20,4,15))

CalculateUval(Layers, k.t_e=-5,
              plottemp=TRUE, plotpress=TRUE,
              name="Innendaemmung_", writetab=TRUE)
