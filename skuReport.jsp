<%@ include file="../validateLogin.jsp"%>
<%@ include file="../pages/headerSku.jsp"%>
<%
if(request.isRequestedSessionIdValid())
{
	%><jsp:include
	page='<%=session.getAttribute("menu_url")==null?"/menu/menu_default.html":session.getAttribute("menu_url").toString()%>' />
<%
}
%>
<%@ page import="java.util.Date"%>
<%@ page import="java.text.*"%>
<%@ page import="db.*"%>
<%@ page import="java.io.*,java.sql.*"%>
<%@page import="Delivery.ProductDelivery"%>
<%@page import="Delivery.MyMultipleFileZip"%>
<!DOCTYPE html>
<html lang="en">
<head>
<script language="JavaScript" src="/WriteWell/script/js/basicObject.js"></script>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->
<title>3M</title>

<!-- Bootstrap -->

<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>
<!-- load datatables js library -->
<script type="text/javascript" src="/WriteWell/script/js/jquery.dataTables.js"></script>
<script type="text/javascript" src="/WriteWell/script/js/tooltips.js"></script>
<!-- <script src="https://cdn.jsdelivr.net/tablesorter/2.17.4/js/jquery.tablesorter.min.js"></script> -->
<script type="text/javascript" src="/WriteWell/script/js/jquery.tablesorter.min_2.17.4.js"></script>
<link href="/WriteWell/script/css/bootstrap.css" rel="stylesheet">
<link href="/WriteWell/script/css/style_sku.css" rel="stylesheet">
<link href="/WriteWell/script/css/tooltips.css" rel="stylesheet">
<link href="/WriteWell/script/css/sumoselect.css" rel="stylesheet">
<link href="/WriteWell/script/css/skuProgressBar.css" rel="stylesheet">
<link rel="stylesheet" type="text/css" media="all"
	href="/WriteWell/script/css/daterangepicker.css" />

<link rel="stylesheet" type="text/css"
	href="/WriteWell/script/css/jquery.dataTables.css">
<link rel="stylesheet" type="text/css"
	href="https://cdn.datatables.net/responsive/2.0.1/css/responsive.dataTables.min.css">
	<link rel="stylesheet" type="text/css"
	href="/WriteWell/script/css/buttons.dataTables.min.css">
<!-- <script src="https://code.jquery.com/jquery-1.12.0.min.js"></script>-->
<script
	src="https://cdn.datatables.net/1.10.10/js/jquery.dataTables.min.js"></script>
<script 
	src="https://cdn.datatables.net/responsive/2.0.1/js/dataTables.responsive.min.js" ></script>

<script src="/WriteWell/script/js/dataTables.buttons.min.js"></script>
<script src="/WriteWell/script/js/buttons.flash.min.js"></script>
<script src="/WriteWell/script/js/jszip.min.js"></script>
<script src="/WriteWell/script/js/pdfmake.min.js"></script>
<script src="https://cdn.rawgit.com/bpampuch/pdfmake/0.1.18/build/vfs_fonts.js"></script>
<script src="/WriteWell/script/js/buttons.html5.min.js"></script>
<script src="/WriteWell/script/js/buttons.print.min.js"></script>

<link href="/WriteWell/script/css/report.css" rel="stylesheet">	
<style type="text/css">
.dataTables_filter, .dataTables_info { display: none; }

</style>
<script type="text/javascript">
     function format ( d,i ) {
        // `d` is the original data object for the ro  w  id="inside'+i+'"
        var row='<table id="inside'+i+'" class="tablesorter" width=100% cellpadding="1" cellspacing="0" border="0" style="padding-left:50px;">';
        row+='<thead><tr style="font-weight:bold;font-color:black" align="center">'+
		'<th style="width:10%;" bgcolor="#ffc266">Project</th>'+
		'<th style="width:9%;" bgcolor="#ffc266">Business Group</th>'+
		'<th style="width:9%;" bgcolor="#ffc266">Category</th>'+
		'<th style="width:8%;" bgcolor="#ffc266"  data-sorter="shortDate" data-date-format="ddmmyyyy">Batch Date</th>'+
    	'<th style="width:10%;" bgcolor="#ffc266">SKU ID</th>'+
    	'<th style="width:12%;" bgcolor="#ffc266">SKU Name</th>'+
    	'<th style="width:10%;" bgcolor="#ffc266">Status</th>'+
    	'<th style="width:4%;" bgcolor="#ffc266">Approver</th>'+
    	'<th style="width:13%;" bgcolor="#ffc266" data-sorter="shortDate" data-date-format="ddmmyyyy">Assigned on</th>'+
    	'<th style="width:10%;" bgcolor="#ffc266" data-sorter="shortDate" data-date-format="ddmmyyyy">Last update date</th>'+
		'</tr></thead><tbody>';
        var projectName=d.projectName;
        var businessGroup=d.businessGroup;
        var Category=d.category;
        var batchDate=d.batchDate;
        var projectId=d.projectId;
        for(i=0;i<d.skus.length;i++){
    		var inner=d.skus[i];
    		var url = "/WriteWell/pages/EditorScreen.html?";
    		var roleId='<%=session.getAttribute("role_id")==null?"":session.getAttribute("role_id").toString()%>';
    		var userType='<%=session.getAttribute("user_type")==null?"":session.getAttribute("user_type").toString()%>';
    		var roleType='<%=session.getAttribute("role_type")==null?"":session.getAttribute("role_type").toString()%>';
    		var uName='<%=(session.getAttribute("uName")==null)?"":session.getAttribute("uName").toString()%>';
    		
    		var status_role;
    		if(roleType.toString()=="Content Hub"){
				status_role="CONTHUB";
			}else if (roleType.toString()=="Product Marketing"){
				status_role="PRDMARK";
			}else if (roleType.toString()=="Corporate Marketing"){
				status_role="CORPMARK";
			}else if (roleType.toString()=="Regulatory"){
				status_role="REGULATORY";
			}else if (roleType.toString()=="Legal"){
				status_role="LEGAL";
			}
    		var mainData=d.batchCount+"@"+d.prodMarketingCt+"@"+d.skusCompleted;
    		var temp='<tr style="border-bottom: solid 1px white;">'+
    			'<td style="width:10%;"  bgcolor="#ffd699">'+projectName+'</td>'+
    			'<td style="width:9%;"  bgcolor="#ffd699">'+businessGroup+'</td>'+
    			'<td style="width:9%;"  bgcolor="#ffd699">'+Category+'</td>'+
    			'<td style="width:10%;"  bgcolor="#ffd699" align="center">'+batchDate+'<input type="hidden" id="main" value="'+mainData+'"/></td>'+
    			//'<td style="border-right: solid 1px #e8e8e7;width:10%;"><a href="#" class="pull-left orgText">'+inner.skuId+'</a></td>'+
            	'<td style="width:10%;"  bgcolor="#ffd699"><a href="#" onclick="JavaScript:Call_Post_Window(\''+url+'Prd_no='+i+'\',\'AP\',\'1350\',\'650\',\'0\',\'0\',\'\')" class="pull-left orgText">'+inner.skuId+'</a>'+
            	'<input type="hidden" name="module" id="prd_'+i+'" value="'+inner.projectcatMapId+'#_#'+inner.catPrdId+'#_#0#_#'+inner.empCode+'#_#'+roleId+'#_#'+roleType+'#_#'+userType+'#_#'+status_role+'#_#'+projectId+'#_#REPORT#_#'+inner.skuId+'#_#REPORT#_#'+uName+'#_#NA"/></td>';
            	if(inner.rework=="Yes"){
            		temp+='<td style="width:10%;"  bgcolor="#ffd699"><div class="skuname_active">'+inner.skuName+'</div></td>';
            	}else{
            		temp+='<td style="width:10%;"  bgcolor="#ffd699">'+inner.skuName+'</td>';
            	}
            	temp+='<td style="width:10%;"  bgcolor="#ffd699">'+inner.status+'</td>'+
            	'<td style="width:4%;"  bgcolor="#ffd699">'+inner.approver+'</td>'+
            	'<td style="width:12%;"  bgcolor="#ffd699" align="center">'+inner.assignedOn+'</td>'+
            	'<td style="width:12%;"  bgcolor="#ffd699" align="center">'+inner.lastUpdated+'</td>'+
        		'</tr>';
        		row=row+temp;
        }
        row=row+"</tbody></table>";
        //console.log(row);
        return row;
    }
    
 	 $(document).ready(function () {
 		 
 		   function exportTableToCSV($table, filename,reportType) {
 		        var $flag=0;
 		       // var $rows = $table.find('tr:has(td)');
 		        var $rows = $table.find('tr[role!="row"]:has(td)');

 		           tmpColDelim = String.fromCharCode(11), 
 		            tmpRowDelim = String.fromCharCode(0), 
 		            colDelim = '","',
 		            rowDelim = '"\r\n"',
 		     
 		            csv = '"' + $rows.map(function (i, row) {
 		                var $row = $(row);
 		                    $cols = $row.find('td');
 		                	$innerTable=$cols.find('table');
 		                	$innerRows=$innerTable.find('tr:has(td)');
 		                	if($innerRows.text()!=""){
 		                		var $flag=1;
 		                	csvi='"' + $innerRows.map(function (i, row) {
 		                        var $row = $(row),
 		                            $cols1 = $row.find('td');
 		                        	$innerTable=$cols1.find('table');
 		                        	$innerRows=$innerTable.find('tr:has(td)');
 		                       	 return $cols1.map(function (j, col) {
 		                            var $col = $(col);
 		                                text = $col.text();
 			                            return text;
 		                        }).get().join(tmpColDelim);

 		                    }).get().join(tmpRowDelim)
 		                        .split(tmpRowDelim).join(rowDelim)
 		                        .split(tmpColDelim).join(colDelim) + '"';
 		                        

 		            }
 		                
 		                	if($flag!=1){
 		                return $cols.map(function (j, col) {
 		                    var $col = $(col);
 		                    
 		                    if(j==0){
 		                    	
 		                    }
 		                    var mainData=$(col).find('input[id="main"]').val();
 		                    //alert("mainData : "+mainData);
 		                    //var mainDataT=mainData;
 		                    //alert("mainData : "+mainData+" - "+j);
 		                    //alert("main:"+mainData);
 		                        text = $col.text();
 		                        //alert(text+"-"+mainData);
 		                        if(mainData===undefined){
 		                        	text=text;
 		                        }else{	
 		                        main=mainData.split('@')[0]+'","'+mainData.split('@')[1]+'","'+mainData.split('@')[2];
 		                       // alert(main+" - "+j);
 		                        if(j==3){
 		                        	text=text+'","'+main;
 		                        	}
 		                        }
 		                    return text.replace('"', '""').replace('""','"');
 		                }).get().join(tmpColDelim);
 		                	}
 		            }).get().join(tmpRowDelim)
 		                .split(tmpRowDelim).join(rowDelim)
 		                .split(tmpColDelim).join(colDelim) + '"';
 		           		          // csv=csv.replace("\"\",","");
 		            // Data URI
 		            csv=csv.replace("^\"\"","\"");
 		            var header='Project","Business Group","Category","Batch Date","Batch Count","Product Marketing","SKUs Completed (in %)","SKU ID","SKU Name","Status","Approver","Assigned on","Last update date","'+rowDelim;
 		           var header1='Project","Business Group","Category","Batch Date","SKU ID","SKU Name","Status","Approver","Assigned on","Last update date'+rowDelim;
					if(reportType==1) {
 		        	  csv=header+csv;   
 		           }else{
 		        	  csv=header1+csv;
 		           }
 		          var find = '"","';
		           var re = new RegExp(find, 'g');
		           csv = csv.replace(re, '');
		           csv=csv.replace("\"\",","");
		           csv=csv.replace("Project\"","Project");
 		            csvData = 'data:application/csv;charset=utf-8,' + encodeURIComponent(csv);

 		        $(this)
 		            .attr({
 		            'download': filename,
 		                'href': csvData,
 		               'target': '_blank'
 		        });
 		    }

 		    $(".export1").on('click', function (event) {
 		        // CSV
 		        exportTableToCSV.apply(this, [$('#example1'), 'Sku_wise_report.csv','2']);
 		    });
	 
 		$("#example_export1").css("display", "none");
        $("#example_export").css("display", "none");
 		var table = $('#example').DataTable();
 		 $("#btnsubmit").prop("disabled",true);
		 document.getElementById("example1").style.display="none";
			$("#example_length").css("display", "none");
 		 function validationCheck(){
 			 var inp = $("#skuSearchId");
 			 if(inp.val()==null || inp.val()==""){
 				 return false;
 			 }else{
 				 return true;
 			 }
 			 
 		}

	 $('#btnsubmit,#skuSearch,#btnsubmitafter').click(function(){
		 var clickId=$(this).attr("id");
		 var skus;
		 var isCollapse = 1;
		 if(clickId=='btnsubmit'||clickId=='btnsubmitafter'){
	     $("#btnsubmit").prop("disabled",true);
	 	 $("#example1_wrapper").find('.dt-buttons').css("display", "none");
		 $("#example_export").css("display", "none");
		 $("#example_export1").css("display", "none");
		 $("#example1_paginate").css("display", "none");
		 $("#example_paginate").css("display", "");
		 $("#example1_length").css("display", "none");
		 $("#example_length").css("display", "");
		 document.getElementById("loading").style.display="";	 
		 document.getElementById("skuSearchId").value="";	
		 table.destroy();
		 document.getElementById("example").style.display="none";
		 document.getElementById("example1").style.display="none";
		 }	
		 //document.getElementById("barStatus").style.display="none";
		 
		 //Finding Selected Projects "
		 var MySelect = $('select.Project').SumoSelect();
		 var selectedProjects=null,selectAll=null;
		 selectedProjects=$('select.Project').val();
	 	 for(var i=0;i<MySelect.length;i++){
	 		selectAll=selectAll+MySelect.options[i].value+",";
	 	  }

    	 //Finding Selected Categories
		 var MyC = $('select.Business').SumoSelect();
		 var selectedCategory=null,selectAllC=null;
		 selectedCategory=$('select.Business').val();
		 for(var i=0;i<MyC.length;i++){
			 selectAllC=selectAllC+MyC.options[i].value+",";
		  }
		 
		 //Finding Selected Categories
		 var MyS = $('select.Status').SumoSelect();
		 var selectedStatus=null,selectAllS=null;
		 selectedStatus=$('select.Status').val();
		 for(var i=0;i<MyS.length;i++){
			 selectAllS=selectAllS+MyS.options[i].value+",";
		  }
		 
		 var batchDate=document.getElementById('batchDate').value;
		 
		 if(selectedProjects==null){
			 selectedProjects=selectAll;
		 }
		 if(selectedCategory==null){
			 selectedCategory=selectAllC;
		 }
		 if(selectedStatus==null){
			 selectedStatus=selectAllS;
		 }
			var flag=0;
		 if(batchDate==null){
			 batchDate="";
			 flag=1;
		 }else{
			 batchDate=batchDate.replace("-","AA");
			 flag=1;
		 }
		 if(skus===undefined){
			 skus=null;
		 }
		 var selected=selectedProjects+"-"+selectedCategory+"-"+selectedStatus+"-"+batchDate;
		 var selectedA=selectAll+"-"+selectedCategory+"-"+selectedStatus+"-"+batchDate;

		 		if(clickId=='skuSearch'){
		 			$("#skuSearch").prop("disabled",true);
		 			 $("#example_export").css("display", "none");
		 			$("#example1_paginate").css("display", "");
		 			$("#example_paginate").css("display", "none");
		 			$("#example1_length").css("display", "");
		 			$("#example_length").css("display", "none");


				 if(validationCheck()==false){
					 alert("Please enter the sku Id");
					 flag=2;
					 document.getElementById("loading").style.display="none";
					 $("#skuSearch").prop("disabled",false);
				 }else{ 
					document.getElementById("loading").style.display="";
			    	var table1 = $('#example1').DataTable();
				 	document.getElementById("example").style.display="none";
				 	document.getElementById("example1").style.display="none";
				 	table1.destroy();
				 	skus=document.getElementById("skuSearchId").value;
				 	selectedA=selectedA+"-"+skus;
				 	selected=selectedA;
				 	flag=1;
				 }
			 }

		 //var selected=selectedProjects+"-"+selectedCategory+"-"+selectedStatus;
			var data1=[];
			//alert(selected);
			//var flickerAPI = "http://10.20.150.14:7777/api.ugam.com.v1/skureport/getSkuReport?projectId="+selectedProjects;
			var reportAPI = "http://10.20.150.14:7777/api.ugam.com.v1/skureport/getSkuReport";
			$.post(reportAPI, selected, function(data) {
		   	//  $.getJSON( reportAPI,function(data){
		   $.each(data, function(index, d){  
                 data1=JSON.parse(d);
            if(clickId!='skuSearch'){     
            document.getElementById("example").style.display="";
    	    	table = $('#example').DataTable({
    	    	 dom: 'Bfrtip',
    	    	 buttons: [
    	    	            // 'copy', 'csv', 'excel', 'pdf', 'print'
    	    	           /* {
    	    	                extend: 'excelHtml5',
    	    	                title: 'Sku_summary_report'
    	    	            }*/
    	    	         ],
    
              data: data1,
                  "columns": [
              {
                  "class": 'details-control',
                      "orderable": false,
                      "data": null,
                      "defaultContent": ''
              }, {
                  "data": "projectName"
              }, {
                  "data": "businessGroup"
              },{
                  "data": "category"
              },{
                  "data": "batchDate",
                  'sClass':'dateC'
              }, {
                  "data": "batchCount",
                  'sClass':'rightC'
                  
              },{
                  "data": "prodMarketingCt",
                  'sClass':'rightC'
              },{
                  "data": "skusCompleted",
                  'sClass':'rightC',
              }],
                  "order": [
                  [1, 'asc']
              ]
          });
    	           if(data1.length==0){
                  	 $("#example_export").css("display", "none");
                   }else{
                  	 $("#example_export").css("display", "");
                   }
    	    	   document.getElementById("loading").style.display="none";
    	    	function collapse_exand_rows(){
    	            var table_length = $('#example tbody tr').length;
    	            for (var i = 0; i < table_length; i++) {
    	                var tr = $('.details-control').parents('tr').eq(i);
    	                var row = table.row( tr );
    	                if(!tr.hasClass('shown') || visited_cehck != 1){
    	                    if ( isCollapse === 1 ) {
    	                        // This row is already open - close it
    	                        row.child.hide();
    	                        tr.removeClass('shown');
    	                    }
    	                    else {
    	                        // Open this row
    	                        row.child( format(row.data()) ).show();
    	                        tr.addClass('shown');
    	                        $('[id^="inside"]').tablesorter();
    	                    }   
    	                }
    	            }
    	        }

    	    
    	    //This event handles collapse expand button click to show and hide all the visible rows
    	        $('#collapse_expand').on('click', function(event) {
    	            visited_cehck = 0;
    	            if(isCollapse === 1){
    	            	 $('#collapse_expand').attr("src", '/WriteWell/script/images/minus.png');
    	                isCollapse = 0; 
    	            }
    	            else{
    	                $('#collapse_expand').attr("src", '/WriteWell/script/images/plus.png');
    	                isCollapse = 1;
    	            }
    	            collapse_exand_rows();
    	        });

    	   
    	    	 $("#btnsubmit").prop("disabled",false);
	            
    			 visited_cehck = 0;
	            if(isCollapse === 1){
	            	 $('#collapse_expand').attr("src", '/WriteWell/script/images/minus.png');
	                isCollapse = 0; 
	            }
	            else{
	                $('#collapse_expand').attr("src", '/WriteWell/script/images/plus.png');
	                isCollapse = 1;
	            }
	            collapse_exand_rows();
	            $(".export").on('click', function (event) {
	            	 if(isCollapse === 1){
		            	 $('#collapse_expand').attr("src", '/WriteWell/script/images/minus.png');
		                isCollapse = 0; 
		            }
		            else{
		                $('#collapse_expand').attr("src", '/WriteWell/script/images/plus.png');
		                isCollapse = 1;
		            }
		            collapse_exand_rows();
	 		        exportTableToCSV.apply(this, [$('#example'), 'Sku_summary_report.csv','1']);
	 		     
	 		    });
             }else if(clickId=='skuSearch' && flag==1){     
            	 var url = "/WriteWell/pages/EditorScreen.html?";
            	 var i=0;
         		var roleId='<%=session.getAttribute("role_id")==null?"":session.getAttribute("role_id").toString()%>';
         		var userType='<%=session.getAttribute("user_type")==null?"":session.getAttribute("user_type").toString()%>';
         		var roleType='<%=session.getAttribute("role_type")==null?"":session.getAttribute("role_type").toString()%>';
         		var uName='<%=(session.getAttribute("uName")==null)?"":session.getAttribute("uName").toString()%>';
         		
         		var status_role;
         		if(roleType.toString()=="Content Hub"){
     				status_role="CONTHUB";
     			}else if (roleType.toString()=="Product Marketing"){
     				status_role="PRDMARK";
     			}else if (roleType.toString()=="Corporate Marketing"){
     				status_role="CORPMARK";
     			}else if (roleType.toString()=="Regulatory"){
     				status_role="REGULATORY";
     			}else if (roleType.toString()=="Legal"){
     				status_role="LEGAL";
     			}
				 document.getElementById("example1").style.display="";
             
            	  table1 = $('#example1').DataTable({
            		  dom: 'Bfrtip',
            		    buttons: [
         	             //'excel'
         	              {
    	    	                extend: 'excelHtml5',
    	    	                title: 'Sku_wise_report',
    	    	                titleAttr: 'Download'
    	    	            }
         	         ],
            	  
                   data: data1,
                       "columns": [
                 	{
                       "data": "projectName"
                   }, {
                       "data": "businessGroup"
                   },{
                       "data": "category"
                   }, {
                       "data": "batchDate",
                       'sClass':'dateC'
                   },{
                       "data": "edit",
                       "render": function (data) {
						if(data.split("-").length==6){
						 var urlData='<a href="#" onclick="JavaScript:Call_Post_Window(\''+url+'Prd_no='+data.split("-")[5]+'\',\'AP\',\'1350\',\'650\',\'0\',\'0\',\'\')" class="pull-left orgText">'+data.split("-")[0]+'</a>'+
                       	'<input type="hidden" name="module" id="prd_'+data.split("-")[5]+'" value="'+data.split("-")[1]+'#_#'+data.split("-")[2]+'#_#0#_#'+data.split("-")[3]+'#_#'+roleId+'#_#'+roleType+'#_#'+userType+'#_#'+status_role+'#_#'+data.split("-")[4]+'#_#REPORT#_#'+data.split("-")[0]+'#_#REPORT#_#'+uName+'#_#NA"/>';
                       	return urlData;
						}
                    	   /*   return '<a href="#" onclick="JavaScript:Call_Post_Window(\''+url+'Prd_no='+i+'\',\'AP\',\'1350\',\'650\',\'0\',\'0\',\'\')" class="pull-left orgText">'+data.skuId+'</a>'+
                          	'<input type="hidden" name="module" id="prd_'+i+'" value="'+data.projectcatMapId+'#'+data.catPrdId+'#0#'+data.empCode+'#'+roleId+'#'+roleType+'#'+userType+'#'+status_role+'#'+projectId+'#REPORT#'+data.skuId+'#REPORT#'+uName+'#NA"/>';*/
                    	    }
                   },{
                       "data": "skuName"
                   },{
                       "data": "status"
                   },{
                       "data": "approver"
                   },{
                       "data": "assignedOn",
                       'sClass':'dateC'
                   },{
                       "data": "lastUpdated",
                       'sClass':'dateC'
                   }],
                       "order": [
                       [1, 'asc']
                   ]
               }); 
            	    if(data1.length==0){
                   	 $("#example1_wrapper").find('.dt-buttons').css("display", "none");
                    }else{
                   	 $("#example1_wrapper").find('.dt-buttons').css("display", "");
                }
       		   document.getElementById("loading").style.display="none";
            	  if(table1.data().count()>10){
            		  $("#example1_length").css("display", "");
            	  }else{
            		  $("#example1_length").css("display", "none");
            	  }
            	 
            		$("#skuSearch").prop("disabled",false);
    	 			//$("#example_wrapper").find('.dt-buttons').css("display", "none");
		 			 $("#example_export1").css("display", "");
            	
             }
		   });//each
			 //document.getElementById("example").style.display="";
			 // Add event listener for opening and closing details

	   })//post
	   .error(function() { alert("GetSkuReport Service is Down. Please Contact Administrator!"); $("#btnsubmit").prop("disabled",false);$("#skuSearch").prop("disabled",false);})
	   //If the loading bar needs to be updated once submit click
	   		var batch=document.getElementById('batchDate').value;
			batch=batch.replace("-","AA");

			if(clickId=='btnsubmit' && flag==1){
	        getBarStatus(selectedProjects+"-"+selectedCategory+"-"+batch)
			}
			function getBarStatus(projectId){
			
				var pro = projectId == null ? "0" : projectId;
				var accept = 0;
				var rtr = 0;
				var wip = 0;
				var reject = 0;
			    $.getJSON('http://10.20.150.14:7777/api.ugam.com.v1/skureport/getSkuReportLoadingBar?projectCatgId='+ pro,
			    			function(data) {
			    
			    	 			document.getElementById("barStatus").style.display="";
								$.each(data,function(i,v){
									var status=JSON.parse(v);
									$.each(status,function(k,v){
										if(v.statusName=="Accepted"){
											accept=parseInt(v.countT);
										}else if(v.statusName=="WIP"){
											wip=parseInt(v.countT);
										}else if(v.statusName=="Ready to Review"){
											rtr=parseInt(v.countT);
										}else if(v.statusName=="Rejected"){
											reject=parseInt(v.countT);
										}
									});//each
										var total = accept + rtr + wip + reject;
										var hbarWidth = 500;
										$('.hBar').addClass('done');
										
										$( "#barT" ).empty().prepend( "<h2>"+total+"</h2>" );
										
										$('.acceptCnt').animate({
											'width' : (accept / total) * hbarWidth + 'px'
										});
										$('.acceptCnt h1').text(accept).fadeIn(2000);
										$('.rtrCnt').animate({
											'width' : (rtr / total) * hbarWidth + 'px'
										});
										$('.rtrCnt h1').text(rtr).fadeIn(2000);
										;
										$('.wipCnt').animate({
											'width' : (wip / total) * hbarWidth + 'px'
										});
										$('.wipCnt h1').text(wip).fadeIn(2000);
										;
										$('.rejectCnt').animate({
											'width' : (reject / total) * hbarWidth + 'px'
										});
										$('.rejectCnt h1').text(reject).fadeIn(2000);
										;
															
								});//each outer
							})//getJson
							.error(function(){alert("GetSkuReportLoadingBar Service is Down. Please Contact Administrator!");})
			}//getBarStatus
		
	 });//submit
	
	 $('#example tbody').on('click', 'td.details-control', function () {
         var tr = $(this).parents('tr');
         var row = table.row(tr);
         var rowNo=table.row(tr).index();
		 if (row.child.isShown()) {
             // This row is already open - close it
             row.child.hide();
             tr.removeClass('shown');
         } else {
             // Open this row
            // var inner = $('#innerC'+i+'').DataTable( );
            row.child(format(row.data(),rowNo)).show();
             tr.addClass('shown');
        
         }
         $("#inside"+rowNo+"").tablesorter();
     });
	 });
	 $(document).ready(function() {
	      $('table.display').each(function() {
	        var $table = $(this);
	        $table.find('.odd,.even').click(function() {
	            $(this).nextUntil('.odd,.even').toggle(); // must use jQuery 1.4 for nextUntil() method
	        });

	        var $childRows = $table.find('tbody tr').not('.odd,.even').show();
	        $table.find('button.hide').click(function() {
	            $childRows.hide();
	        });
	        $table.find('button.show').click(function() {
	            $childRows.show();
	        });
	    });
	});
    $(document).ready(function(){
    	document.getElementById("barStatus").style.display="none";
    	 <%
    	    String emp_id1 = session.getAttribute("emp_id")==null?"":session.getAttribute("emp_id").toString();
    	    %>
    	    var empId=<%=emp_id1%>;
				$.getJSON('http://10.20.150.14:7777/api.ugam.com.v1/skureport/getSkuReportProject?empId='+ empId,
										function(data) {
											var $select = $('.Project');
											$.each(data,function(i, val) {
												project = JSON.parse(val);
												var projectId = null;
												$.each(project,function(k,v) {
													   $('select.Project')[0].sumo.add(v.projectId,v.projectName);
														projectId = projectId+ v.projectId+ ",";
												})
												projectId = projectId.replace("null","");
												getCategory(projectId);
											});//each
											$('select.Project')[0].sumo.selectAll();
											var MySelect = $('select.Project').SumoSelect();
											 var selectedProjects=null,selectAll="";
											 selectedProjects=$('select.Project').val();
											 var check=document.getElementById("project_name").value;
											 if(!check==""){
										 	 for(var i=0;i<MySelect.length;i++){
										 		selectAll=MySelect.options[i].value;
										 		if(~check.indexOf(selectAll)){
										 			$('select.Project')[0].sumo.selectItem(i);
										 		}
										 		else{
										 			$('select.Project')[0].sumo.unSelectItem(i);
										 		}
									
										 	  }
											 }
										 	 
											var date = new Date(); 
											console.log("date"+date);
										})//getjson Project End
										.error(function(){alert("GetSkuReportProject Service is Down. Please Contact Administrator!");});

				function getCategory(projectId) {
					var pro = projectId == null ? "0" : projectId;
							$.getJSON('http://10.20.150.14:7777/api.ugam.com.v1/skureport/getSkuReportCategory?projectId='+ pro,
										function(data) {
											var $select = $('.Business');
												$.each(data,function(i, val) {
													category = JSON.parse(val);
													var categoryId = null;
													$.each(category,function(k,v) {
														$('select.Business')[0].sumo.add(v.projectCatMapId,v.catName);
														categoryId = categoryId+ v.projectCatMapId+ ",";
													})//inner each
													var batch=document.getElementById('batchDate').value;
													batch=batch.replace("-","AA");
													getBarStatus(pro+"-"+categoryId+"-"+batch);
												});//first each
												$('select.Business')[0].sumo.selectAll();
												var MySelect = $('select.Business').SumoSelect();
												 var selectedProjects=null,selectAll="";
												 selectedProjects=$('select.Business').val();
												 var check=document.getElementById("cat_name").value;
												 if(!check==""){
											 	 for(var i=0;i<MySelect.length;i++){
											 		selectAll=MySelect.options[i].value;
											 		if(~check.indexOf(selectAll)){
											 			$('select.Business')[0].sumo.selectItem(i);
											 		}
											 		else{
											 			$('select.Business')[0].sumo.unSelectItem(i);
											 		}
										
											 	  }
												 }
			 	 
											 	})
											.error(function(){alert("GetSkuReportCategory Service is Down. Please Contact Administrator!");});
				}//getCategory 

							$.getJSON('http://10.20.150.14:7777/api.ugam.com.v1/skureport/getSkuReportStatus',
									    function(data) {
										 var $select = $('.Status');
											$.each(data,function(i, val) {
											var status = JSON.parse(val);
												$.each(status,function(k,v) {
													$('select.Status')[0].sumo.add(v.statusId,v.statusName);
												})//inner each
											});//first each
											$('select.Status')[0].sumo.selectAll();
											var MySelect = $('select.Status').SumoSelect();
											 var selectedProjects=null,selectAll="";
											 selectedProjects=$('select.Status').val();
											 var check=document.getElementById("status_name").value;
											 if(!check==""){
										 	 for(var i=0;i<MySelect.length;i++){
										 		selectAll=MySelect.options[i].value;
										 		if(~check.indexOf(selectAll)){
										 			$('select.Status')[0].sumo.selectItem(i);
										 		}
										 		else{
										 			$('select.Status')[0].sumo.unSelectItem(i);
										 		}
									
										 	  }
										 	
											 }
											 var tue=document.getElementById("batch_date_hidden").value;
											 	document.getElementById('batchDate').value=tue;
										})
											.error(function(){alert("GetSkuReportStatus Service is Down. Please Contact Administrator!");})
				
				//Loading Bar
	
			function getBarStatus(projectId){
			$("#btnsubmit").prop("disabled",false);
				var pro = projectId == null ? "0" : projectId;
				var accept = 0;
				var rtr = 0;
				var wip = 0;
				var reject = 0;
			    $.getJSON('http://10.20.150.14:7777/api.ugam.com.v1/skureport/getSkuReportLoadingBar?projectCatgId='+ pro,
			    			function(data) {
			    
			    	 			document.getElementById("barStatus").style.display="";
								$.each(data,function(i,v){
									var status=JSON.parse(v);
									$.each(status,function(k,v){
										if(v.statusName=="Accepted"){
											accept=parseInt(v.countT);
										}else if(v.statusName=="WIP"){
											wip=parseInt(v.countT);
										}else if(v.statusName=="Ready to Review"){
											rtr=parseInt(v.countT);
										}else if(v.statusName=="Rejected"){
											reject=parseInt(v.countT);
										}
									});//each
										var total = accept + rtr + wip + reject;
										var hbarWidth = 500;
										$('.hBar').addClass('done');
										
										$( "#barT" ).append( "<h2>"+total+"</h2>" );
										
										$('.acceptCnt').animate({
											'width' : (accept / total) * hbarWidth + 'px'
										});
										$('.acceptCnt h1').text(accept).fadeIn(2000);
										$('.rtrCnt').animate({
											'width' : (rtr / total) * hbarWidth + 'px'
										});
										$('.rtrCnt h1').text(rtr).fadeIn(2000);
										;
										$('.wipCnt').animate({
											'width' : (wip / total) * hbarWidth + 'px'
										});
										$('.wipCnt h1').text(wip).fadeIn(2000);
										;
										$('.rejectCnt').animate({
											'width' : (reject / total) * hbarWidth + 'px'
										});
										$('.rejectCnt h1').text(reject).fadeIn(2000);
										;
															
								});//each outer
							});//getJson

			}//getBarStatus

			
		})//document
		
		
		
</script>


<script type="text/javascript">
function formsubmit(){
	
	var b=validate();
	
	if(b){
		document.getElementById("export").value = 'export';
		document.forms["myform"].submit();
	return true;
	}
	else{
		return false;
	}
}
function validate()
{
	var idx = document.getElementById("Project").selectedIndex;
	var idx1 = document.getElementById("Business").selectedIndex;
	var idx2 = document.getElementById("status").selectedIndex;
	var idx3 = document.getElementById("batchDate").value;
	if(idx==-1)
	{
		alert('Please Select Project');
		return false;
	}
	else if(idx1==-1)
	{
		alert('Please Select Business Group');
		return false;
	} else if (idx2==-1) {
		alert('Please Select Status');
		return false;
	}else if(!idx3){
		alert('Please Select Batch date');
		return false;
	}	
	else
	{
		 $("#example_paginate").css("display", "none");
		 $("#example1_paginate").css("display", "");
		 $("#example_length").css("display", "none");
		 $("#example1_length").css("display", "");
		 document.getElementById("loading").style.display="";	 
		 document.getElementById("skuSearchId").value="";	
		 document.getElementById("example").style.display="none";
		 document.getElementById("example1").style.display="none";
	 	
				return true;
	}
	
}
</script>


</head>
<body>
<div class="loading" id="loading" style="display:none">
  <div>
    <div class="c1"></div>
    <div class="c2"></div>
    <div class="c3"></div>
    <div class="c4"></div>
  </div>
  <span>loading</span>
</div>
<%
	Connection C = null;
	try
	{
	String exportmod="export";
	
	C = (Connection)ConnectionManager.getConnection("");
	java.sql.Statement st = C.createStatement();
	String query;
	Calendar calendar = Calendar.getInstance();
	SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
	String fromdate1="";
	String todate1="";
	String person_id = session.getAttribute("emp_code").toString();
	ResultSet rs=null;
	%>
<form name="myform" action="skuReport.jsp" >
<input type="hidden" id="export" name="export" value=''>
 	<div class="container-fluid">
		<div class="brdBtm clearfix">
			<div class="pull-left MR7">
				<div class="headdrp">Project</div>
				<select multiple="multiple" name="Project" id="Project" class="Project">
						</select>

			</div>
			<div class="pull-left MR7">
				<div class="headdrp">Business group</div>
				<select multiple="multiple" name="Business" id="Business" class="Business">
				</select>
			</div>
			 <div class="pull-left MR7">
				<div class="headdrp">Batch date</div>
				<input type="text" class="form-control bgCal" name="batchDate" id="batchDate"
					 readonly="readonly" style="font-weight: normal;"/>
			</div>
			<div class="pull-left MR7">
				<div class="headdrp">Status</div>
				<select multiple="multiple" name="Status" id="status" class="Status">

				</select>
			</div>
			<div class="pull-left">
				<div class="headdrp">&nbsp;</div>
<!-- 				<input type="hidden" class="btn btn-primary" name="btnsubmit"
					value="Submit" id="btnsubmit" /> -->
				<!-- <a style="background: url(../script/images/trigger_report1.png);width:500px;height:500px"  id="export" href="#download">Trigger</a>-->
				<!-- <input type="button" value="" id="skuSearch1" class="button2"> -->
					
			</div>
			<div class="pull-right">
			<center>
			<table><tr><td width="40%">		<a class="button2"  href="#report" name="btnsubmit1" id="btnsubmit">Trigger<br/>Report</a></td>
			<td width="10%"></td><td width="40%">			<a class="exportBtn" id="export" href="#download" onclick="return formsubmit();">Export<br> Content</td></tr></table>
	

				</a>
				</center>
			</div> 
	

	<%
	LinkedHashMap fileDetailsMap = new LinkedHashMap();
	Iterator it = null;
	if(exportmod.equals(request.getParameter("export")))
{
		String dates=request.getParameter("batchDate");
		String date1[]=dates.split("-");
		/*fromdate1=dateFormat.format(date1[0].toString());
		todate1=dateFormat.format(date1[1].toString());*/
		fromdate1 = date1[0];
		SimpleDateFormat formatter = new SimpleDateFormat("dd/MM/yyyy"); 
		Date startdate = (Date)formatter.parse(fromdate1);
		SimpleDateFormat newFormat = new SimpleDateFormat("yyyy-MM-dd");
		fromdate1 = newFormat.format(startdate);
		todate1=date1[1];
		Date enddate = (Date)formatter.parse(todate1);
		todate1 = newFormat.format(enddate);
		String project_name[] = request.getParameterValues("Project");
		String cat_name[] = request.getParameterValues("Business");
		String status_name[] = request.getParameterValues("Status");
		
		ArrayList<String> files=new ArrayList();
		String catlist="",projectlist="",statuslist="";
		
		catlist=Arrays.toString(cat_name);
		projectlist=Arrays.toString(project_name);
		statuslist=Arrays.toString(status_name);
		
		catlist = catlist.replaceAll("\\[", "").replaceAll("\\]","");
		%>
		<input type="hidden" id="project_name" name="project_name" value='<%=projectlist%>'>
		<input type="hidden" id="cat_name" name="cat_name" value='<%=catlist%>'>
		<input type="hidden" id="status_name" name="status_name" value='<%=statuslist%>'>
		<input type="hidden" id="batch_date_hide" name="batch_date_hide" value='<%=dates%>'>
		<%
		String[] catarray=catlist.split(",");
		String key;
		String downfilepath;
		String project="",cat="",status="";
		int i=0,j=0,k=0;
		for(k=0;k<status_name.length;k++){
			status+=status_name[k]+",";
		}
		status=status.replaceAll(",$","");
		for(i=0;i<project_name.length;i++){
			
			project=project_name[i];
			for(j=0;j<catarray.length;j++){
				cat=catarray[j];
				
				query = "select ctprmap.cat_prd_id as prd_id from "+
						"(select max(mon_id) mon_id,cat_prd_id from monitor where `date` between '2015-09-01 00:00:00' and '2016-04-01 23:59:59' group by cat_prd_id ) monitor1 "+
						"inner join monitor mon on mon.mon_id = monitor1.mon_id "+
						"inner join cat_prd_map ctprmap on ctprmap.cat_prd_id = mon.cat_prd_id "+
						"inner join project_cat_map pcm on pcm.project_cat_map_id = ctprmap.project_cat_map_id "+
						"inner join project_master pm on pcm.project_id=pm.project_id "+
						"where pcm.project_cat_map_id in("+cat+") and mon.status_id in("+status+") and pm.project_id in ("+project+") "+		
						"and pcm.batch_date between '"+fromdate1+"' and '"+todate1+"' order by ctprmap.cat_prd_id,mon.status_id ";
						rs = C.createStatement().executeQuery(query);
						if(rs.next())
						{
							ServletContext context = getServletContext();
							String batchPath = context.getInitParameter("BatchPath");
							String exportPath = context.getInitParameter("ExportPath");
							ProductDelivery delivery = new ProductDelivery(cat,status,"2015-09-01","2016-04-01",project,person_id,"10.20.10.21:3306","writewell_3m","writewell","ugam@1234",batchPath,exportPath,"Client","Without","With");
							fileDetailsMap = delivery.DeliveryStart();
							it = fileDetailsMap.keySet().iterator();
							
							while(it.hasNext())
							{
								i++;
								key = it.next().toString();
								files.add(fileDetailsMap.get(key).toString());
							}
							}
		}
	}
		%>
		<input type=hidden name=files id=files value="<%=files.size()%>"/>
		<%
		if(files.size()>0){
		MyMultipleFileZip mfe = new MyMultipleFileZip();
		 downfilepath=mfe.zipFiles(files);
		
		 %>
		 
		 <div class="pull-right">
			
				<a class="exportrep" id="download" href="http://uatdp.ugamsolutions.com<%=downfilepath.replaceAll("^.*?/WriteWell/","/WriteWell/")%>" download>
				</a>
			</div> 
			<script>
		document.getElementById('download').click();
		</script>
		<%
		}
	}
	
	C.close();
	C = null;
	}
	catch(Exception ex)
	{
		//out.println("Page error"+ex);
		//ex.printStackTrace(new PrintWriter(response.getWriter()));
		ex.printStackTrace();
	}%>
			
<div class="loading" id="loading" style="display:none">
  <div>
    <div class="c1"></div>
    <div class="c2"></div>
    <div class="c3"></div>
    <div class="c4"></div>
  </div>
  <span>loading</span>
</div>
	</div>
	</div>
	</form>
	
	
	<script type="text/javascript">
		$(function() {
			$("#stackBar div[title]").tooltips();
		});
	</script>
	 <style type="text/css">
            .button1
            {
            background: url("/WriteWell/script/images/searchIcon.png") no-repeat;
            cursor:pointer;
                        border: none;
            }
        </style>
<div class="clearfix MT20" id="barStatus" style="margin-left:15px;">
			<div class="pull-left prdCnt">
			<div id="barT">
				<h2></h2>
				</div>
				<span>Total Products</span>

			</div>
			<div class="pull-left hBar" id="stackBar">
				<div class="acceptCnt">
					<h1></h1>
					<div  title="Accepted">Accepted</div>
				</div>
				<div class="rtrCnt">
					<h1></h1>
					<div title="Ready to Review">Ready to Review</div>
				</div>
				<div class="wipCnt">
					<h1></h1>
					<div title="WIP">WIP</div>
				</div>
				<div class="rejectCnt">
					<h1></h1>
					<div title="Rejected">Rejected</div>
				</div>
			</div>
			<div class="pull-right">
			<table><tr><td><input class="srcText" type="text" value="" placeholder="Search SKU Id" id="skuSearchId"></td>
			<td><!-- <img src="/WriteWell/script/images/searchIcon.png" id="skuSearch"> -->
			<input type="button" value="     " id="skuSearch" class="button1"></td></tr></table>
			</div>
		
		</div> 
	<!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->

	<script src="/WriteWell/script/js/jquery.sumoselect.min.js"></script>

	<script type="text/javascript">
		$(document).ready(function() {

			$('.Project').SumoSelect({
				okCancelInMulti : false,
				selectAll : true
			});
			
			$('.Business').SumoSelect({
				okCancelInMulti : false,
				selectAll : true
			});
			$('.Status').SumoSelect({
				okCancelInMulti : false,
				selectAll : true
			});

		});
		$(function() {
			$('input[name="batchDate"]').daterangepicker(
			{
				 locale: {
				      format: 'DD/MM/YYYY',
				      cancelLabel: 'Clear'
				    },
				    autoUpdateInput: false
				  
			}		
			);
			 $('input[name="batchDate"]').on('apply.daterangepicker', function(ev, picker) {
			      $(this).val(picker.startDate.format('DD/MM/YYYY') + ' - ' + picker.endDate.format('DD/MM/YYYY'));
			  });

			  $('input[name="batchDate"]').on('cancel.daterangepicker', function(ev, picker) {
			      $(this).val('');
			  });
		});
		
		
	</script>
	
	<script src="/WriteWell/script/js/bootstrap.min.js"></script>
	<script type="text/javascript" src="/WriteWell/script/js/moment.min.js"></script>
	<script type="text/javascript"
		src="/WriteWell/script/js/daterangepicker.js"></script>
	<!-- Datatable start -->
	<br />
	<div class="dt-buttons" id="example_export">
	<a id="report1" class="dt-button buttons-excel buttons-html5 export" tabindex="0" aria-controls="example" alt="Download"  title="Download"></a>
	</div>
	<table id="example" class="display" cellspacing="0" width="98%">
		<thead class="tblheader">
			<tr align="center">
				<!--<th style="border-right: solid 1px #cccccc;"></th>-->
				<th data-sorter="false" style="border-right: solid 1px #cccccc; border-left: solid 1px #ddd;"><img id="collapse_expand" src="/WriteWell/script/images/plus.png"/></th> 
				<th style="border-right: solid 1px #cccccc;"><div class="f1">Project</div></th>
				<th style="border-right: solid 1px #cccccc;"><div class="f2">Business
						Group</div></th>
				<th style="border-right: solid 1px #cccccc;"><div class="f2a">Category</div></th>
				<th style="border-right: solid 1px #cccccc;"><div class="f3">Batch
						Date</div></th>
				<th style="border-right: solid 1px #cccccc;"><div
						class="f4 text-center">Batch Count</div></th>
				<th style="border-right: solid 1px #cccccc;"><div
						class="f5 text-center">Product Marketing</div></th>
				<th style="border-right: solid 1px #cccccc;"><div
						class="f6 text-center">SKUs Completed (in %)</div></th>

			</tr>
		</thead>
	</table>
		<table id="example1" class="display" cellspacing="0" width="98%" >
		<thead class="tblheader">
			<tr align="center">
				<th style="border-right: solid 1px #cccccc;border-left: solid 1px #ddd;width: 90px;"><div>Project</div></th>
				<th style="border-right: solid 1px #cccccc;width: 70px;"><div>Business
						Group</div></th>
				<th style="border-right: solid 1px #cccccc;width: 80px;"><div>Category</div></th>						
				<th style="border-right: solid 1px #cccccc;width: 70px;"><div>Batch
						Date</div></th>
				<th style="border-right: solid 1px #cccccc;width: 90px;"><div
						>SKU ID</div></th>
				<th style="border-right: solid 1px #cccccc;width: 90px;"><div
						>SKU Name</div></th>
				<th style="border-right: solid 1px #cccccc;width: 80px;"><div
						>Status</div></th>
				<th style="border-right: solid 1px #cccccc;width: 70px;"><div
						>Approver</div></th>
				<th style="border-right: solid 1px #cccccc;width: 90px;"><div
						>Assigned on</div></th>
				<th style="border-right: solid 1px #cccccc;width: 90px;"><div
						>Last update date</div></th>																								
						
			</tr>
		</thead>

	</table>
	
	<!-- load jquery -->
	<input type="hidden" class="btn btn-primary" name="btnsubmitafter"
					value="Submit" id="btnsubmitafter"  />
	<input type="hidden" name="projectId" id="projectId" />
	<!-- Datatable End -->
	<script type="text/javascript">
	//Table sorter for date column - Start
	$(function() {
		var inside = /inside[0-9]+/gm; 
		  $(inside).tablesorter({
		    dateFormat : "ddmmyyyy", // set the default date format
		    headers: {
		      0: { sorter: "shortDate" } //, dateFormat will parsed as the default above
	    }

		  });
		});
	//Table sorter for date column - End
	var check=document.getElementById("cat_name").value;
	if(!check==""){ 
		
	$(document).ready(function(){
		setTimeout(function() {
			var filecount=document.getElementById("files").value;
			if(filecount==0){
				alert('There is no data to get exported!');
			}
			 $('#btnsubmit').trigger('click');
		},1000)
	 })
	 }
	</script>
	
</body>
</html>
