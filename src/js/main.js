var $body,$burgerButton,$closeButton,$logo,$mainContainer,$nav,docWidth;import{el,ev,log}from"/js/ksk-lib.js";import"/js/smooth-scroll.js";import"/js/header.js";import"/js/callback-form.js";import"/js/ws.js";($nav=document.createElement("nav")).id="nav-top",($closeButton=document.createElement("span")).id="nav-top-close-button",$closeButton.innerText="ᗕ",($burgerButton=document.createElement("span")).id="burger-menu-button",$burgerButton.innerText="≑",($logo=el("#logoSVG").cloneNode(!0)).id="logoSVGNav",$nav.append($closeButton),$nav.append($logo),$nav.append(el("header>address").cloneNode(!0)),$nav.append(el("header>.lk-client").cloneNode(!0)),$nav.append(el("header>nav>ul").cloneNode(!0)),($mainContainer=el("#main-container")).prepend($nav),$nav.before($burgerButton),docWidth=document.documentElement.clientWidth,$body=el("body"),ev($burgerButton,"click",function(e){docWidth<=850&&($nav.style.left="0",setTimeout(function(){$body.classList.add("block-scroll")},300))}),ev($nav,"click",function(e){var o;if(docWidth<=850){if((o=e.target)===$nav||o===$logo)return;$body.classList.remove("block-scroll"),$nav.style.left="-380px"}}),ev(document,"scroll",function(e){var o;o=window.pageYOffset,docWidth>850&&($nav.style.top=o>710?"0":"-80px")});