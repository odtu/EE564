// Copyright @2014 Lazar Rozenblat ( www.smps.us ). All rights reserved
function a1()
{
var v = Number(document.form1.v.value);  // Voltage 
if (v<=0 || v=="") {alert("C'mon, enter positive voltage");} else
if (v<15) {var am=0.1; var ai=0.0039; var bm=0.05; var bi=0.00197; var cm=0.13; var dm=0.05; var di=0.002; } else
if (v<30) {var am=0.1; var ai=0.0039; var bm=0.05; var bi=0.00197; var cm=0.25; var dm=0.05; var di=0.002; } else
if (v==30) {var am=0.1; var ai=0.0039; var bm=0.05; var bi=0.00197; var cm=(0.1+v*0.01); var dm=0.05; var di=0.002; } else
if (v<100) {var am=0.6; var ai=0.024; var bm=0.1; var bi=0.0039; var cm=(0.1+v*0.01); var dm=0.13; var di=0.00512; } else
if (v==100) {var am=0.6; var ai=0.024; var bm=0.1; var bi=0.0039; var cm=(0.6+v*0.005); var dm=0.13; var di=0.00512; } else
if (v<=150) {var am=0.6; var ai=0.024; var bm=0.2; var bi=0.0079; var cm=(0.6+v*0.005); var dm=0.4; var di=0.016; } else
if (v<=300) {var am=1.25; var ai=0.0492; var bm=0.2; var bi=0.0079; var cm=(0.6+v*0.005); var dm=0.4; var di=0.016; } else
if (v<=500) {var am=2.5; var ai=0.0984; var bm=0.25; var bi=0.00984; var cm=(0.6+v*0.005); var dm=0.8; var di=0.031; } else
{var am=Math.round(100*(0.005*v))/100; var ai=Math.round(10000*am/25.4)/10000; var bm=Math.round(1000*(0.0025*v-1.0))/1000; var bi=Math.round(1000*bm/25.4)/1000; var cm=(0.6+v*0.005); var dm=Math.round(100*(0.00305*v-0.725))/100; var di=Math.round(10000*dm/25.4)/10000; } 
document.form1.am.value = am;
document.form1.ai.value = ai;
document.form1.bm.value = bm;
document.form1.bi.value = bi;
document.form1.cm.value = Math.round(100*cm)/100;
document.form1.ci.value = Math.round(10000*cm/25.4)/10000;
document.form1.dm.value = dm;
document.form1.di.value = di;
}