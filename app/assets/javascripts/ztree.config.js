$(".examines").ready(function() {

  if ($(".examines.drct_org").length > 0 ) {
    var leftNodes = gon.leftnodes; 
    var rightNodes = JSON.parse(gon.rightnodes); 
    var settingLeft = {
			edit: {
				enable: true,
				showRemoveBtn: false,
				showRenameBtn: false
			},
			data: {
        keep: {
          leaf: true,
          parent: true
        },
				simpleData: {
					enable: true
				}
			},
			callback: {
				beforeDrag: beforeDrag,
				beforeDrop: beforeDrop
			}
		};
    var settingRight = {
      view: {
        addHoverDom: addHoverDom,
        removeHoverDom: removeHoverDom,
        selectedMulti: false
      },
	  	edit: {
	  		enable: true,
        editNameSelectAll: true,
	  		showRemoveBtn: showRemoveBtn,
	  		showRenameBtn: showRenameBtn
	  	},
	  	data: {
        keep: {
          leaf: true,
          parent: true
        },
	  		simpleData: {
	  			enable: true 
	  		}
	  	},
	  	callback: {
        beforeDrag: beforeDrag,
        beforeEditName: beforeEditName,
        beforeRemove: beforeRemove,
        beforeRename: beforeRename,
        onRemove: onRemove,
        onRename: onRename
	  	}
	  };
    $.fn.zTree.init($("#treeLeft"), settingLeft, leftNodes);
    $.fn.zTree.init($("#treeRight"), settingRight, rightNodes);

    zTree = $.fn.zTree.getZTreeObj("treeRight");

    $("#test").click(function(){
      var nodes = zTree.transformToArray(zTree.getNodes());
      var json = getNodesJson(nodes);
      console.log(json);
      var json_str = JSON.stringify(json);
      var url = "/examines/" + gon.examine +"/create_drct";
      $.post(url, {'drct_data': json_str}, function(data){
        alert(data['status']);
      });
    });
  }

});

var log, className = "dark";
function beforeEditName(treeId, treeNode) {
	className = (className === "dark" ? "":"dark");
	showLog("[ "+getTime()+" beforeEditName ]&nbsp;&nbsp;&nbsp;&nbsp; " + treeNode.name);
	var zTree = $.fn.zTree.getZTreeObj("treeRight");
	zTree.selectNode(treeNode);
	setTimeout(function() {
		zTree.editName(treeNode);
	}, 0);
  /*
	setTimeout(function() {
		if (confirm("进入节点 -- " + treeNode.name + " 的编辑状态吗？")) {
		}
	}, 0);
  */
	return false;
}
function beforeRemove(treeId, treeNode) {
	className = (className === "dark" ? "":"dark");
	showLog("[ "+getTime()+" beforeRemove ]&nbsp;&nbsp;&nbsp;&nbsp; " + treeNode.name);
	var zTree = $.fn.zTree.getZTreeObj("treeRight");
	zTree.selectNode(treeNode);
	return confirm("确认删除 节点 -- " + treeNode.name + " 吗？");
}
function onRemove(e, treeId, treeNode) {
	showLog("[ "+getTime()+" onRemove ]&nbsp;&nbsp;&nbsp;&nbsp; " + treeNode.name);
}
function beforeRename(treeId, treeNode, newName, isCancel) {
	className = (className === "dark" ? "":"dark");
	showLog((isCancel ? "<span style='color:red'>":"") + "[ "+getTime()+" beforeRename ]&nbsp;&nbsp;&nbsp;&nbsp; " + treeNode.name + (isCancel ? "</span>":""));
	if (newName.length == 0) {
		setTimeout(function() {
			var zTree = $.fn.zTree.getZTreeObj("treeRight");
			zTree.cancelEditName();
			alert("节点名称不能为空.");
		}, 0);
		return false;
	}
	return true;
}
function onRename(e, treeId, treeNode, isCancel) {
	showLog((isCancel ? "<span style='color:red'>":"") + "[ "+getTime()+" onRename ]&nbsp;&nbsp;&nbsp;&nbsp; " + treeNode.name + (isCancel ? "</span>":""));
}
function showRemoveBtn(treeId, treeNode) {
	//return !treeNode.isFirstNode;
	return treeNode.level != 0 && treeNode.isParent;
}
function showRenameBtn(treeId, treeNode) {
	//return !treeNode.isLastNode;
	return treeNode.level != 0 && treeNode.isParent;
}
function showLog(str) {
	if (!log) log = $("#log");
	log.append("<li class='"+className+"'>"+str+"</li>");
	if(log.children("li").length > 8) {
		log.get(0).removeChild(log.children("li")[0]);
	}
}
function getTime() {
	var now= new Date(),
	h=now.getHours(),
	m=now.getMinutes(),
	s=now.getSeconds(),
	ms=now.getMilliseconds();
	return (h+":"+m+":"+s+ " " +ms);
}

var newCount = 1;
function addHoverDom(treeId, treeNode) {
	var sObj = $("#" + treeNode.tId + "_span");
	if (treeNode.editNameFlag || $("#addBtn_"+treeNode.tId).length>0) return;
  if (treeNode.isParent == true) {
  	var addStr = "<span class='button add' id='addBtn_" + treeNode.tId
  		+ "' title='add node' onfocus='this.blur();'></span>";
  	sObj.after(addStr);
  	var btn = $("#addBtn_"+treeNode.tId);
  	if (btn) btn.bind("click", function(){
  		var zTree = $.fn.zTree.getZTreeObj("treeRight");
  		zTree.addNodes(treeNode, {id:(100 + newCount), pId:treeNode.id, name:"new node" + (newCount++), isParent: true});
  		return false;
  	});
  }
}
function removeHoverDom(treeId, treeNode) {
	$("#addBtn_"+treeNode.tId).unbind().remove();
}
function selectAll() {
	var zTree = $.fn.zTree.getZTreeObj("treeRight");
	zTree.setting.edit.editNameSelectAll =  $("#selectAll").attr("checked");
}
function getNodesJson(nodes){
  var root = nodes[0];
  var json = {};
  var arr = [];

  json.name = root.name;
  var child1 = root.children;

  node_recur(child1, arr);
  json.children = arr;
  return json;
}



//递归遍历所有节点形成json
function node_recur(child, arrs) {
  for (var i=0; i<child.length; i++){
    var json1 = {};
    var arr1 = [];
    json1.name = child[i].name;
    json1.nodeid = child[i].nodeid;
    json1.isParent = child[i].isParent;
    
    if (child[i].children != undefined) 
    {
      var child2= child[i].children
      for (var j=0; j<child2.length; j++){
        var json2 = {};
        var arr2 = [];
        json2.name = child2[j].name
        json2.nodeid = child2[j].nodeid
        json2.isParent = child2[j].isParent;
        
        if (child2[j].children != undefined)
        {
          var child3 = child2[j].children
          node_recur(child3, arr2);
          json2.children = arr2;
        }
        arr1.push(json2);
      }
      json1.children = arr1;
    }
    arrs.push(json1)
  }
}
/*var zNodes = [
  {name:"test1", open:true, children:[
    {name:"test1_1"}, {name:"test1_2"}]},
  {name:"test2", open:true, children:[
    {name:"test2_1"}, {name:"test2_2"}]}
];*/
function beforeDrag(treeId, treeNodes) {
	for (var i=0,l=treeNodes.length; i<l; i++) {
		if (treeNodes[i].drag === false) {
			return false;
		}
	}
	return true;
}
function beforeDrop(treeId, treeNodes, targetNode, moveType) {
  //return targetNode ? targetNode.drop !== false : true; //默认的配置
  flag = true;
  if (targetNode) {
    if (targetNode.level == 0 && (moveType == "prev" || moveType == "next")) {
      flag = false;
    }
  } else {
    flag = false;
  }
  return flag; 
}









