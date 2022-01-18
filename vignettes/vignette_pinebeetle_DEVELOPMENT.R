# FIDS example vignette


library(sf)
library(terra)
library(bcmaps)
library(rasterbc)



# set the data download directory
datadir_bc('C:/rasterbc_data', quiet=TRUE)

# set up a study area polygon
example.name = 'Regional District of Central Okanagan'
bc.bound.sf = bc_bound()
districts.sf = regional_districts()
example.sf = districts.sf[districts.sf$ADMIN_AREA_NAME==example.name, ]

# list the FIDS data layers for mountain pine beetle (code "IBM")
example.pestcode = 'IBM'
df.fids.all = listdata_bc('fids')
df.mpb = df.fids.all[grepl(example.pestcode, rownames(df.fids.all)), ]
print(df.mpb)

# set an example year and damage type layers to fetch
yr.example = 2008
dmg.levels = c('trace', 'light', 'moderate', 'severe', 'verysevere')
hybrid.level = 'mid'

# fetch and load the layers for the example year
vnames = paste(example.pestcode, dmg.levels, sep='_')
eg.rasterlist = sapply(vnames, \(v) opendata_bc(geo=example.sf, 'fids', v, yr.example, quiet=TRUE))

# make a panel of plots showing different severity levels
cpoint = st_geometry(example.sf) |> st_centroid() |> st_transform(crs(eg.rasterlist[[1]])) |> st_coordinates()
par(mfrow=c(1,5))
mapply(\(r, label) {

  plot(r, mar=c(0,0,0,0), legend=FALSE, axes=FALSE, reset=FALSE)
  graphics::text(x=cpoint[[1]], y=cpoint[[2]], label)

}, r=eg.rasterlist, label=dmg.levels)


# download and plot the hybrid damage estimate in the example year
dev.off()
hybrid.vname = paste(example.pestcode, hybrid.level, sep='_')
hybrid.raster = opendata_bc(geo=example.sf, 'fids', hybrid.vname, yr.example, quiet=TRUE)
plot(hybrid.raster, main='estimated damage levels (% susceptible killed) - surveyed in 2008')

# download and plot the hybrid damage estimates for a selection of years
yrs.all = 2004:2013
mpb.rasterlist = sapply(yrs.all, \(yr) opendata_bc(geo=example.sf, 'fids', hybrid.vname, yr, quiet=TRUE))
par(mfrow=c(2,5))
mapply(\(r, label) {

  plot(r, mar=c(0,0,0,0), legend=FALSE, axes=FALSE, reset=FALSE)
  graphics::text(x=cpoint[[1]], y=cpoint[[2]], label)

}, r=mpb.rasterlist, label=yrs.all)

#
sum()





vname.example = c('')



# open an example FIDS damage raster for mountain pine beetle
yr = 2008
eg.raster = opendata_bc(geo=example.sf, collection='fids', varname='IBM_mid', year=yr)
plot(eg.raster)


# set up a colour palette and plot with legend defined manually
plot(bgcz.raster, col=rainbow(5), main='Biogeoclimatic zones')
plot(st_geometry(example.sf), add=TRUE)


