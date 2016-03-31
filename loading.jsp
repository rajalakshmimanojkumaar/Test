<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Loading</title>
<link href="loading.css" rel="stylesheet">	
<script type="text/javascript">
$(document).ready(function () {
$('#Click').click(function(){
document.getElementById("loading").style.display="";
alert("check");
$.ajax({
 success:function(result){
	 document.getElementById("loading").style.display="none";
 }
})
})
});
</script>

</head>
<body>
<center>
 <div class="loading" id="loading" style="display: "> 
  <div>
    <div class="c1"></div>
    <div class="c2"></div>
    <div class="c3"></div>
    <div class="c4"></div>
  </div>
  <span>loading</span>
</div>
</center>
</body>
<ul></ul>
</html>
