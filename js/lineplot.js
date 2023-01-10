// set the dimensions and margins of the graph
var margin = {top: 20, right: 150, bottom: 30, left: 30},
    width = 700 - margin.left  - margin.right,
    height = 400 - margin.top - margin.bottom;

// append the svg object to the body of the page
var svg = d3.select("#lineplot")
    .append("svg")
    .attr("width", width + margin.left + margin.right)
    .attr("height", height + margin.top + margin.bottom)
    .append("g")
    .attr("transform",
        "translate(" + margin.left + "," + margin.top + ")");

//Read the data
d3.csv("../data/lineplot.csv", function(data) {

  // group the data: I want to draw one line per group
  var sumstat = d3.nest() // nest function allows to group the calculation per level of a factor
    .key(function(d) { return d.Country;})
    .entries(data);

  // Add X axis --> it is a date format
  var x = d3.scaleLinear()
    .domain(d3.extent(data, function(d) { return d.year; }))
    .range([ 0, width ]);
  svg.append("g")
    .attr("transform", "translate(0," + height + ")")
    .call(d3.axisBottom(x).tickFormat(d3.format("")).ticks(15))
    .selectAll("text")
    .attr("y", 9)
    .attr("x", 15)
    .attr("transform", "translate(5,0)rotate(45)")
    .style('font-size', '11px')

  // Add X label
  svg.append("text")
            .attr("text-anchor", "end")
            .attr("x", width + 32)
            .attr("y", height + 10)
            .text("Year")
            .style('font-size', '11.5px');


  // Add Y axis
  var y = d3.scaleLinear()
    .domain([0, d3.max(data, function(d) { return +d.Count; })])
    .range([ height, 0 ]);
  svg.append("g")
    .call(d3.axisLeft(y))
    .style('font-size', '11px')

  // Add Y axis label
  svg.append("text")
            .attr("text-anchor", "end")
            .attr("x", 60)
            .attr("y", -5)
            .text("Number of Artists")
            .style('font-size', '11.5px');

  // color palette
  var res = sumstat.map(function(d){ return d.key }) // list of group names
  var color = d3.scaleOrdinal()
    .domain(res)
    .range(d3.schemeCategory20)

  // Draw the line
  svg.selectAll(".line")
      .data(sumstat)
      .enter()
      .append("path")
        .attr("fill", "none")
        .attr("class", function(d) {return "lines "+ d.key})
        .attr("stroke", function(d){ return color(d.key) })
        .attr("stroke-width", 3)
        .attr("d", function(d){
          return d3.line()
            .x(function(d) { return x(d.year); })
            .y(function(d) { return y(+d.Count); })
            (d.values)
        });

  var highlight = function(d){
  // reduce opacity of all lines
      d3.selectAll(".lines").style("opacity", .05)
      // expect the one that is hovered
      d3.selectAll("."+d).style("opacity", 1)
  }
      
  // And when it is not hovered anymore
  var noHighlight = function(d){
      d3.selectAll(".lines").style("opacity", 1)
  }
      


  var size = 22
  var moveX = 150
  var xCircle = 390 + moveX

  svg.selectAll("myrect")
      .data(res)
      .enter()
      .append("circle")
      .attr("cx", xCircle)
      .attr("cy", function (d, i) { return 10 + i * (size + 5) }) // 100 is where the first dot appears. 25 is the distance between dots
      .attr("r", 7)
      .style("fill", function (d) { return color(d) })
      .on("mouseover", highlight)
      .on("mouseleave", noHighlight)
  
  svg.selectAll("mylabels")
      .data(res)
      .enter()
      .append("text")
      .attr("x", xCircle + size * .8)
      .attr("y", function (d, i) { return i * (size + 5) + (size / 2) }) // 100 is where the first dot appears. 25 is the distance between dots
      .style("fill", function (d) { return color(d) })
      .text(function (d) { return d })
      .attr("text-anchor", "left")
      .style("alignment-baseline", "middle")
      .style('font-size', '11.5px')
      .on("mouseover", highlight)
      .on("mouseleave", noHighlight)           

})
