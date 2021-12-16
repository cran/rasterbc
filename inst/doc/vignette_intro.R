## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.path = "man/figures/vignette_intro_",
  out.width = "100%",
  dpi = 300,
  fig.width = 6,
  fig.height = 5
)

## ----installation, eval=FALSE-------------------------------------------------
#  library(devtools)
#  install_github('deankoch/rasterbc')

## ----libraries, results="hide"------------------------------------------------
library(sf)
library(terra)
library(bcmaps)
library(rasterbc)

## ----initializing-------------------------------------------------------------
# replace NA with your own path, like 'C:/rasterbc_data'
datadir_bc(NA, quiet=TRUE)

## ----view-datadir-------------------------------------------------------------
datadir_bc()

## ----okanagan_location--------------------------------------------------------
# define and load the geometry
example.name = 'Regional District of Central Okanagan'
bc.bound.sf = bc_bound()
districts.sf = regional_districts()
example.sf = districts.sf[districts.sf$ADMIN_AREA_NAME==example.name, ]

# plot against map of BC
blocks = findblocks_bc(type='sfc')
plot(st_geometry(blocks), main=example.name, border='red')
plot(st_geometry(bc.bound.sf), add=TRUE, col=adjustcolor('blue', alpha.f=0.2))
plot(st_geometry(example.sf), add=TRUE, col=adjustcolor('yellow', alpha.f=0.5))
text(st_coordinates(st_centroid(st_geometry(blocks))), labels=blocks$NTS_SNRC, cex=0.5)

## ----blocks-------------------------------------------------------------------
print(blocks)

## ----finblocks-example--------------------------------------------------------
findblocks_bc(example.sf)

## ----get-example--------------------------------------------------------------
getdata_bc(geo=example.sf, collection='dem', varname='dem')

## ----get-example-again, R.options = list(width = 15)----
getdata_bc(geo=example.sf, collection='dem', varname='dem')

## ----okanagan_elevation, R.options = list(width = 15)----

tif.path = file.path(datadir_bc(), 'dem/blocks/dem_092H.tif')
example.raster = terra::rast(tif.path)
print(example.raster)
plot(example.raster, main='elevation (metres)')

## ----okanagan_elevation_clipped-----------------------------------------------
example.tif = opendata_bc(example.sf, collection='dem', varname='dem')
print(example.tif)
plot(example.tif, main=paste(example.name, ': elevation'))
plot(st_geometry(example.sf), add=TRUE)
plot(st_geometry(blocks), add=TRUE, border='red')

## ----okanagan_elevation_tiles, R.options = list(width = 10)----
example.codes = findblocks_bc(example.sf)
example.tif = opendata_bc(example.codes, collection='dem', varname='dem')
plot(example.tif, main=paste('NTS/SNRC mapsheets ', paste(example.codes, collapse=', '), ': elevation'))
plot(st_geometry(blocks), add=TRUE, border='red')
plot(st_geometry(example.sf), add=TRUE)
text(st_coordinates(st_centroid(st_geometry(blocks))), labels=blocks$NTS_SNRC, cex=0.5)

## ----listdata_bc-first, R.options = list(width = 10)----
is.downloaded = listdata_bc(collection='dem', varname='dem', simple=TRUE)
paste('downloaded: ', sum(is.downloaded), '/', length(is.downloaded)) |> print()

## ----listdata_bc-second, R.options = list(width = 125)---------------------------------------------------------------------
listdata_bc(collection='dem', verbose=2)

## ----save-example, R.options = list(width = 15)----
dem.path = file.path(getOption('rasterbc.data.dir'), 'dem', 'example_dem.tif')
terra::writeRaster(example.tif, dem.path, overwrite=TRUE)

## ----load-saved-file, R.options = list(width = 15)----
terra::rast(dem.path)

## ----load-lookup, R.options = list(width = 15)----
lookup.list = rasterbc::metadata_bc$bgcz$metadata$coding
print(lookup.list$zone)

## ----okanagan_bgcz------------------------------------------------------------

# open the biogeoclimatic zone raster
bgcz.raster = opendata_bc(geo=example.sf, collection='bgcz', varname='zone', quiet=TRUE)

# set up a colour palette and plot with legend defined manually
plot(bgcz.raster, col=rainbow(5), main='Biogeoclimatic zones')
plot(st_geometry(example.sf), add=TRUE)


