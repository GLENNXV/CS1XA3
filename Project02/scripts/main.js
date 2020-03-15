//apply Vue object to an variable for easier debugging
var vm=new Vue({
    //meaningless id name i picked randomly xD
    //this is just a small project with simple logic so there is only 1 Vue object
    el:"#np",
    data:{
        //determine which background image to be shown
        bg1:true,
        bg2:false,
        //either to show contact information or not
        showC:false,
        showS:false,
        showP:false,
        showT:false,
        showL:false,
        showT1:false,
        showT2:false,
        showT3:false,
        //theme color (RGB)
        theme:"#000000",
        selected:"",
        typed:"",
        colorL:{'Black':'#000000','White':'#ffffff','SkyBlue':'#87CEEB','Indigo':'#4B0082','GreenYellow':'#ADFF2F','Maroon':'#800000'},
        lang:'en-CA'
    },
    methods:{
        //change background image when it's scrolled to setting position
        //and show words when scrolled to setting position
        changeBg:function(){
            if(
                !!document.documentElement.scrollTop &&
                document.documentElement.scrollTop > 450
            ){
                this.bg1=false;
                this.bg2=true;
            }else{
                this.bg2=false;
                this.bg1=true;
            }
            if(
                !!document.documentElement.scrollTop &&
                document.documentElement.scrollTop > 2880
            ){
                this.showT=true
            }
            if(
                !!document.documentElement.scrollTop &&
                document.documentElement.scrollTop > 3330
            ){
                this.showT1=true
            }
            if(
                !!document.documentElement.scrollTop &&
                document.documentElement.scrollTop > 3510
            ){
                this.showT2=true
            }
            if(
                !!document.documentElement.scrollTop &&
                document.documentElement.scrollTop > 3960
            ){
                this.showT3=true
            }
        },
        //methods that control either to show contact information or not
        showContact:function(){
            this.showC=true;
        },
        offContact:function(){
            this.showC=false;
        },
        showSet:function(){
            this.showS=true;
        },
        offSet:function(){
            this.showS=false;
        },
        showPanel:function(){
            this.showP=true;
        },
        offPanel:function(){
            this.showP=false;
        },
        submit:function(){
            if(checkIsColor(this.typed)){
                this.theme=this.typed
            }else{
                alert('invalid input, please enter correct RGB value')
            }
        },
        showLang:function(){
            this.showL=true;
        },
        offLang:function(){
            this.showL=false;
        },
    },
    computed:{
        //transfer RGB color to its contrasting color
        conTheme:function(){
            let hexR=this.theme.split("").slice(1,3).join("");
            let hexG=this.theme.split("").slice(3,5).join("");
            let hexB=this.theme.split("").slice(5,7).join("");
            let colorR=255-parseInt(hexR,16);
            let colorG=255-parseInt(hexG,16);
            let colorB=255-parseInt(hexB,16);
            //in case it's "00"
            if(colorR===0){var strR="00"}else{var strR=colorR.toString(16)}
            if(colorG===0){var strG="00"}else{var strG=colorG.toString(16)}
            if(colorB===0){var strB="00"}else{var strB=colorB.toString(16)}
            //in case it's "0X"
            if(strR.length===1){var strR="0"+strR}
            if(strG.length===1){var strG="0"+strG}
            if(strB.length===1){var strB="0"+strB}
            return "#"+strR+strG+strB
        },
    },
    watch:{
        selected:function(){
            this.theme=this.colorL[vm.selected];
        },
        theme:function(){
            if(typeof(Storage)!=="undefined")
            {
                localStorage.theme=vm.theme;
            }
            else
            {
                document.getElementById("result").innerHTML="sorry your brower does not support web storage";
            }
        },
    },
    created:function(){
        if(localStorage.theme!==undefined){
            this.theme=localStorage.theme
        }else{
            this.theme='#000000'
        }
    },
    mounted(){
        //monitor if its scrolled and run changeBg method whenever scrolled
        window.addEventListener("scroll",this.changeBg);
    },
})
//determine if its RGB value
//taken from stackoverflow
function checkIsColor(bgVal) {
    var type = "^#[0-9a-fA-F]{6}$";
    var re = new RegExp(type);
    if (bgVal.match(re) == null) {
        type = "^[rR][gG][Bb][\(]([\\s]*(2[0-4][0-9]|25[0-5]|[01]?[0-9][0-9]?)[\\s]*,){2}[\\s]*(2[0-4]\\d|25[0-5]|[01]?\\d\\d?)[\\s]*[\)]{1}$";
        re = new RegExp(type);
        if (bgVal.match(re) == null) {
            return false;
        } else {
            return true;
        }
    } else {
        return true;
    }
}