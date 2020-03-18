# CS 1XA3 Project02 - <xus83@mcmaster.ca>
## Overview
This webpage is xus83's custom CV
## Custom Javascript Code
Description: This project is achieved mainly by a framework of JavaScript, which is Vue.js
Vue is a powerful and effcient framework, and comparing to others like React or Angular, Vue is relatively eaiser

**Feature 1**: Dropdown Menu in the Navigation bar\
When the mouse move to the buttons the menu shows up, and when the mouse leave both the button and the menu, it disappears

![nav bar](https://i.loli.net/2020/03/16/YjQ5qwPAZWEhKBI.png)
![settings](https://i.loli.net/2020/03/16/PMGYeXtHCSjRKUh.png)

**Feature 2**: Scroll Animation\
When scroll to setting position the background image fade out and a new one fade in, in case its scrolled back, the old image come back\
Whenscroll to other seeting position the words fade in, unlike the background image, those words intentionally stay there forever unless the page is refreshed

![scroll](https://i.loli.net/2020/03/16/BP7k91LIc4bpsiu.png)

**Feature 3**: Theme Change\
There are two ways to change the theme
* By selecting six preset colors
* By entering corresponding RGB value of any color
    * Have a function to determine if the input is RGB value

The navigation bar and most capable titles would turn to that color, and the buttons would turn to the contrasting color of that color since there is a function that
* Take a RGB value as input and calculate its contrasting color
* Then store the color to localStorage so that the theme would stay in that color next time the webpage is opened

![theme menu](https://i.loli.net/2020/03/16/4h2Bn3AvZIpk5eu.png)

**Feature 4**: Insite message\
* a clear button to clear the textarea after confirmation
* ~~message submission through jquery.ajax~~\
(aborted since I don't know the backend api for ajax to receive data)


aborted jquery.ajax code\
![image.png](https://i.loli.net/2020/03/18/T1BILXa7dSxw3MF.png)

## References
- The html document have taken some code from the following HTML Template from 
[w3school](https://www.w3schools.com/w3css/tryit.asp?filename=tryw3css_templates_cafe)
    * most of the taken code are css codes witch can be found [here](https://www.w3schools.com/w3css/4/w3.css)

    [stackoverflow](https://stackoverflow.com/questions/5002351/how-to-fade-changing-background-image)
    ```
    .bgimg1{
        background-image:url('../pics/coding1.jpg');
        transition: background 1s linear;
    }
    ```

- The following snippets of javascript code were altered from

    [stackoverflow](https://stackoverflow.com/questions/45822150/how-to-listen-to-the-window-scroll-event-in-a-vuejs-component)
    ```
    mounted() {
        //monitor if its scrolled and run changeBg method whenever scrolled
        window.addEventListener("scroll",this.changeBg);
        },
    ```

    [stackoverflow](https://stackoverflow.com/questions/32673760/how-can-i-know-if-a-given-string-is-hex-rgb-rgba-or-hsl-color-using-javascript)
    ```
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
    ```
- And a lot of Vue code come from the official Vue.js document [Vue.js](https://vuejs.org/v2/guide/components-custom-events.html)
- All of the pictures come from no copyright image website [Pixabay](https://pixabay.com/)
- The icon of the website is made by my self by Adobe Photoshop
- The font came from [Google Fonts](https://fonts.google.com/specimen/Raleway)