showconsole()
mydir="./"
open(mydir .. "deneme.FEM")
mi_saveas(mydir .. "temp.fem")
mi_seteditmode("group")

mi_analyze()
mi_loadsolution()
mo_groupselectblock(1)
mass=7500*mo_blockintegral(10)
inertia=7500*mo_blockintegral(24)
---print(mass,inertia)

vx0=0
vy0=0
dt=0.1
omega0=0
by=14
bx=10
mo_clearblock()

for n=0,30 do
mi_analyze()
mi_loadsolution()
mo_groupselectblock(1)

fx=mo_blockintegral(18)
fy=mo_blockintegral(19)-(mass*9.8)

ax=(fx/mass)
ay=(fy/mass)

dx=vx0*dt+0.5*ax*dt*dt
dy=vy0*dt+0.5*ay*dt*dt

vx0=vx0+ax*dt
vy0=vy0+ay*dt

mo_clearblock()
mo_groupselectblock(2)
T=(-1)*mo_blockintegral(22)
alpha=T/inertia
omega=alpha*dt
omega0=omega0+omega
theta=omega0*dt*(180/pi)
mo_clearblock()
---print(n,fx,fy,T,theta)

if (n<30) then
mi_selectgroup(1)
mi_movetranslate(dx,dy)
mi_selectgroup(1)
mi_moverotate(bx,by,theta)
---print(n)
bx=bx+dx
by=by+dy
mo_clearblock()
mi_savebitmap("A"..n..".bmp")
mo_savebitmap("B"..n..".bmp")
end

end

---mo_close()
---mi_close()