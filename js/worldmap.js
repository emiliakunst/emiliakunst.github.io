var margin = {top: 30, right: 10, bottom: 30, left: 10};

// The svg
var worldmap = d3.select("#worldmap"),
  width = +worldmap.attr("width") - margin.left - margin.right,
  height = +worldmap.attr("height") - margin.top - margin.bottom;



// Map and projection
var path = d3.geoPath();

let projection = d3.geoMercator()
  .scale(135)
  .center([0,20])
  .translate([width / 2, height / 2]);

// // Map and projection
// var projection = d3.geoNaturalEarth1()
//     .scale(width / 1.3 / Math.PI)
//     .translate([width / 2, height / 2])


// Data and color scale
var data = d3.map();
var names = d3.map();

let colorScale = d3.scaleThreshold()
  .domain([0, 20, 60, 100, 200, 1000, 2000, 8000])
  .range(d3.schemeGreys[9]);

// Load external data and boot
d3.queue()
    .defer(d3.json, "https://raw.githubusercontent.com/holtzy/D3-graph-gallery/master/DATA/world.geojson")
    .defer(d3.csv, "./data/worldmap.csv", function(d) {
        data.set(d.Country, +d.TCU);
        names.set(d.Country, d.name)

    })
    .await(ready);

    var tooltip_wm = d3.select("#worldmaptooltip")
    .append("div")
    .style("opacity", 0)
    .attr("class", "tooltip")
    .style("background-color", "#d8dad3")
    .style("border", "solid")
    .style("border-width", "1.5px")
    .style("border-radius", "5px")
    .style("border-color", "#6d696a")
    .style("padding", "7px")
    .style("color", "black")
    .style("font-size", "12.5px")
    .style("position", "absolute")

function ready(error, topo) {

  let mouseOver = function(d) {
    console.log(d, this)
    d3.selectAll(".Country")
      .transition()
      .duration(200)
      .style("opacity", .5)
      .style("stroke", "transparent")
    d3.select(this)
      .transition()
      .duration(200)
      .style("opacity", 1)
      .style("stroke", "black")

    tooltip_wm
      .transition()
      .duration(200)
      .style("opacity", 1)
    tooltip_wm
      .html("<span style='color:#6d696a'><b>Country: </b></span>" + names.get(d.id)
        + "<br><span style='color:#6d696a'><b>TCUs: </b></span>" + data.get(d.id) + " milions")
      .style("left", (event.pageX + 10) + "px" )
      .style("top", (event.pageY) + "px")
  }

  var mouseMove = function(d) {
    tooltip_wm
            .style("left", (event.pageX + 30) + "px")
            .style("top", (event.pageY) + "px")
  }

  let mouseLeave = function(d) {
    d3.selectAll(".Country")
      .transition()
      .duration(200)
      .style("opacity", .8)
      .style("stroke", "transparent")
    d3.select(this)
      .transition()
      .duration(200)
      .style("stroke", "transparent")

    tooltip_wm
      .transition()
      .duration(200)
      .style("opacity", 0)
  }

  // Draw the map
  worldmap.append("g")
    .selectAll("path")
    .data(topo.features)
    .enter()
    .append("path")
      // draw each country
      .attr("d", d3.geoPath()
        .projection(projection)
      )
      // set the color of each country
      .attr("fill", function (d) {
        d.total = data.get(d.id) || 0;
        return colorScale(d.total);
      })
      
      .style("stroke", "black")
      .attr("stroke-width", 0.1)
      .attr("class", function(d){ return "Country" } )
      .style("opacity", .8)
      .on("mouseover", function(d) {
            if(names.has(d.id)) {
                return mouseOver(d)
        }
        })
      .on("mouseleave",  function(d) {
        if(names.has(d.id)) {
            return mouseLeave(d)
        }
    })
      .on("mousemove", function(d) {
        if(names.has(d.id)) {
            return mouseMove(d)
        }
    })
    }