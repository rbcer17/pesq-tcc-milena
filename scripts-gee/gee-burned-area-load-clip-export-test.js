// google earth engine script sample to load 
// MCD64A1.061 MODIS Burned Area Monthly Global 500m
//
//burned area script lines 8 to 17
//
// clip to shape script lines 21 to 58
// export image example line 61 to 67
var dataset = ee.ImageCollection('MODIS/061/MCD64A1')
                  .filter(ee.Filter.date('2017-01-01', '2018-05-01'));
var burnedArea = dataset.select('BurnDate');
var burnedAreaVis = {
  min: 30.0,
  max: 341.0,
  palette: ['4e0400', '951003', 'c61503', 'ff1901'],
};
Map.setCenter(6.746, 46.529, 2);
Map.addLayer(burnedArea, burnedAreaVis, 'Burned Area');
//
// google earth engine script example to clip to shape
//
// A digital elevation model.
var dem = ee.Image('NASA/NASADEM_HGT/001');
var demVis = {bands: 'elevation', min: 0, max: 1500};

// Clip the DEM by a polygon geometry.
var geomPoly = ee.Geometry.BBox(-121.55, 39.01, -120.57, 39.38);
var demClip = dem.clip(geomPoly);
print('Clipped image retains metadata and band names', demClip);
Map.setCenter(-121.12, 38.13, 8);
Map.addLayer(demClip, demVis, 'Polygon clip');
Map.addLayer(geomPoly, {color: 'green'}, 'Polygon geometry', false);

// Clip the DEM by a line geometry.
var geomLine = ee.Geometry.LinearRing(
    [[-121.19, 38.10], [-120.53, 38.54], [-120.22, 37.83], [-121.19, 38.10]]);
Map.addLayer(dem.clip(geomLine), demVis, 'Line clip');
Map.addLayer(geomLine, {color: 'orange'}, 'Line geometry', false);

// Images have geometry; clip the dem image by the geometry of an S2 image.
var s2Img = ee.Image('COPERNICUS/S2_SR/20210109T185751_20210109T185931_T10SEG');
var geomS2Img = s2Img.geometry();
Map.addLayer(dem.clip(geomS2Img), demVis, 'Image geometry clip');
Map.addLayer(geomS2Img, {color: 'blue'}, 'Image geometry', false);

// Don't use ee.Image.clip prior to ee.Image.regionReduction, the "geometry"
// parameter handles it more efficiently.
var zonalMax = dem.select('elevation').reduceRegion({
  reducer: ee.Reducer.max(),
  geometry: geomPoly
});
print('Max elevation (m)', zonalMax.get('elevation'));

// Don't use ee.Image.clip to clip an image by a FeatureCollection, use
// ee.Image.clipToCollection(collection).
var watersheds = ee.FeatureCollection('USGS/WBD/2017/HUC10')
    .filterBounds(ee.Geometry.Point(-122.754, 38.606).buffer(2e4));
Map.addLayer(dem.clipToCollection(watersheds), demVis, 'Watersheds clip');
Map.addLayer(watersheds, {color: 'red'}, 'Watersheds', false);
//
//
// export image example
// Load a landsat image and select three bands.
var landsat = ee.Image('LANDSAT/LC08/C01/T1_TOA/LC08_123032_20140515')
  .select(['B4', 'B3', 'B2']);

// Create a geometry representing an export region.
var geometry = ee.Geometry.Rectangle([116.2621, 39.8412, 116.4849, 40.01236]);