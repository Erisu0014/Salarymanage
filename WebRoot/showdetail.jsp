<%@ page language="java" contentType="text/html; Charset=GB2312"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.bean.Mybean.*" %>
<jsp:useBean id="Ename" class="com.bean.Mybean.EntityName" scope="request"/>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>薪酬管理知识图谱</title>
    <style>
        * {
            margin: 0;
            padding: 0;
        }

        #visual {
            position: relative;
            width: 800px;
            height: 600px;
            margin: auto;
            top: 50px;
            left: 0;
        }

        .tooltip {
            position: absolute;
            width: 150px;
            height: auto;
            font-family: simsun;
            font-size: 15px;
            padding: 3px;
            text-align: center;
            border-style: solid;
            border-width: 1px;
            background-color: #F5F5F5;
            border-radius: 5px;
        }
    </style>
    <link rel="stylesheet" href="static/css/bootstrap.css">
    <link rel="stylesheet" href="static/css/bootstrap-theme.min.css">
    <link rel="stylesheet" href="static/css/font-awesome.min.css">
    <link rel="stylesheet" href="static/css/animate.min.css">
    <link rel="stylesheet" href="static/css/style2.css">
    <script src="static/js/d3.min.js" type="text/javascript"></script>
    <script src="static/js/jquery-1.10.2.js"></script>
    <script>
        var nodes = [], links = [];
        var name = "<%=Ename.getName()%>";
        window.onload = function () {
            MyVisual();
        }

        function idIndex(a, id) {
            for (var i = 0; i < a.length; i++) {
                if (a[i].id == id) return i;
            }
            return null;
        }

        function MyD3(nodes, links) {
            var width = 1000, height = 800;
            var svg = d3.select("#visual").append("svg").attr("width", width).attr("height", height);
            var isNewCircle = new Array(1000);
            var isNewLine = new Array(1000);
            var zoom = d3.behavior.zoom().scaleExtent([0.4, 2]).on("zoom", zoomed);
            var tooltip = d3.select("body").append("div").attr("class", "tooltip").style("opacity", 0.0);
            var force = d3.layout.force().nodes(d3.values(nodes)).links(links).size([width, height]).linkDistance(300).charge(-800).on("tick", tick).start();
            svg.call(zoom).on("dblclick.zoom", null);
            var edges_line = svg.append("g").selectAll(".edgepath").data(force.links()).enter().append("path")
                .attr({
                    'd': function (d) {
                        return 'M ' + d.source.x + ' ' + d.source.y + ' L ' + d.target.x + ' ' + d.target.y
                    }, 'class': 'edgepath', 'id': function (d, i) {
                        return 'edgepath' + i;
                    }
                })
                .style("stroke", function (d) {
                    var lineColor;
                    lineColor = "#9370DB";
                    return lineColor;
                }).style("pointer-events", "none").style("stroke-width", 1)
                .on("mouseover", function (d) {
                    tooltip.html(d.relatype).style("left", (d3.event.pageX) + "px").style("top", (d3.event.pageY + 20) + "px").style("top", (d3.event.pageY + 20) + "px").style("opacity", 1.0);
                })
                .on("mouseout", function (d) {
                    tooltip.style("opacity", 0.0);
                });
            var edges_text = svg.append("g").selectAll(".edgelabel").data(force.links()).enter().append("text").style("pointer-events", "none")
                .attr({
                    'class': 'edgelabel', 'id': function (d, i) {
                        return 'edgepath' + i;
                    }, 'dx': 80, 'dy': 0
                }).style("font-size", 12);
            edges_text.append('textPath').attr('xlink:href', function (d, i) {
                return '#edgepath' + i
            }).style("pointer-events", "none").text(function (d) {
                return d.type;
            });
            var circle = svg.append("g").selectAll("circle").data(force.nodes()).enter().append("circle")
                .style("fill", function (node) {
                    var color;
                    color = "#00BFFF";
                    return color;
                })
                .style('stroke', function (node) {
                    var color;
                    color = "#000080";
                    return color;
                }).style("stroke-width", 3).attr("r", function (node) {
                    var r;
                    r = 20 + set_r(node.id);
                    return r;
                })
                .call(drag()).on("mouseover", function (d) {
                    var str = "";
                    for (key in d) {
                        if (key == "label") {
                            str += key + ":" + d[key] + "<br/>";
                        } else {
                            if (/^[\u4e00-\u9fa5]/.test(key)) {
                                str += key + ":" + d[key] + "<br/>";
                            }
                        }
                    }
                    tooltip.html(str).style("left", (d3.event.pageX) + "px").style("top", (d3.event.pageY + 20) + "px").style("top", (d3.event.pageY + 20) + "px").style("opacity", 1.0);
                })
                .on("mouseout", function (d) {
                    tooltip.style("opacity", 0.0);
                })
                .on("dblclick.zoom", null)
                .on("dblclick", function (node) {
                    document.getElementById("i1").value = node.名称;
                    form.submit();
                });
            var text = svg.append("g").selectAll("text").data(force.nodes()).enter().append("text").attr("dy", ".35em").attr("text-anchor", "middle")
                .style('fill', function (node) {
                    var color;
                    color = "#F5F5F5";
                    return color;
                }).attr('x', function (d) {
                    name = d.名称;
                    name = name.toString();
                    if (name.length <= 4) {
                        d3.select(this).append('tspan').attr('x', 0).attr('y', 2).text(function () {
                            return name;
                        });
                    } else {
                        var top = name.substring(0, 4);
                        var bot = name.substring(4, name.length);
                        d3.select(this).text(function () {
                            return '';
                        });
                        d3.select(this).append('tspan').attr('x', 0).attr('y', -7).text(function () {
                            return top;
                        });
                        d3.select(this).append('tspan').attr('x', 0).attr('y', 10).text(function () {
                            return bot;
                        });
                    }
                }).style("font-size", 13)
                .on("mouseover", function (d) {
                    var str = "";
                    for (key in d) {
                        if (key == "label") {
                            str += key + ":" + d[key] + "<br/>";
                        } else {
                            if (/^[\u4e00-\u9fa5]/.test(key)) {
                                str += key + ":" + d[key] + "<br/>";
                            }
                        }
                    }
                    tooltip.html(str).style("left", (d3.event.pageX) + "px").style("top", (d3.event.pageY + 20) + "px").style("top", (d3.event.pageY + 20) + "px").style("opacity", 1.0);
                })
                .on("mouseout", function (d) {
                    tooltip.style("opacity", 0.0);
                }).call(drag())
                .on("dblclick.zoom", null)
                .on("click", function (node) {

                });

            function zoomed() {
                svg.selectAll("g").attr("transform",//svg下的g标签移动大小
                    "translate(" + d3.event.translate + ")scale(" + d3.event.scale + ")");
            }

            function drag() {//拖拽函数
                return force.drag()
                    .on("dragstart", function (d) {
                        d3.event.sourceEvent.stopPropagation(); //取消默认事件
                        d.fixed = true;    //拖拽开始后设定被拖拽对象为固定

                    });
            }

            function tick() {
                circle.attr("transform", transform1);
                text.attr("transform", transform2);
                edges_line.attr('d', function (d) {
                    var path = 'M ' + d.source.x + ' ' + d.source.y + ' L ' + d.target.x + ' ' + d.target.y;
                    return path;
                });
                edges_text.attr('transform', function (d, i) {
                    if (d.target.x < d.source.x) {
                        bbox = this.getBBox();
                        rx = bbox.x + bbox.width / 2;
                        ry = bbox.y + bbox.height / 2;
                        return 'rotate(180 ' + rx + ' ' + ry + ')';
                    } else {
                        return 'rotate(0)';
                    }
                });
            }

            function zoomed() {
                svg.selectAll("g").attr("transform", "translate(" + d3.event.translate + ")scale(" + d3.event.scale + ")");
            }

            function set_r(id) {
                var r = 0;
                for (var i = 0; i < links.length; i++) {
                    if (id == links[i].source.id || id == links[i].target.id) {
                        r++;
                    }
                }
                return r;
            }

            function isOne(num1, num2) {
                for (var i = 0; i < links.length; i++) {
                    if ((num1 == links[i].source.id && num2 == links[i].target.id) || (num2 == links[i].source.id && num1 == links[i].target.id)) {
                        return true;
                    }
                }
                return false;
            }
        }

        function transform1(d) {
            return "translate(" + d.x + "," + d.y + ")";
        }

        function transform2(d) {
            return "translate(" + (d.x) + "," + d.y + ")";
        }

        function isObjectValueEqual(a, b) {
            var aProps = Object.getOwnPropertyNames(a);
            var bProps = Object.getOwnPropertyNames(b);
            if (aProps.length != bProps.length) {
                return false;
            }
            for (var i = 0; i < aProps.length; i++) {
                var propName = aProps[i];
                if (a[propName] !== b[propName]) {
                    return false;
                }
            }
            return true;
        }

        function isInArray(arr, value) {
            for (var i = 0; i < arr.length; i++) {
                if (isObjectValueEqual(value, arr[i])) {
                    return true;
                }
            }
            return false;
        }

        function MyVisual() {
            $(document).ready(function () {
                $.ajax({
                    url: "http://123.56.8.150/Salarymanage/Searchrelation",
                    dataType: "json",
                    type: "post",
                    async: true,
                    data: {"name": name, "series": "1"},
                    success: function (str) {
                        var count = 0;
                        str.results[0].data.forEach(function (row) {
                            row.graph.nodes.forEach(function (n) {
                                var obj = new Object();
                                obj["id"] = n.id;
                                obj["label"] = n.labels[0];
                                for (key in n.properties) {
                                    obj[key] = n.properties[key];
                                }
                                if (!isInArray(nodes, obj)) {
                                    nodes.push(obj);
                                }

                            });
                            links = links.concat(row.graph.relationships.map(function (r) {
                                return {
                                    source: idIndex(nodes, r.startNode),
                                    target: idIndex(nodes, r.endNode),
                                    type: r.type,
                                    relatype: r.relationtype
                                };
                            }));
                        });
                        MyD3(nodes, links);
                    }
                })
            })
        }
    </script>
</head>
<body>
<!-- service -->
<!-- Container (Services Section) -->
<section id="Service" class="service-section">
    <div class="container text-center">
        <h2 class="wow zoomIn">${entityName.name}</h2>
        <br>
    </div>
</section>
<!-- service -->
<section id="Portfolio" class="portfolio-section">
    <div class="container-fluid">
        <div class="row">
            <div class="col-md-12 cont-padding  col-sm-8   col-xs-12">
                <c:if test="${not empty entityName.define}">
                    <div class="portfolio-info">
                        <i class="fa fa-book"></i>
                        <div class="portfolio-item-details">
                            <h4>定义</h4>
                            <p>${entityName.define}</p>
                        </div>
                    </div>
                </c:if>
                <c:if test="${not empty entityName.sentence}">
                    <div class="portfolio-info">
                        <i class="fa fa-star"></i>
                        <div class="portfolio-item-details">
                            <h4>金句</h4>
                            <p>${entityName.sentence}</p>
                        </div>
                    </div>
                </c:if>
                <div class="portfolio-info">
                    <i class="fa fa-link"></i>
                    <div class="portfolio-item-details">
                        <h4>关联实体</h4>
                        <div id="visual"></div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>
<form name="form" method="post" action="Getname" target="_blank">
    <input id="i1" type="hidden" name="name" value="">
</form>
<script src="static/js/wow.js"></script>
<script>
    new WOW().init();
</script>
</body>
</html>