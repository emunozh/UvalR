# Function to generate layers based on an external data source
getLayers <- function(MaterialsToget, Thicknes){
  
  # Load an external data file
  Materials <- read.csv("./Data/materials.csv")
  
  # Create empty vectors
  Conductivity <- c()
  Diffusion <- c()
  
  # Search layers in external data source 
  for(m in 1:length(MaterialsToget)){
    ind <- which(Materials$name == MaterialsToget[m])
    Conductivity[m] <- Materials$ConducV[ind]
    Diffusion[m] <- Materials$DiffV[ind]
  }
  
  # Layers from Outside to Inside Layer
  Layers <- data.frame(
    name = MaterialsToget,
    Thicknes = Thicknes,
    Conductivity = Conductivity,
    Diffusion = Diffusion)
  
  return(Layers)
}

  # Plot function
PlotT <- function(
  Layers, yvalues, plotname,
  equivalent=FALSE, press=FALSE, condensate=FALSE){
  if (equivalent){
    filename <- paste(plotname, "pressure", sep="")
    add.plot = 0.1
    yy <- c(0, 0, 3000, 3000)
    Xlayer = Layers$Sd
    HashLayer = Layers$Diffusion
    HashDensity = 0.001
    p.ylim = c(0,2500)
    p.ylab = "Pressure in Pascal"
    p.xlab = "Diffusion equivalent thickness"
    p.main = "Pressure profile of building component\n"
  } else {
    filename <- paste(plotname, "temperature", sep="")
    add.plot = 0.01
    yy <- c(-15, -15, 25, 25)
    Xlayer = Layers$Thicknes
    HashLayer = Layers$Conductivity
    HashDensity = 10
    p.ylim = c(-12,22)
    p.ylab = "Temperature in degree Celsius"
    p.xlab = "Thickness in cm"
    p.main = "Temperature profile of building component\n"
  }
  
  pdf(file=paste("FIGURES/", filename,".pdf", sep=""))
  
  Thicknes <- c(0, add.plot)
  for(a in 1:length(Layers$Thicknes)){
    Thicknes[a+2] <- Thicknes[a+1] + Xlayer[a]
  }
  Thicknes[length(Thicknes)+1] <- Thicknes[length(Thicknes)] + add.plot
  
  pos <- Thicknes[2:(length(Thicknes)-1)]
  
  pos.lab <- c()
  for(j in 1:(length(Thicknes)-1)){
    pos.lab[j] <- Thicknes[j]+(Thicknes[j+1] - Thicknes[j])/2
  }
  
  lab <- c("outdoors")
  for(l in 1:length(Layers$name)){
    lab[l+1] <- as.character(Layers$name[l])
  }
  lab[length(lab)+1] <- "indoors"
  
  # create variable for plot hash
  for(c in 1:length(Layers$Conductivity)){
    if (is.nan(HashLayer[c])){
      Layers$PlotH[c] <- 0
    } else {
      Layers$PlotH[c] <- HashLayer[c] * HashDensity
    }
  }

  plot(yvalues~Thicknes, type="n",
       ylab=p.ylab, xlab=p.xlab, main=p.main, ylim=p.ylim,
       par(adj=0.5))
  axis(3, at=pos.lab, labels=lab, col.axis="red")
  abline(v = pos, lty = 2)
  for(p in 1:(length(pos)-1)){
    xx <- c(pos[p], pos[p+1], pos[p+1], pos[p])
    polygon(xx, yy, col = "grey", density = Layers$PlotH[p])
  }
  lines(yvalues~Thicknes, type="l",col="red",lwd=3,lty=1)
  if (equivalent){
    lines(press~Thicknes, type="l",col="red",lwd=3,lty=2)
    legend("bottomright", c("P","P_sat"), 
           col=c("red","red"), lwd=3, lty=c(1,2),
           bty = "n", bg="white")
    for(c in 1:length(Thicknes)){
      if(condensate[c]){
        text(yvalues[c]~Thicknes[c], labels="condensate", offset=0.9, pos=1)
        points(yvalues[c]~Thicknes[c],pch=25,bg="blue",cex=2)
      }
    }
  }
  dev.off()
}

# Saturation point
GetPressSat <- function(t){
  if(t >= 0){
    Psat = 610.5 * exp((17.269*t)/(237.3+t))
  } else {
    Psat = 610.5 * exp((21.875*t)/(265.5+t))
  }
  return(Psat)
}

# U-value calculator
CalculateUval <- function(
  Layers,
  k.t_e =  -10, 
  k.t_i =   20, # Internal and External temperature [°c]
  k.h_e =   25, 
  k.h_i =    8, # Internal heat transfer coefficients [m2K/W]
  k.rf_e =  80,
  k.rf_i =  50, # Internal air moisture [%]
  k.p_e = 1168,
  k.p_i =  321, # Internal pressure [Pa]
  plottemp = FALSE,
  plotpress = FALSE,
  writetab = FALSE,
  name=""
  ){
  # Compute the u-value for the given component.
  # Implemented for wall elements.

  # We calculate the transmission [W/mK]
  Layers$H <- Layers$Thicknes / Layers$Conductivity
  # And the corresponding r values [m2/ K/W]
  R_tot = 1/k.h_i + sum(Layers$H, na.rm = TRUE) + 1/k.h_e
  Uval = 1/R_tot
  
  # We calculate the equivalent watter diffusion thickness [m]
  Layers$Sd <- Layers$Thicknes * Layers$Diffusion
  Layers$Sd[is.nan(Layers$Sd)] <- 0
  # And the corresponding sdt value [m]
  Sd_tot = sum(Layers$Sd, na.rm = TRUE)

  # We calculate the temperature difference between layers
  q = Uval * abs(k.t_i-k.t_e) # [W/m2K]
  temp.delta <- c(1/k.h_e*q)
  for(i in 1:length(Layers$Thicknes)){temp.delta[i+1] <- Layers$H[i]*q}
  temp.delta[length(temp.delta)+1] <- c(1/k.h_i*q)
  # And the temperature profile
  temp <- c(k.t_e)
  for(j in 1:length(temp.delta)){
    if (is.nan(temp.delta[j])){
      temp[j+1] <- temp[j]
    } else {
      temp[j+1] <- temp[j] + temp.delta[j]
    }
  }
  
  # The saturation pressure
  press_sat <- c()
  for(m in 1:length(temp)){
    press_sat[m] <- GetPressSat(temp[m])
  }

  # We calculate the pressure difference between layers
  # And the pressure profile
  gdo = abs(k.p_i-k.p_e)/sum(Layers$Sd)
  sum.sd = 0
  CondensatePoints <- c()
  press <- c()
  press[length(temp)] = k.p_e
  press[length(temp)-1] = k.p_e
  press[1] = k.p_i
  CondensatePoints[length(temp)] <- FALSE
  CondensatePoints[length(temp)-1] <- FALSE
  CondensatePoints[1] <- FALSE
  for(l in seq(length(temp)-2,2)){
    this.sd = Layers$Sd[l-1]
    press[l] = press[l+1]-this.sd*gdo
    if (press[l] > press_sat[l]){
      press[l] = press_sat[l]
      gdo = (press[l+1]-k.p_e)/(sum(Layers$Sd)-sum.sd)
      CondensatePoints[l] <- TRUE 
    } else {
      CondensatePoints[l] <- FALSE
    }
    sum.sd = sum.sd + Layers$Sd[l-1]
  }
  
  if(plottemp){PlotT(Layers, temp, name)}
  if(plotpress){PlotT(
    Layers, press, name, equivalent=TRUE,
    press = press_sat, condensate=CondensatePoints)}
  
  if(writetab){
    press_prof <- data.frame(
      Layer_Pressure=press,
      Saturation_Pressure=press_sat
      )
    temp_prof <- data.frame(
      Layer_Temperature=temp
      )
    write.csv(Layers, file = paste("TABLES/", name,"Layers.csv", sep=""))
    write.csv(temp_prof, file = paste("TABLES/", name,"TempProfile.csv", sep=""))
    write.csv(press_prof, file = paste("TABLES/", name,"PressProfile.csv", sep=""))
  }

  print(Uval)
  return(Uval)
}
