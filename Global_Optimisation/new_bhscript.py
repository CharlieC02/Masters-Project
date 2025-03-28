#!/usr/bin/python

from ase.io import Trajectory
from ase.io import (read, write)
from ase.calculators.gulp import (GULP, Conditions)
from ase.optimize.new_basin import BasinHopping
from rdkit.Chem import (AllChem, MolFromMolBlock)
from rdkit import DataStructs
import openbabel
import os, sys

########## FUNCTION SECTION
def basin_hopping():
     nsteps = 10000
     bh = BasinHopping(atoms=cluster,
            temperature=5000,
            Acc=0.65,
            maxGnorm=0.5,
            dr=0.75,
            similarity_search = False,
            calculators=calc_list,
            adjust_cm=True,
            fix_Step = True,
            fix_Temp = False,
            swap_probability = 0.01,
            swap_elements = ['Si', 'Mg']
            )
     bh.run(nsteps)


def post_opti(energy_dif, num_structures):
      # Generation of folder to keep post_opt structures
      path = os.getcwd()
      path = path + '/post_opt'
      if os.path.exists(path):
              os.system('rm -r %s' % path)
      os.makedirs(path)
      # Selection of the M "distinct" lowest structures in BH run with Energy differences above DE
      traj = Trajectory('stru.traj')
      list_atoms = []
      for element in range(1,len(traj)):
            list_atoms.append((traj[element], traj[element].get_potential_energy()))
     
      sorted_list_atoms = sorted(list_atoms, key = lambda atoms: atoms[1])
      acc_atoms = [sorted_list_atoms[0]]
      e0 = sorted_list_atoms[0][1]
      for i in range(1,len(sorted_list_atoms)):
            ei = sorted_list_atoms[i][1]
            if abs(e0 - ei) > energy_dif:
                 acc_atoms.append(sorted_list_atoms[i])
                 e0 = sorted_list_atoms[i][1]
            if len(acc_atoms) == num_structures:
                 break
      # Optimizing
      structures_final = []
      failed_opts = 0
      for i in range(len(acc_atoms)):
            calc = calc_popt
            a_obj = acc_atoms[i][0].copy()
            a_obj.set_calculator(calc)
            try:
                  energy = a_obj.get_potential_energy()
                  structures_final.append((a_obj, energy))
            except:
                  failed_opts += 1
                  energy = acc_atoms[i][0].get_potential_energy()
                  write('Failed_{}.xyz'.format(failed_opts), acc_atoms[i][0])
       # Reordering and printing

      sorted_f_struct = sorted(structures_final, key = lambda atoms: atoms[1])
      e0 = sorted_f_struct[0][1] 
      for i in range(len(sorted_f_struct)):
            if i == 0:
                 sorted_f_struct[i][0].get_potential_energy()
                 num_struct = 1
                 string = "L{:03d}.xyz".format(num_struct)
                 outstruct = os.path.join(path, string)   
                 write(outstruct, sorted_f_struct[i][0])
            else:
                 ei = sorted_f_struct[i][1]
                 if abs(e0 - ei) > energy_dif:
                      num_struct += 1
                      e0 = sorted_f_struct[i][1]
                      string = "L{:03d}.xyz".format(num_struct)
                      outstruct = os.path.join(path, string)   
                      sorted_f_struct[i][0].get_potential_energy()
                      write(outstruct, sorted_f_struct[i][0])

             
def fgp_selected():
        path = os.getcwd()
        readpath = path + '/post_opt'
        writepath = path + '/fgp_selected'
        if os.path.exists(writepath):
                os.system('rm -r %s' % writepath)
        os.makedirs(writepath)

        def is_new_isomer(atoms_fp, list_atoms_fps):
                is_new = True
                for target in list_atoms_fps:
                        x = DataStructs.DiceSimilarity( atoms_fp, target )
                        if x == 1.0:
                                is_new = False
                if is_new is False:
                        return False
                else:
                        return True

        def get_fingerprint(atoms):
                xyz = "%d\n\n" % len(atoms)
                for i, symbol in enumerate(atoms.get_chemical_symbols()):
                        xyz += "%s   %f  %f  %f\n" % (symbol, atoms[i].x, atoms[i].y, atoms[i].z)
                obConversion = openbabel.OBConversion()
                obConversion.SetInAndOutFormats("xyz", "mdl")
                m = openbabel.OBMol()
                obConversion.ReadString(m, xyz)
                mol = obConversion.WriteString(m)
                rdkit_mol = MolFromMolBlock(mol)
                rd = AllChem.RemoveHs(rdkit_mol)
                fp = AllChem.GetMorganFingerprint(rd, 20)
                return fp

        isomers = []
        atoms = read(readpath +'/L001.xyz')
        fgp0 = get_fingerprint(atoms)
        isomers.append(fgp0)
        os.system("cp %s/L001.xyz %s/" % (readpath, writepath) )

        for filex in os.listdir(readpath):
                if filex.endswith('xyz'):
                        pass
                else:
                        continue
                atoms = read(readpath +'/' + filex)
                fgp = get_fingerprint(atoms)
                if is_new_isomer(fgp, isomers) is True:
                        isomers.append(fgp)
                        os.system("cp %s/%s %s/" % (readpath, filex, writepath) )


############ INITIAL STRUCTURE OPENING
if len(sys.argv) == 2:
    cluster = read(sys.argv[1])
else:
    try:
           cluster = read('initial.xyz')
    except:
           print('Starting structure not set-up: either provide the name of xyz of put a structure called "initial.xyz" in the folder')

###########################
# SET-UP SECTION
###########################

############ CONDITIONS TO RENAME ATOMS
#c = Conditions(cluster)
#c.set_rule({"min_distance_rule" : ('O', 'H', 'O2', 'H', 'O1')})

############ CALCULATORS
# Calculators for BH
calc1=GULP(keywords = 'opti conp',
    options=['xtol opt 3', 'gtol opt 3', 'ftol opt 3', 'stepmx 10', 'switch rfo 0.05', 'maxcyc 200'],
    library = "mgffsioh_ver4_noshell.lib")

calc2=GULP(keywords = 'opti conp ',
    shel=['O'],
    options=['xtol opt 5.0', 'gtol opt 5.0', 'ftol opt 5.0', 'switch rfo 0.005', 'maxcyc 1000'],
#    conditions= c,
    library = "mgffsioh_ver4.lib")

calc_list = [calc1,calc2]

# Calculator for Post Opt, by default is calc2 without low criterion of 
calc_popt = GULP(keywords = 'opti conp rfo', shel =['O'], library = "mgffsioh_ver4.lib")
calc_popt.options= None

############ POST OPT SETTINGS
num_structures = 1000
energy_diff = 0.001

################################
#         RUN SECTION
################################

basin_hopping()                               # Run the BH
post_opti(energy_diff, num_structures)        # Run the post optimization
fgp_selected()                                # DO the selection based on fingerprint
