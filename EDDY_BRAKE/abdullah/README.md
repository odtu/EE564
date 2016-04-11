Bu dosyayı istediğin gibi değiştirip proje hakkındaki genel bilgileri ekleyebilirsin

#### C- Eddy Current Brake Design

In this project you are supposed to design an eddy current brake design which will be used as a mechanical damper. Here are some links on the eddy current brakes:

- [Eddy Current Demo](https://www.youtube.com/watch?v=Yu1uRvErM80)
- [Eddy Current Brake](https://en.wikipedia.org/wiki/Eddy_current_brake)
- [Eddy Current Brakes](http://www.explainthatstuff.com/eddy-current-brakes.html)
- [Design of Eddy Current Brakes](http://www.tcsme.org/Papers/Vol35/Vol35No1Paper2.pdf)

The eddy current brake has the following specs:

- Outer diameter smaller than 50 mm
- Axial Length shorther than 25 mm
- Required Force: 3 Nm at 1620 rpm
- Required Force: 1 Nm at 900 rpm

You don't have to, but I strongly advise you to use a FEA software (some options are listed above) for this project.

**Programmes Currently Using**
GitHub
Atom
&& yeni programlar gelecek

**Eddy Current Brake Explanation**
Just like friction brakes, Eddy Current Brakes also convert kinetic energy to heat. However, here drag force is electromagnetic force instead of friction.

Eddy current flows in a closed circular loop and this loop is perpendicular to the magnetic field. When the magnetic flux changes on the conductor, a current which creates a magnetic flux aiming to diminish the effect of first magnetic flux is formed.

Eddy Current's Magnitude depends on:
1) Magnitude of Magnetic field (proportional)
2) Area of the eddy current's circle (proportional)
3) Instantaneous change of magnetic flux in the circle (proportional)
4) Inner resistance of the conductor (inversely proportional)

**Formulas**
Magnetic Flux = Phi (Weber) = B (Tesla) * A (m^2) * cosa
