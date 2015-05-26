(function(){
    /*-----------要加入一个新项，只需在对应的地方加上一个项，-----------*/
    /*-----------并补上其相对于根目录的相对地址，以及其名称-----------*/
    var nav=[
        {href:"index.html",text:"首页"},
        {href:"help/intro.html",text:"产品介绍"},
        {href:"help/developGuide.html",text:"产品入门"},
        {href:"doc/index.html",text:"类参考"},     
    ];

    //所打开文档的地址
    var path=document.location.toString();
 
    if( path.lastIndexOf("/doc/")!=-1){
 
        var index =  path.lastIndexOf("/doc/");
	}else if(path.lastIndexOf("/index.html")!=-1){
 
        var index = path.lastIndexOf("/index.html");
	}else{
 
        var index = path.lastIndexOf("/help/");
	}
 
 //根目录地址
	var commonPath=path.substring(0,index);


    var outer_head='<div class="navbar-inner">'+
        '<div class="container">'+
        '<a class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">'+
        '<span class="icon-bar"></span>'+
        '<span class="icon-bar"></span>'+
        '<span class="icon-bar"></span>'+
        '</a>'+
        '<a class="brand" href="'+commonPath+(commonPath==""?"":"/")+nav[0]["href"]+'">IOS API</a> '+
        '<div class="nav-collapse"> '+
        '<ul class="nav" id="titleContent"> ';
    var outer_foot='</ul>'+
        '</div>'+
        '</div>'+
        '</div> ';
    var inner="";
    for(var i=0;i<nav.length;i++)
    {
        var li=nav[i];
        if(li.dropdown==undefined)
        {
            inner+='<li class=""><a href="'+commonPath+(commonPath==""?"":"/")+li["href"]+'">'+li["text"]+'</a></li>';
        }
        else
        {
            var h= '<li class="dropdown"> '+
                '<a class="dropdown-toggle" data-toggle="dropdown" href="">'+li["text"]+' <b class="caret"></b></a> '+
                '<ul class="dropdown-menu"> ';
            var f= '</ul>'+
                '</li>';
            var dropDown="";
            var d_li=li["dropdown"];
            for(var j=0;j<d_li.length;j++)
            {
                if(d_li[j].dropdown==undefined)
                {
                    dropDown+='<li class=""><a href="'+commonPath+(commonPath==""?"":"/")+d_li[j]["href"]+'">'+d_li[j]["text"]+'</a></li>';
                }
                else
                {
                    var h2= '<li class=""><a href="'+commonPath+(commonPath==""?"":"/")+d_li[j]["href"]+'">'+d_li[j]["text"]+'</a>'+
                        '<ul > ';
                    var f2= '</ul>'+
                        '</li>';
                    var dropDown2="";
                    var d_li2=d_li[j]["dropdown"];
                    for(var k=0;k<d_li2.length;k++)
                    {
                        dropDown2+='<li class=""><a href="'+commonPath+(commonPath==""?"":"/")+d_li2[k]["href"]+'">'+d_li2[k]["text"]+'</a></li>';
                    }
                    dropDown+=h2+dropDown2+f2;
                }
            }
            inner+=h+dropDown+f;
        }
    }


    var navHtml=outer_head +inner+outer_foot;
    var navElement=document.getElementById("navbar");
    navElement.innerHTML=navHtml;

    /*查找导航条中与打开的文档地址一致的文件，并将其对应的li标签的className改为active，以利用样式*/
    var all_li=navElement.getElementsByTagName("li");
    for(var i=0;i<all_li.length;i++)
    {
        var a=all_li[i].childNodes[0];
        if(a.href==path|| (path.match(/-h\.html/)&& a.href==(commonPath+(commonPath==""?"":"/")+"doc/index.html")))
        {
            all_li[i].className="active";
        }
    }
})();
