[![pre-commit.ci status](https://results.pre-commit.ci/badge/github/GOMC-WSU/MoSDeF-dihedral-fit/main.svg)](https://results.pre-commit.ci/latest/github/GOMC-WSU/MoSDeF-dihedral-fit/main)
[![CI](https://github.com/GOMC-WSU/MoSDeF-dihedral-fit/actions/workflows/CI.yml/badge.svg)](https://github.com/GOMC-WSU/MoSDeF-dihedral-fit/actions/workflows/CI.yml)

# MoSDeF-dihedral-fit
The MoSDeF-dihedral-fit: an open-source, transparent, and lightweight Python software package capable
of fitting dihedrals with QM calculations for existing forces fields. This software fits the [Optimized Potentials for Liquid Simulations (OPLS)](https://pubs.acs.org/doi/10.1021/ja9621760) style
dihedrals, then also analytically converts them to the periodic dihedral and
Ryckaert-Bellemans (RB) torsion.

```python
import unyt as u
from mosdef_dihedral_fit.dihedral_fit.fit_dihedral_with_gomc import fit_dihedral_with_gomc
fit_dihedral_with_gomc(
        ["HC", "CT", "CT", "HC"], #atomclass names of the dihedral
        "molecule.mol2" # mol2 file with relevant structure
        "compound.xml", # xml file with other atomtyped parameters in foyer format
        298.15 * u.Kelvin, # relevant temperature
        gomc_binary_directory, # path to binary command from GOMC install
        {"HC_CT_CT_HC_multiplicity_1.log": []}, # log file to store info
        zero_dihedral_atom_types=None,
        qm_engine="gaussian",
        combining_rule='lorentz',
        atom_type_naming_style='general',
        gomc_cpu_cores=1,
        r_squared_min=0.99,
        r_squared_rtol=1e-03
    )
import os
os.system("cat RB_torsion_k_constants_fit_energy.txt")
os.system("cat opls_torsion_k_constants_fit_energy.txt")
os.system("cat periodic_torsion_k_constants_fit_energy.txt")
```

### The plotted dihedral fits:
    - "opls_all_single_fit_dihedral_k_constants_figure.pdf"
    - "opls_all_summed_dihedrals_k_constants_figure.pdf"


## Quick Installation/Setup
```bash
mamba install -c conda-forge mosdef-dihedral-fit
git clone https://github.com/GOMC-WSU/GOMC.git --branch v2.75a
cd GOMC
chmod u+x metamake.sh
./metamake.sh
```
Add GOMC your path so it is called automatically with path entereed as "".
To so this, you must add the following to your ".bashrc" file or
equivalent file (if Mac maybe ".zshrc" depending on how you set up your
specific system). If a different than ".bashrc", replace ".bashrc" with ".XXXrc" file,
where XXX is your scripting language of choice, and can be found by running "$ echo $0". The first 2 commands add a
space and title to the command so it is known and traceable later.
The commands are listed below:

```bash
echo "" >> ~/.bashrc # could be switched out for .zshrc
echo "# Add the GOMC binary files to the path" >> ~/.bashrc
cwd=$(pwd) # you should still be in the GOMC directory cloned from github.
echo "export PATH=${cwd}/bin${PATH:+:${PATH}}" >> ~/.bashrc
```

#### More setup information
For more complete setup information see the [full installation documentation](https://github.com/GOMC-WSU/MoSDeF-dihedral-fit/blob/main/docs/getting_started/installation/installation.rst#installation)


## Documentation

The MoSDeF-dihedral-fit documentation can be found [here](https://mosdef-dihedral-fit.readthedocs.io/en/latest/).

## Dihedral Equations

<u>OPLS-dihedral</u>:

$$OPLS_{Energy} = \frac{f_0}{2}$$

$$+ \frac{f_1}{2} * (1 + cos(\theta)) + \frac{f_2}{2} * (1-cos(2 * \theta))$$

$$+ \frac{f_3}{2} * (1 + cos(3 * \theta)) + \frac{f_4}{2}  *(1-cos(4 * \theta))$$

<u>Ryckaert-Bellemans (RB)-torsions</u>:

$$RB_{Energy} = C_0$$

$$+ C_1 * cos(\psi) + C_2 * cos(\psi)^2$$

$$+ C_3 * cos(\psi)^3 + C_4 * cos(\psi)^4$$

$$\psi = \theta - 180^o$$

<u>Periodic-dihedral</u>:

$$Periodic_{Energy} = K_0 * (1 + cos(n_0*\theta - 90^o))$$

$$+ K_1 * (1 + cos(n_1*\theta - 180^o)) + K_2 * (1 + cos(n_2*\theta))$$

$$+  K_3 * (1 + cos(n_3*\theta - 180^o)) +  K_4 * (1 + cos(n_4*\theta))$$

## Examples
Some basic workflows that use this package</br>

 - [ethane dihedral](https://github.com/GOMC-WSU/GOMC_Examples/tree/main/MoSDeF-dihedral-fit/ethane_HC_CT_CT_HC)</br>
 - [propanoic acid dihedral](https://github.com/GOMC-WSU/GOMC_Examples/tree/main/MoSDeF-dihedral-fit/protonated_fragment_CT_CT_C_OH)</br>

## Resources
This package is made as an API with [MoSDeF](https://github.com/mosdef-hub) and [MoSDeF-GOMC](https://github.com/GOMC-WSU/MoSDeF-GOMC). For `mosdef_dihedral_fit` to function, the forcefield files must be in a supported MoSDeF format (preferably the GMSO force field format), and use MoSDeF-GOMC and GOMC to perform the simulation setup and simulations.

 - [MoSDeF tools](https://mosdef.org)
 - [MoSDeF-GOMC integration](https://mosdef-gomc.readthedocs.io/en/latest/index.html)
 - [GOMC Examples](https://github.com/GOMC-WSU/GOMC_Examples/tree/main/MoSDef-GOMC)
 - [MoSDeF GMSO Sample Forcefields](https://github.com/mosdef-hub/gmso/tree/main/gmso/utils/files/gmso_xmls/test_ffstyles)

## Citations

 - Please cite MoSDeF-GOMC [here](https://mosdef-gomc.readthedocs.io/en/latest/reference/citing_mosdef_gomc_python.html)
 - Other tools used in this package can be found in the MoSDeF-Dihedral-Fit documentation.
