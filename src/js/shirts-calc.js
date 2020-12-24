var $actions,$buttonAddToCart,$buttonOneClick,$controls,$total,alertActions,alertShow,currentCalc,renderTotal,state;import{log,el,els,ev,makeObserveble,nodeObserver,newEl,animation}from"/js/ksk-lib.js";import{handleInputTel}from"/js/ago-lib.js";import{current}from"/js/shirts-options.js";import{store}from"/js/store.js";import{cart}from"/js/cart.js";import{ws,ws_handlers}from"/js/ws.js";state=makeObserveble({}),$controls=el("#calc-controls"),$total=el("#calc-total"),$actions=el("#calc-actions"),$buttonAddToCart=el(".button-white",$actions),$buttonOneClick=el(".button-green",$actions),currentCalc={count:0,state:{}},handleInputTel(el("input",$actions)),document.documentElement.clientWidth>1200&&(el("#shirts>div:first-child").append($total),el("#shirts>div:first-child").append($actions)),renderTotal=function(){var t,e,r,n,a,s,o,i;o=store.dataFromServer.shirts.filter(function(t){return t.density_id===current.density&&t.color_id===current.color}),currentCalc.articles=function(){var e,r,n;for(n=[],e=0,r=o.length;e<r;e++)t=o[e],n.push(t.article);return n}(),currentCalc.state={},e=currentCalc.articles.reduce(function(t,e){var r,n;return currentCalc.state[e]=null!=(r=state[e])?r:0,t+(null!=(n=state[e])?n:0)},0),currentCalc.count=e,a=(r=cart.count+e)<100?"price":99<r&&r<1e3?"price_100":"price_1000",s=(n=store.dataFromServer.density.find(function(t){return t.id===current.density})[a]).toLocaleString("ru",{style:"currency",currency:"RUB"}),i=(e*n).toLocaleString("ru",{style:"currency",currency:"RUB"}),$total.innerHTML=`${e}шт. х ${s}<br>Итого: ${i}`,document.documentElement.clientWidth>1200&&$total.append($buttonAddToCart),e<=0?($total.classList.remove("show"),$actions.classList.remove("show"),setTimeout(function(){$total.style.display="none",$actions.style.display="none"},300)):($total.style.display="block",$actions.style.display="flex",setTimeout(function(){$total.classList.add("show"),$actions.classList.add("show")},0))},current.addObserver(function(t,e,r){var n,a,s,o;"color"===e&&(n=r,a=t.density,o=store.dataFromServer.sizes,s=store.dataFromServer.shirts.filter(function(t){return t.density_id===a&&t.color_id===n}),$controls.innerHTML="",s.sort(function(t,e){return t.id-e.id}),s.forEach(function(t){var e,r,n,a,s,i;r=document.createElement("div"),$controls.append(r),s=o.find(function(e){return e.id===t.size_id}),r.innerHTML=`<span>${s.euro}:</span>`,e=document.createElement("input"),r.append(e),e.value=null!=(n=state[t.article])?n:"0",a=!1,i=function(){var n,o;state[t.article]&&state[t.article]>t.count&&(state[t.article]=t.count,e.value=t.count,a||(a=!0,(n=document.createElement("div")).innerHTML=`<span>✖</span>На складе в данный момент <br> ${t.count} футболок размера ${s.euro}.<br>Если нужно больше, то Вы можете добавить футболки другой плотности или цвета этого же размера.`,n.className="alert",e.before(n),setTimeout(function(){n.classList.add("show")},100),o=function(){n.classList.remove("show"),setTimeout(function(){n.remove(),a=!1},300)},setTimeout(o,8e3),ev(document,"click",function(t){r.contains(t.target||t.target===r)||o()}),ev(el("span",n),"click",o))),state[t.article]<0&&(state[t.article]=0,e.value=0)},ev(e,"input",function(e){var r,n;null===e.data?(r=parseInt(this.value),state[t.article]=isNaN(r)?0:r):(/^\d$/.test(e.data)?state[t.article]=parseInt(this.value):this.value=null!=(n=state[t.article])?n:"",/^0\d+/.test(this.value)&&(this.value=parseInt(this.value)),i())}),ev(e,"click",function(t){"0"===this.value&&(this.value="")}),ev(e,"blur",function(t){""===this.value&&(this.value="0")}),[1,10,100].forEach(function(n){var a;return a=document.createElement("div"),[n,-n].forEach(function(r){var n;n=document.createElement("div"),a.append(n),"ontouchstart"in document.documentElement&&(n.className="touchable"),n.innerText=r>0?"+"+r:r,ev(n,"click",function(n){/-/.test(this.innerText)&&!state[t.article]||(state[t.article]=state[t.article]?state[t.article]+r:r,e.value=state[t.article],i())})}),r.append(a)})}),renderTotal())}),state.addObserver(function(t,e,r,n){renderTotal()}),ev($buttonAddToCart,"click",function(){var t,e,r,n,a,s,o,i;for(e=[],r=0,a=(o=currentCalc.articles).length;r<a;r++)t=o[r],state[t]>0&&(e.push({shirt_id:store.dataFromServer.shirts.find(function(e){return e.article===t}).id,count:state[t]}),delete state[t]);for(cart.add(e),renderTotal(),n=0,s=(i=els("input",$controls)).length;n<s;n++)i[n].value=0}),alertShow=!1,alertActions=function(t,e=!1,r=5e3){var n,a;alertShow||(alertShow=!0,(n=newEl("div")).setAttribute("id","alert-actions"),e&&n.classList.add("error"),n.innerHTML="<span>✖</span>"+t,el("#shirts>div:last-child").prepend(n),setTimeout(function(){return n.classList.add("show")},100),document.documentElement.clientWidth<600&&setTimeout(function(){return n.scrollIntoView(!1)},500),a=function(){return n.classList.remove("show")},ev(n,"transitionend",function(t){n.classList.contains("show")||"opacity"!==t.propertyName||(n.remove(),alertShow=!1)}),setTimeout(a,r),ev(el("span",n),"click",a),ev(document,"click",function(t){if(t.target!==n&&!n.contains(t.target))return a()}))},ev($actions,"submit",function(t){var e,r,n,a,s,o,i,c,l,u;if(t.preventDefault(),currentCalc.count<20)alertActions("Минимальное количество заказа не может быть менее 20шт.",!0);else if(!0,u=(e=document.forms["one-click"].elements.tel).value.replace(/[\+_\(\)\s-]/g,"").replace(/^7/,"8"),/^8\d{10}$/.test(u)){for(n={density:current.density,color:current.color,shirts:{},tel:u},a=0,o=(c=currentCalc.articles).length;a<o;a++)r=c[a],state[r]>0&&(n.shirts[store.dataFromServer.shirts.find(function(t){return t.article===r}).id]=state[r],delete state[r]);for(s=0,i=(l=els("input",$controls)).length;s<i;s++)l[s].value=0;renderTotal(),ws.send(JSON.stringify({type:"one_click",data:n})),e.value=""}else alertActions("Для покупки в один клик необходимо указать корректный номер телефона.",!0)}),ws_handlers.set("one-click-answer",function(t){alertActions(`Ваш заказ принят!<br><br>Номер заказа - ${t.order_id}.<br>Сумма заказа - ${t.price}<br><br>Мы сейчас свяжемся с Вами по указанному номеру для уточнения и подтвеждения заказа!`,null,6e5)});