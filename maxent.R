# MaxEnt model for Antarctic and Sub-Antarctic molluscs response to climate change
### Aoife Molloy 2024-01-18
------
## 1. Compile species distribution coordinates
  
## 2. Clean distribution data
  
## 3. Load in raster files of temperature data and study area
  
### a. load in historical/current data 
hist <- raster("C:/Users/molloya5.COLLEGE/Desktop/For Aoife/hist_new/Hist_new1.tif")

### b. Load in 2040-2060 seafloor temperatures ssp585
future_1 <- raster("C:/Users/molloya5.COLLEGE/Desktop/For Aoife/ssp585_1_new/ssp585_1_new.tif")
  
### c. Load in 2080-2100 seafloor temperatures ssp585
future_2 <- raster("C:/Users/molloya5.COLLEGE/Desktop/For Aoife/ssp585_2_new/ssp585_2_new.tif")

### d. Load in world map
world_map <- raster("C:/Users/molloya5.COLLEGE/Desktop/For Aoife/NE1_LR_LC.tif")
### Load in ocean
ocean <- raster("C:/Users/molloya5.COLLEGE/Desktop/For Aoife/OB_LR.tif")

## Combine world map and ocean
### ensure extents match
if (!compareRaster(world_map, ocean)) {
stop("Extent and resolution of rasters do not match.")  
}
combined_world <- world_map + ocean
writeRaster(combined_world, "C:/Users/molloya5.COLLEGE/Desktop/For Aoife/combined_world.tif", format = "GTiff")

  # Set the study area to everything from 20 S to the South Pole
  study_area <- extent(-180, 180, -90, 0)  # Adjust as needed
  study_raster <- crop(combined_world, study_area)
  
  # Plot the raster with color gradient for land cover and white for sea
  #color_scheme <- rev(terrain.colors(255))  # You can choose a different color scheme
  #plot(raster_world, col = color_scheme)
  
## 4. Load in species distribution data
  library(readr)
  K_bicolor <- read_csv("K.bicolor.csv") 
  
## 5. Make occurrence data spatial
  #occurrence_Kbic <- K_bicolor[, c("Longitude", "Latitude")]
  #coordinates(occurrence_Kbic) <- c("Longitude", "Latitude")
  # or "      "                 <- ~Longitude + Latitude
  ## look for erroneous points
## 6. Crop temperature raster to match the study area raster
  current_temp <- crop(hist, study_raster)

## 7. Create presence-absence
presence_absence <- matrix(1, nrow = nrow(K_bicolor), ncol = 2)

## 8. Train MaxEnt model
maxent_model <- maxent(x = K_bicolor, p = presence_absence, t = current_temp, args = c("outputformat=raw"))

  