<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>薪酬管理知识图谱</title>
<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="expires" content="0">
<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
<meta http-equiv="description" content="This is my page">
<link rel="stylesheet" type="text/css" href="css/style.css">

</head>

<body>
	<script>$(document).ready(function(c) {
	$('.close').on('click', function(c){
		$('.login-form').fadeOut('slow', function(c){
	  		$('.login-form').remove();
		});
	});	  
});
</script>
<style>
.logo{
	position: relative;
}
.logo img{
	position: absolute;
	left:0;
}

</style>
	<!--SIGN UP-->
	<div class="logo" style="width:50px;height:50px;margin:10px">
	<img src="images/logo.png">	
	</div>
	<h1>薪酬管理知识图谱</h1>
	<div class="login-form" >
		<div class="close"></div>
		<div class="head-info">
			<label class="lbl-1"> </label> <label class="lbl-2"> </label> <label
				class="lbl-3"> </label>
		</div>
		<div class="clear"></div>		
		<form name="userinf" action="base.jsp" method="post">
		<div class="avtar" style="color:white">
			<div>
			<select style="border:1px solid red;font-family:'微软雅黑';background-color:


#E6E6FA;width:200px; margin:10px 0 0 0;">
				<option>请选择部门</option>
				<option>财务部</option>
				<option>生产部</option>
				<option>人力资源部</option>
			</select>
			</div>

			</div>
			<input type="text" class="text" value="用户名" name="username"
				onfocus="this.value = '';"
				onblur="if (this.value == '') {this.value = '用户名';}">
			<div class="key">
				<input type="password" value="Password" name="pwd"
					onfocus="this.value = '';"
					onblur="if (this.value == '') {this.value = 'Password';}">
			</div>
			<div>
				<%if(request.getAttribute("info")!=null){ %><%=request.getAttribute("info") %>
				<%} %>
				<!-- <div class="signin"> -->
				
				<!-- </div> -->
				<input type="submit" value="登录">
		</form>
		
	</div>
	<div class="copy-rights">
		<a href="zhuce.jsp">马上注册！</a>
	</div>

</body>






























<%--  <form name="userinf" action="login.do" method="post">
  		<table>
				<tr>
					<td>用户名:</td>
					<td><input type="text" name="username" size="34" ></td>
				</tr>
				<tr>
					<td>密码:</td>
					<td><input type="password" name="pwd" size="35"></td>
				</tr>
				<div><%if(request.getAttribute("info")!=null){ %><%=request.getAttribute("info") %><%} %>
				
				
				</div>
				<input type="submit" value="登录" style="width: 90px;">
								
  	</form>
  	<a href="zhuce.jsp">马上注册！</a>
  </body> --%>
</html>
