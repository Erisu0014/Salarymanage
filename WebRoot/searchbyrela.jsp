<%@ page language="java" contentType="text/html; Charset=GB2312"
         pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title></title>
    <link href="http://cdn.bootcss.com/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet">
    <script src="d3.min.js" type="text/javascript"></script>
    <script src="https://cdn.staticfile.org/jquery/1.10.2/jquery.min.js"></script>
    <style>
        * {
            box-sizing: border-box;
        }

        body {

            padding: 0;
            font-weight: 500;
            font-family: "Microsoft YaHei", "宋体", "Segoe UI", "Lucida Grande", Helvetica, Arial, sans-serif, FreeSans, Arimo;
        }

        #container {
            width: 100%;
            height: 500px;
            margin: 0 auto;
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
            text-align: left;
        }

        div.search {
            padding: 15px 0;
        }

        div.form {
            position: relative;
            width: 500px;
            margin: 0 auto;
        }

        input, button {
            border: none;
            outline: none;
        }

        input {
            width: 100%;
            height: 42px;
            padding-left: 13px;
        }

        button {
            height: 42px;
            width: 42px;
            cursor: pointer;
            position: absolute;
        }

        .bar1 input {
            border: 2px solid #7BA7AB;
            border-radius: 5px;
            background: #F0F8FF;
            color: #9E9C9C;
        }

        .bar1 button {
            top: 0;
            right: 0;
            background: #7BA7AB;
            border-radius: 0 5px 5px 0;
        }

        .bar1 button:before {
            content: "\f002";
            font-family: FontAwesome;
            font-size: 16px;
            color: #F9F0DA;
        }

        #visual {
            position: absolute;
            width: 800px;
            height: 500px;
            margin: auto;
            top: 100px;
            left: 0;
            right: 0;
        }
    </style>
    <script>
        var nodes = [], links = [];

        function idIndex(a, id) {
            for (var i = 0; i < a.length; i++) {
                if (a[i].id == id) return i;
            }
            return null;
        }

        var cnt = 0;

        function MyD3(nodes, links) {
            if (cnt != 0) {
                d3.select('svg').remove();
            }
            cnt++;
            var width = 1000, height = 800;
            var svg = d3.select("#visual").append("svg").attr("width", width).attr("height", height);
            var circleRad = new Array();
            var zoom = d3.behavior.zoom().scaleExtent([0.4, 2]).on("zoom", zoomed);
            var tooltip = d3.select("body").append("div").attr("class", "tooltip").style("opacity", 0.0);
            var force = d3.layout.force().nodes(d3.values(nodes)).links(links).size([width, height]).linkDistance(250).charge(-800).on("tick", tick).start();
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
                }).style("stroke-width", 1).attr("r", function (node, i) {
                    var r;
                    r = 20 + set_r(node.id);
                    circleRad[node.id] = r;
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
                .on("mousedown", function () {
                    d3.select(this).attr("r", function (node) {
                        return circleRad[node.id] + 2;
                    })
                })
                .on("mouseup", function () {
                    d3.select(this).attr("r", function (node) {
                        return circleRad[node.id];
                    })
                })
                .on("dblclick.zoom", null)
                .on("click", function (node) {
                    edges_line.style("stroke-width", function (line) {
                        if (line.source.id == node.id || line.target.id == node.id) {//当与连接点连接时变粗
                            return 3;
                        } else {
                            return 1;
                        }
                    });
                    circle.style('stroke-width', 1);
                    circle.style('stroke-width', function (d) {
                        if (d.id != node.id && isOne(d.id, node.id)) {
                            return 4;
                        }
                    });
                    d3.select(this).style('stroke-width', 4);
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
                .on("mousedown", function () {
                    d3.select(this).attr("r", function (node) {
                        return circleRad[node.id] + 2;
                    })
                })
                .on("mouseup", function () {
                    d3.select(this).attr("r", function (node) {
                        return circleRad[node.id];
                    })
                })
                .on("dblclick.zoom", null)
                .on("click", function (node) {
                    edges_line.style("stroke-width", function (line) {
                        if (line.source.id == node.id || line.target.id == node.id) {//当与连接点连接时变粗
                            return 3;
                        } else {
                            return 1;
                        }
                    });
                    circle.style('stroke-width', 1);
                    circle.style('stroke-width', function (d) {
                        if (d.id != node.id && isOne(d.id, node.id)) {
                            return 4;
                        }
                    });
                    d3.select(this).style('stroke-width', 4);
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

        function mysend() {
            $("#ul").empty();
            document.getElementById('ul').style.display = 'none';
            var name = document.getElementById("i1").value;
            $(document).ready(function () {
                $.ajax({
                    url: "http://47.92.155.245/Salarymanage/Searchbyrela",
                    dataType: "json",
                    type: "post",
                    async: true,
                    data: {"name": name},
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
    <style>


        ul {
            list-style: none;
            width: 300px;
            padding: 0;
            margin: 0;
            border: 1px solid #ccc;
            display: none;
        }

        ul li {
            list-style: none;
            width: 300px;
            height: 30px;
            line-height: 30px;
            background-color: cornflowerblue;
        }

        ul li a {
            display: block;
            color: #333;
            text-decoration: none;
        }

        ul li a:hover {
            background: #ccc;
        }

    </style>
    <script>
        var searchCondition="";
        function getsup(a) {
            var oTxt = document.getElementById('i1');
            oTxt.value = a.innerText;
            change();
        }

        function fn(data) {
            //console.log(data)
            var oUl = document.getElementById('ul');
            var html = "";
            for (var i = 0; i < data.length; i++) {
                //html+='<li>'+data[i]+'</li>';
                html += '<li><a onclick="getsup(this)">' + data[i] + '</a></li>';
            }
            oUl.innerHTML = html;
        }

        /*
        实时改变
         */
        function change() {
            var oUl = document.getElementById('ul');
            var oTxt = document.getElementById('i1');
            var form = $("#i1").val();
            //console.log(form);
            $.ajax({
                url: "http://47.92.155.245/Salarymanage/test?form=" + form+"&name=relation",
                type: "get",
                dataType: "json",
                processData: false,
                contentType: false,
                async: true,
                success: function (data) {
                    //console.log(data);
                    if(data!=null){
                        searchCondition=data[0];
                        fn(data);
                    }
                },
                error: function () {
                    console.log("wrong");
                }
            });
            //oS.src='https://sp0.baidu.com/5a1Fazu8AA54nxGko9WTAnF6hhy/su?wd='+oTxt.value+'&cb=fn';//从百度获取的接口数据
            //oHead.appendChild(oS);
            if (oTxt.value != '') {
                oUl.style.display = 'block';
            } else {
                oUl.style.display = 'none';
            }

        }

        window.onload = function () {
            var oTxt = document.getElementById('i1');
            oTxt.onkeyup = function () {
                //var oS=document.createElement('script');//动态添加script标签
                change();
            }

        }
        function search() {
            console.log(searchCondition);
        }
    </script>
</head>
<body>

<div id="container">
    <div class="search bar1">
        <div class="form" id="fm">
            <input type="text" id="i1" placeholder="请输入您要检索的关系名称...">

            <button type="button" onclick="mysend()"></button>

        <ul id="ul">

        </ul>
        </div>
        <div id="visual"></div>
    </div>
</div>
</body>
</html>