// set the dimensions and margins of the graph
var margin = {top: 30, right: 150, bottom: 30, left: 30},
    width = 700 - margin.left - margin.right,
    height = 400 - margin.top - margin.bottom;

// append the bubblesvg object to the body of the page
var bubblesvg = d3.select("#bubblechart")
    .append("svg")
    .attr("width", width + margin.left + margin.right)
    .attr("height", height + margin.top + margin.bottom)
    // .attr("viewBox", `0 0 700 400`)
    .append("g")
    .attr("transform","translate(" + margin.left + "," + margin.top + ")");

//Read the data
//d3.csv("https://raw.githubusercontent.com/holtzy/data_to_viz/master/Example_dataset/4_ThreeNum.csv", function(data) {
    d3.csv("../data/bubblechart.csv", function(data) {
  // ---------------------------//
  //       AXIS  AND SCALE      //
  // ---------------------------//

  // Add X axis
  var x = d3.scaleLinear()
    .domain([0, 70])
    .range([ 0, width]);
  bubblesvg.append("g")
    .attr("transform", "translate(0," + height + ")")
    .call(d3.axisBottom(x).ticks(10));

  // Add X axis label:
  bubblesvg.append("text")
      .attr("text-anchor", "end")
      .attr("x", width + 110)
      .attr("y", height + 10 )
      .text("Duration (yrs)");

  // Add Y axis
  var y = d3.scaleLinear()
    .domain([0, 450])
    .range([ height, 0]);
  bubblesvg.append("g")
    .call(d3.axisLeft(y));

  // Add Y axis label:
  bubblesvg.append("text")
      .attr("text-anchor", "end")
      .attr("x", -30)
      .attr("y", -15 )
      .text("TCU (in millions)")
      .attr("text-anchor", "start")

  // Add a scale for bubble size
  var z = d3.scaleSqrt()
    //.domain([200000, 1310000000])
    .domain([75, 600])
    .range([ 2, 30]);

  // Add a scale for bubble color
  var myColor = d3.scaleOrdinal()
    .domain(['UK','US', 'Barbados', 'Canada', 'Australia', 'Ireland', 'Sweden', 'Trinidad and Tobago', 'Japan', 'Spain', 'Colombia', 'France', 'Jamaica'])
    .range(d3.schemeCategory20);


  // ---------------------------//
  //      TOOLTIP               //
  // ---------------------------//

  // -1- Create a tooltip div that is hidden by default:
  var tooltip = d3.select("#bubblechart")
    .append("div")
    .style("opacity", 0)
    .attr("class", "tooltip")
    .style("background-color", "#d8dad3")
    .style("border", "solid")
    .style("border-width", "2px")
    .style("border-radius", "5px")
    .style("border-color", "#6d696a")
    .style("padding", "10px")
    .style("color", "black")
    .style("position", "absolute")

  // -2- Create 3 functions to show / update (when mouse move but stay on same circle) / hide the tooltip
  var showTooltip = function(d) {
    tooltip
      .transition()
      .duration(200)
      .style("opacity", 1)
    tooltip
      .html("<span style='color:#6d696a'><b>Artist: </b></span>" + d.Artist)
      .style("left", (event.pageX + 10) + "px" )
      .style("top", (event.pageY) + "px")
      
  }
  var moveTooltip = function(d) {
    tooltip
      .attr("left", (event.pageX + 30) + "px")
      .attr("top", (event.pageY) + "px")
  }
  var hideTooltip = function(d) {
    tooltip
      .transition()
      .duration(200)
      .style("opacity", 0)
  }


  // ---------------------------//
  //       HIGHLIGHT GROUP      //
  // ---------------------------//

  // What to do when one group is hovered
  var highlight = function(d){
    // reduce opacity of all groups
    d3.selectAll(".bubbles").style("opacity", .05)
    // expect the one that is hovered
    d3.selectAll("."+d).style("opacity", 1)
  }

  // And when it is not hovered anymore
  var noHighlight = function(d){
    d3.selectAll(".bubbles").style("opacity", 1)
  }


  // ---------------------------//
  //       CIRCLES              //
  // ---------------------------//

  // Add dots
  bubblesvg.append('g')
    .selectAll("dot")
    .data(data)
    .enter()
    .append("circle")
      .attr("class", function(d) { return "bubbles " + d.Country })
      .attr("cx", function (d) { return x(d.duration_of_career); } )
      .attr("cy", function (d) { return y(d.TCU); } )
      .attr("r", function (d) { return z(d.Sales); } )
      .style("fill", function (d) { return myColor(d.Country); } )
    // -3- Trigger the functions for hover
    .on("mouseover", showTooltip )
    .on("mousemove", moveTooltip )
    .on("mouseleave", hideTooltip )



    // ---------------------------//
    //       LEGEND              //
    // ---------------------------//

    // Add legend: circles
    var valuesToShow = [100, 300, 600]
    var xCircle = 400
    var xLabel = 450
    bubblesvg
      .selectAll("legend")
      .data(valuesToShow)
      .enter()
      .append("circle")
        .attr("cx", xCircle)
        .attr("cy", function(d){ return height - 270 - z(d) } )
        .attr("r", function(d){ return z(d) })
        .style("fill", "none")
        .attr("stroke", "black")

    // Add legend: segments
    bubblesvg
      .selectAll("legend")
      .data(valuesToShow)
      .enter()
      .append("line")
        .attr('x1', function(d){ return xCircle + z(d) } )
        .attr('x2', xLabel)
        .attr('y1', function(d){ return height - 270 - z(d) } )
        .attr('y2', function(d){ return height - 270 - z(d) } )
        .attr('stroke', 'black')
        .style('stroke-dasharray', ('2,2'))

    // Add legend: labels
    bubblesvg
      .selectAll("legend")
      .data(valuesToShow)
      .enter()
      .append("text")
        .attr('x', xLabel)
        .attr('y', function(d){ return height - 270 - z(d) } )
        .text( function(d){ return d } )
        .style("font-size", 10)
        .attr('alignment-baseline', 'middle')

    // Legend title
    bubblesvg.append("text")
      .attr('x', xCircle)
      .attr("y", height - 270 +20)
      .text("Sales (in milions)")
      .attr("font-size", "13px")
      .attr("text-anchor", "middle")

    // Add one dot in the legend for each name.
    var size = 20
    var allgroups = ['UK','US', 'Barbados', 'Canada', 'Australia', 'Ireland', 'Sweden', 'Trinidad-Tobago', 'Japan', 'Spain', 'Colombia', 'France', 'Jamaica']
    bubblesvg.selectAll("myrect")
      .data(allgroups)
      .enter()
      .append("circle")
        .attr("cx", 540)
        .attr("cy", function(d,i){ return 10 + i*(size+5)}) // 100 is where the first dot appears. 25 is the distance between dots
        .attr("r", 7)
        .style("fill", function(d){ return myColor(d)})
        .on("mouseover", highlight)
        .on("mouseleave", noHighlight)

    // Add labels beside legend dots
    bubblesvg.selectAll("mylabels")
      .data(allgroups)
      .enter()
      .append("text")
        .attr("x", 540 + size*.8)
        .attr("y", function(d,i){ return i * (size + 5) + (size/2)}) // 100 is where the first dot appears. 25 is the distance between dots
        .style("fill", function(d){ return myColor(d)})
        .text(function(d){ return d})
        .attr("text-anchor", "left")
        .attr("font-size", "11.5px")
        .style("alignment-baseline", "middle")
        .on("mouseover", highlight)
        .on("mouseleave", noHighlight)

  })