(function(){var t,e,n,s,a,c,o,i,l,r,u,d,f,v,g,m,h,x,b,C,L;for(function(...t){return console.log(...t)},g=function(t,e=document){return e.querySelectorAll(t)},m=function(t,e,n){t.addEventListener(e,n)},s=(v=function(t,e=document){return e.querySelector(t)})("#size-a"),a=v("#size-b"),c=v("#size-c"),o=v("#size-d"),t=[s,a,c,o],u=[],d="155г/м² - S",l=v("#exact-sizes tbody"),C=g(".S155",l),h=x=0,b=C.length;x<b;h=++x)(r=C[h]).classList.add("active"),t[h].textContent=r.textContent,u.push(r.textContent);(n=document.createElement("span")).className="label",o.after(n),m(l,"mouseover",function(e){var s,a,c,o,i,u;if(!e.target.classList.contains("active")&&(s=e.target.className.split(" ")[0])){for(u=g("."+s,l),h=a=0,o=u.length;a<o;h=++a)(r=u[h]).classList.add("hover"),t[h].textContent=r.textContent;for(c=0,i=t.length;c<i;c++)t[c].style.background="#ffdbbc";n.style.background="#ffdbbc",L(s)}}),m(l,"mouseout",function(e){var s,a,c,o,i,f,v;if(a=e.target.className.split(" ")[0]){for(c=0,i=(v=g("."+a,l)).length;c<i;c++)(r=v[c]).classList.remove("hover");for(h=o=0,f=t.length;o<f;h=++o)(s=t[h]).style.background="",s.textContent=u[h];n.style.background="",n.textContent=d}}),m(l,"click",function(e){var s,a,c,o,i,f,v;if(!e.target.classList.contains("active")&&(s=e.target.className.split(" ")[0])){for(u=[],a=0,o=(f=g(".active",l)).length;a<o;a++)(r=f[a]).classList.remove("active");for(v=g("."+s,l),h=c=0,i=v.length;c<i;h=++c)(r=v[h]).className=s+" active",t[h].textContent=r.textContent,t[h].style.background="",u.push(r.textContent);n.style.background="",d=L(s)}}),(L=function(t){var e,s;return[,s,e]=t.match(/^(\D+)(\d+)$/),n.textContent=e+"г/м² - "+s,n.textContent})("S155"),document.documentElement.clientWidth<600&&(f="show-155",(i=v("#exact-sizes table")).classList.add(f),m(e=v("#exact-sizes-controls"),"click",function(t){t.target.classList.contains("active")||(v(".active",e).classList.remove("active"),t.target.classList.add("active"),i.classList.remove(f),f="show-"+t.target.textContent.match(/^\d+/)[0],i.classList.add(f))}))}).call(this);