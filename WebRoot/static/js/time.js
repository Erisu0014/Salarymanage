function timeAxis(params) {
    $(".flowChart").append('<div class="startNode"></div>');
    var colorArr = [];

    //给每个对象添加color属性，并赋给一个随机的颜色
    for(var i=0;i<params.length;i++){
        params[i].color=getRandomColor();
    }
    for(var i=0;i<params.length;i++){

        //将所有相同value值的对象赋予相同的颜色
        for(var j=0;j<params.length;j++){
            if(params[i].value==params[j].value){
                params[j].color=params[i].color
            }
        }
        $(".flowChart").append('<div class="oneNode '+params[i].value+'" >' +
            '        <div class="solid"></div>' +
            '        <div class="check" style="background:'+params[i].color.colorRgba()+';border-color: '+params[i].color+' ">'+params[i].time+'</div>' +
            '        <div class="tag-boder"></div>' +
            '        <div class="NodeDetail" data-title="'+params[i].value+'">' +
            '            <div class="NodeDetail-content dot">'+params[i].value+'</div>' +
            '        </div>' +
            '    </div>'
        );

    }

    $(".flowChart").append('<div class="endNode"></div>');
    $(".flowChart .oneNode:even").addClass('upNode');
    $(".flowChart .oneNode:odd").addClass('bottomNode');
    $('.dot').dotdotdot();
}

//获得随机颜色
function getRandomColor()
{
    var c = '#';
    var cArray = ['0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'];
    for(var i = 0; i < 6;i++)
    {
        var cIndex = Math.round(Math.random()*15);
        c += cArray[cIndex];
    }
    return c;
}
//处理颜色
var reg = /^#([0-9a-fA-f]{3}|[0-9a-fA-f]{6})$/;
String.prototype.colorRgba = function(){
    var sColor = this.toLowerCase();
    if(sColor && reg.test(sColor)){
        if(sColor.length === 4){
            var sColorNew = "#";
            for(var i=1; i<4; i+=1){
                sColorNew += sColor.slice(i,i+1).concat(sColor.slice(i,i+1));
            }
            sColor = sColorNew;
        }
        //处理六位的颜色值
        var sColorChange = [];
        for(var i=1; i<7; i+=2){
            sColorChange.push(parseInt("0x"+sColor.slice(i,i+2)));
        }
        return "rgba(" + sColorChange.join(",") + ",0.8)";
    }else{
        return sColor;
    }
};

