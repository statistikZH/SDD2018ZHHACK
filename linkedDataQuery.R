library(SPARQL) # SPARQL querying package
library(ggplot2)

# Step 1 - Set up preliminaries and define query
# Define the data.gov endpoint
endpoint <- "https://ld.geo.admin.ch/query"

# create query statement
query <- 'PREFIX schema: <http://schema.org/> 
PREFIX gn: <http://www.geonames.org/ontology#> 
PREFIX geo: <http://www.opengis.net/ont/geosparql#> 
PREFIX dct: <http://purl.org/dc/terms/> 
select ?Municipality ?Name 
where {  
  ?Municipality a gn:A.ADM3 .  
  ?Municipality schema:name ?Name .  
  ?Municipality dct:issued ?Date .  
  ?Municipality gn:parentADM1 ?InCanton .  
  ?InCanton schema:name ?CantonName .  
  ?Municipality geo:hasGeometry ?Geometry .  
  ##?Geometry geo:asWKT ?WKT .  
  FILTER (?Date = \"2018-01-01\"^^xsd:date)  
  FILTER (?CantonName = \"Zürich\")
}'
 
# Step 2 - Use SPARQL package to submit query and save results to a data frame
municipalities <- SPARQL(endpoint,query)


