Select the Inputs and Fit the Dihedral
======================================

Fit the dihedral for Ethane
---------------------------
The ethane HC-CT-CT-HC dihedral fit example is provided below, where nine (9) of the HC-CT-CT-HC dihedral are fit simultaneously.


.. note::
    The GOMC software need to be installed manually, outside of this Python install,
    with it's directory/path specified in the dihedral fit function.

Import the required packages.

.. code:: ipython3

    import unyt as u
    from mosdef_dihedral_fit.dihedral_fit.fit_dihedral_with_gomc import fit_dihedral_with_gomc

Select the desired variables, file, and set the temperature.

.. code:: ipython3

    # The MoSDeF force field (FF) XML file which will be used.
    FF_XML_file = 'path_to_file/oplsaa_ethane_HC_CT_CT_HC.xml'

    # The mol2 file which is used.
    mol2_file = 'path_to_file/ethane_aa.mol2'

    # The temperature of the Molecular Mechanics (MM) simulation.
    temperature_in_unyt_units = 298.15 * u.Kelvin

    # Choose mixing rule (override_VDWGeometricSigma_bool) to override the value (True or False)
    # that was chosen in the force field (FF) XML file.  This variable is not required and will be
    # selected automatically; however, you should override it if you are unsure of the setting.
    override_VDWGeometricSigma_bool = True

    # Atom type naming convention ( str, optional, default=’all_unique’, (‘general’ or ‘all_unique’) )
    # General is safe and recommended since we are using a single FF XML file.
    atom_type_naming_style = 'general'

    # The GOMC binary path.
    gomc_binary_directory = "path_to_GOMC_folder_GOMC_2_75/bin"

    # Load 1 or more Gaussian files (keys), and its value ([0]), which is a list of Gaussian points to remove
    # from the fitting process, where the first minimized Gaussian point is removed (i.e., ([0])).
    # More than 1 Gaussian file can be loaded, allowing the user to run multiple dihedral angles in separate file,
    # minimizing the time required to run the simulations
    # (i.e., the user can split them up into many simulations to obtain the full dihedral rotation).
    log_files_and_removed_points = {
        'path_to_file/HC_CT_CT_HC_multiplicity_1.log': [0],
    }

    # The dihedral which is being fit.
    fit_dihedral_atom_types = ['HC', 'CT', 'CT', 'HC']

    # All the other dihedrals which can be zeroed in the fitting process, in a nested list
    zeroed_dihedrals = None

Perform the dihedral fit using the Gaussian log file as the Quantum Mechanics (QM) engine
and GOMC Molecular Mechanics (MM) engine, and write out all the viable dihedral fits via the standard
OPLS equation.  It also outputs the periodic dihedral format and the RB torsions format,
which are analytically converted from the standard OPLS dihedral fit.

.. code:: ipython3

    # Run the "fit_dihedral_with_gomc" command.
    fit_dihedral_with_gomc(
        fit_dihedral_atom_types,
        mol2_file,
        FF_XML_file,
        temperature_in_unyt_units,
        gomc_binary_directory,
        log_files_and_removed_points,
        zeroed_dihedral_atom_types=zeroed_dihedrals,
        qm_engine="gaussian",
        override_VDWGeometricSigma=override_VDWGeometricSigma_bool,
        atom_type_naming_style='general',
        gomc_cpu_cores=1,
        fit_min_validated_r_squared=0.99,
        fit_validation_r_squared_rtol=1e-03
    )

