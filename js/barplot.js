// set the dimensions and margins of the graph
var margin = {top: 30, right: 150, bottom: 30, left: 30},
    width = 700 - margin.left - margin.right,
    height = 400 - margin.top - margin.bottom;

// append the svg object to the body of the page
var barplot = d3.select("#barplot")
  .append("svg")
    .attr("width", width + margin.left + margin.right)
    .attr("height", height + margin.top + margin.bottom)
  .append("g")
    .attr("transform",
          "translate(" + margin.left + "," + margin.top + ")");




// Parse the Data
d3.csv("./data/barplot.csv", function(data) {

  // List of subgroups = header of the csv files = soil condition here
  var subgroups = data.columns.slice(1)

  // List of groups = species here = value of the first column called group -> I show them on the X axis
  var groups = d3.map(data, function(d){return(d.year)}).keys()

  // Add X axis
  var x = d3.scaleBand()
      .domain(groups)
      .range([0, width])
      .padding([0.2])
  barplot.append("g")
    .attr("transform", "translate(0," + height + ")")
    .call(d3.axisBottom(x).tickSize(0));

  
  // Add X label
  barplot.append("text")
            .attr("text-anchor", "end")
            .attr("x", width + 35)
            .attr("y", height + 10)
            .text("Year")
            .style('font-size', '13.5px');

  // Add Y axis
  var y = d3.scaleLinear()
    .domain([0, 80])
    .range([ height, 0 ]);
  barplot.append("g")
    .call(d3.axisLeft(y).tickValues([10,30,50,70]));
  
  
  // Add Y axis label
  barplot.append("text")
            .attr("text-anchor", "end")
            .attr("x", 57)
            .attr("y", -12)
            .text("Number of Artists")
            .style('font-size', '11.5px');


  // Another scale for subgroup position?
  var xSubgroup = d3.scaleBand()
    .domain(subgroups)
    .range([0, x.bandwidth()])
    .padding([0.05])

  // color palette = one color per subgroup
  var color = d3.scaleOrdinal()
    .domain(subgroups)
    .range(['#6d696a','#100007','#4daf4a'])

  // -1- Create a tooltip div that is hidden by default:
  var tooltip = d3.select("#barplot")
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

  // -2- Create 3 functions to show / update (when mouse move but stay on same circle) / hide the tooltip
  let showTooltip = function(d) {
    tooltip
      .transition()
      .duration(200)
      .style("opacity", 1)
    tooltip
      .html("<span style='color:#6d696a'><b>"+d.key+": </b></span>" + d.value)
      .style("left", (event.pageX + 15) + "px" )
      .style("top", (event.pageY) + "px");
      
  }
  let moveTooltip = function(d) {
    tooltip
      .attr("left", (event.pageX + 15) + "px")
      .attr("top", (event.pageY) + "px");
      console.log(event.pageX, event.pageY)
  }
  var hideTooltip = function(d) {
    tooltip
      .transition()
      .duration(200)
      .style("opacity", 0)
  }

  // Show the bars
  barplot.append("g")
    .selectAll("g")
    // Enter in data = loop group per group
    .data(data)
    .enter()
    .append("g")
      .attr("transform", function(d) { return "translate(" + x(d.year) + ",0)"; })
    .selectAll("rect")
    .data(function(d) { return subgroups.map(function(key) { return {key: key, value: d[key]}; }); })
    .enter().append("rect")
      .attr("class", function(d) {return "bars "+ d.key})
      .attr("x", function(d) { return xSubgroup(d.key); })
      .attr("y", function(d) { return y(d.value); })
      .attr("width", xSubgroup.bandwidth())
      .attr("height", function(d) { return height - y(d.value); })
      .attr("fill", function(d) { return color(d.key); })
    .on("mouseover", showTooltip)
    .on("mouseleave", hideTooltip)
    .on("mousemove", moveTooltip )
      ;

  var keys = ['male', 'female']

  var highlight = function(d){
    // reduce opacity of all lines
        d3.selectAll(".bars").style("opacity", .1)
        // expect the one that is hovered
        d3.selectAll("."+d).style("opacity", 1)
    }
        
    // And when it is not hovered anymore
    var noHighlight = function(d){
        d3.selectAll(".bars").style("opacity", 1)
    }

  var size = 15
  barplot.selectAll("mydots")
  .data(keys)
  .enter()
  .append("rect")
    .attr("x", 540)
    .attr("y", function(d,i){ return 120 + i*(size+15)}) // 100 is where the first dot appears. 25 is the distance between dots
    .attr("width", size)
    .attr("height", size)
    .style("fill", function(d){ return color(d)})
    .on("mouseover", highlight)
    .on("mouseleave", noHighlight)

  barplot.selectAll("mylabels")
  .data(keys)
  .enter()
  .append("text")
    .attr("x", 543 + size*1.2)
    .attr("y", function(d,i){ return 120 + i*(size+15) + (size/2)}) // 100 is where the first dot appears. 25 is the distance between dots
    .style("fill", function(d){ return color(d)})
    .text(function(d){ return d})
    .attr("text-anchor", "left")
    .style("alignment-baseline", "middle")
    .style("font-size", 11)
    .on("mouseover", highlight)
    .on("mouseleave", noHighlight)

})