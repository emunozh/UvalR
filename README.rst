UvalR
=====

This simple script computes the U-Value for building components given the
characteristics of the individual layers of the component. The script also has a
small implementation which reads from an external file the properties of the
individual layers given an specific name. In order to make the functions
described on the main scriptt 'Uval.R' you have to run in within your working
session via::

    source("./Uval.R")

This means that the main scriptt 'Uval.R' has to be in the working path of your
environment. You can't just call the script using an absolute path as the scrip
will use the folder structure of the root folder. The easiest way to make sure 
that R finds the script is to point R into the right directory with the 'setwd()' 
command::

    setwd("~/workspace/R/UvalR")

The root folder structure is as follows::

    + root
    |---Data     # The script will look for a csv file containing materials data
    |               in this directory. The csv name has to be 'materials.csv'
    |---Examples # Some examples on how to run the scriptt.
    |---FIGURES  # The script will store the plots here.
    |---TABLES   # And the corresponding result data here.

The examples:
-------------

All the examples presented below are stores in the folder './Examples/'.

1) Reinforced concrete.
   
   .. include:: ./Examples/ReinforcedConcrete.R
      :code:
   
   This script will output the value: 0.1973745, that the U value of the
   building component in [W/m2K]
   
   It will also write two figures in folder './FIGURES/'

.. image:: ./FIGURES/ReinforcedConcrete_temperature.png
.. image:: ./FIGURES/ReinforcedConcrete_pressure.png

2) Light outside wall (Leichte Außenwand).
   
   .. include:: ./Examples/LeichteAussenwand.R
      :code:
   
   This script will output the value: 0.2240037, that the U value of the
   building component in [W/m2K]
   
   It will also write two figures in folder './FIGURES/'

.. image:: ./FIGURES/leichteAussenwand_temperature.png
.. image:: ./FIGURES/leichteAussenwand_pressure.png

3) Internal insulation (Innendämmung).
   
   .. include:: ./Examples/InnenDaemmung.R
      :code:
   
   This script will output the value: 0.4719366, that the U value of the
   building component in [W/m2K]
   
   It will also write two figures in folder './FIGURES/'

.. image:: ./FIGURES/Innendaemmung_temperature.png
.. image:: ./FIGURES/Innendaemmung_pressure.png

4) Using an external data file.

   This examples uses an external data file containing the properties of the
   different material layers. 
   
   .. include:: ./Examples/ExternalData.R
      :code:
   
   This script will output the value: 0.4814479, that the U value of the
   building component in [W/m2K]
   
   It will also write two figures in folder './FIGURES/'

.. image:: ./FIGURES/ExternalData_temperature.png
.. image:: ./FIGURES/ExternalData_pressure.png

