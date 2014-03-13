# Reads some external data from a csv file and generates the layers to compute the U-val
# Reproduces the example 4 from DIN 4108-3, see ./Examples/Innendämmung.R

# Set the proper working directory
setwd("~/workspace/R/UvalR")

# Load local functions
source("./Uval.R")

MaterialsToget <- c(
  "Mineralischer_Edelputz",
  "Porensinterbeton_mit_Quarzsand_900",
  "EPS_040_30",
  "Holzwolle_Leichtbauplatten_Heraklith_Platten__Magnesia__390",
  "Mineralischer_Armierungsputz"
  )

Thicknes = c(0.02,0.24,0.04,0.025,0.015)

# Generate the Layers
Layers <- getLayers(MaterialsToget, Thicknes)

CalculateUval(Layers, k.t_e=-5,
              plottemp=TRUE, plotpress=TRUE,
              name="ExternalData_", writetab=TRUE)
