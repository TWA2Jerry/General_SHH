This is a repository containing code for a generalised Selfish Herd Hypothesis. The model primarily explores the effect of optimising for non-minimal domains. 

To run the program, please ensure that you have the julia programming language installed. In addition, please have the packages installed: 
Agents
CSV
CairoMakie
ColorSchemes
Colors
DataFrames
GLMakie
GeometryBasics
Images
InteractiveDynamics
LaTeXStrings
PProf
StatsBase
TestImages
VoronoiCells
Profile
Random 

The main file for running in the simulations is "program.jl". Model parameters FOV, tdod, q, qp and m as well as other simulation details such as markers can be adjusted in "program.jl". You can run a simulation using the parameters by entering Julia, and typing: "include("program.jl")". 

Images from a simulation are generated in the folder "Simulation_Images". 

Global parameters, such as domain size, are set in "global_vars.jl". Specifically in this file, the number of agents in the model is set as variable no_birds. The size of the domain is set as the variable rect_bound.  

Unfortunately, I will be unable to regularly maintain the repository, so it is possible that updates to some of the packages may make current syntax invalid. However, the code should work for the following versions of each package:
Agents v6.2.4
CSV v0.10.15
CairoMakie v0.12.18
ColorSchemes v3.28.0
GeometryBasics v0.4.11
InteractiveDynamics v0.24.0
StatsBase v0.34.4
VoronoiCells v0.4.0

