var $form,$input,userInput;import{ev,el,log}from"/js/ksk-lib.js";$form=el("#callback-form"),$input=el("#callback-form-input"),userInput="",ev($form,"submit",function(u){u.preventDefault(),log("Send: "+$input.value),$input.value="",userInput=""}),ev($input,"input",function(u){var t,e,n,p,r;for(u.preventDefault(),"Enter"===u.data&&(log("Send: "+$input.value),$input.value="",userInput=""),null===u.data&&(userInput=userInput.substr(0,userInput.length-1)),/\d/.test(u.data)&&(userInput+=u.data),userInput.length||(userInput="8"),n="+7 (___) ___-__-__",1!==userInput.length||/[87]/.test(userInput)||(n=`+7 (${userInput}__) ___-__-__`),e=p=0,r=userInput.length;0<=r?p<r:p>r;e=0<=r?++p:--p)if(0!==e)n=n.replace("_",userInput[e]);else{if(/[87]/.test(userInput[e]))continue;userInput="8"+userInput}$input.value=n.slice(0,18),t=n.indexOf("_"),$input.setSelectionRange(t,t)}),ev($input,"blur",function(u){"8"===userInput&&($input.value="",userInput="")});