using Plots
using InteractiveDynamics
using CairoMakie # choosing a plotting backend
using ColorSchemes
import ColorSchemes.balance
include("marker_template.jl")

###Function for drawing the plots for model step
function draw_figures(model, actual_areas::Vector{Float64}, previous_areas::Vector{Float64}, delta_max::Float64, new_pos::Vector{Tuple{Float64, Float64}}, path_points::Vector{Tuple{Float64, Float64}} = [], marker_arg = :circle, markersize_arg = 10)
        ##Draw the standard figure of the agents with their DODs after the step
        colours::Vector{Float64} = []
        rotations::Vector{Float64} = []
        allagents_iterable = allagents(model)
        target_area::Float64 = model.target_area
        com::Tuple{Float64, Float64} = center_of_mass(model)
        for id in 1:nagents(model)
        	push!(colours, happiness(model[id]))       
		#push!(colours, radial_distance(model[id], com)/200.0)
                #push!(colours, agent_regularity(model[id]))
                push!(rotations, atan(model[id].vel[2], model[id].vel[1]))
        	#push!(colours, distance(model[id].pos, best_pos[id])) #This is for helping cave ins. 
	end
        #figure, _ = abmplot(model)
        print("\n\n\ndraw_figures here. The number of points in new_pos is $(length(new_pos)), the first element is $(new_pos[1])\n")
        #print("About to do the figure\n")


        figure, ax, colourbarthing = Makie.scatter([model[i].pos for i in 1:nagents(model)], 
			axis = (;  limits = (0, rect_bound, 0, rect_bound), aspect = 1, title="Step $(model.n), FOV = $(model.fov) degrees, tdod = $(model.target_area)BL^2, q = $(model.q), qp = $(model.qp), m = $(model.m)"), 
			marker = simulation_marker,  markersize = simulation_markersize, 
			rotation = rotations, color = :black)
	hidedecorations!(ax)

	#=
        for i in 1:nagents(model)
                text!(new_pos[i], text = "$i", align = (:center, :top), fontsize = 30)
        end
	=#

        #print("The number of points in path points is $(length(path_points))\n")
        #draw_path(path_points)
        title!("Model state at step $(model.n)")
        #text!(model[model.tracked_agent].pos, text = "$(model.tracked_agent)", align = (:center, :top))
        ###tracking the radial distance of each agent from group center
        radial_distances::Vector{Float64}  = []
        #=for i in 1:nagents(model)
                push!(radial_distances, radial_distance(model[i], com))
        end
        for i in 1:nagents(model)
                text!(new_pos[i], text = "$(trunc(radial_distances[i]))", align = (:center, :top))
        end=#
        #show_move!(model, tracked_agent)
		#Colorbar(figure[1,2], colourbarthing)
      	#hidedecorations!(ax)
	save("./Simulation_Images/shannon_flock_n_=_$(model.n).png", figure)
end


function draw_actual_DODs(model, actual_areas::Vector{Float64}, previous_areas::Vector{Float64}, delta_max::Float64, new_pos::Vector{Tuple{Float64, Float64}}, path_points::Vector{Tuple{Float64, Float64}} = [])
        print("draw actual called\n") 
	##Draw the figure of the agents with their actual DODs
        for id in 1:nagents(model)
                colours[id] = actual_areas[id]/(pi*rho^2)
        end
        figure_actual, ax, colourbarthing = Makie.scatter([Tuple(point) for point in new_pos], axis = (; limits = (0, rect_bound, 0, rect_bound)), marker = '→', markersize = 20, rotations = rotations, color = colours, colormap = :viridis, colorrange = (0.0, 0.250)) #Note that I have no idea what the colorbarthing is for
        #=for i in 1:nagents(model)
                text!(new_pos[i], text = "$i", align = (:center, :top))
        end=#
        Colorbar(figure_actual[1,2], colourbarthing)
        #save("./Simulation_Images_Actual_Areas/shannon_flock_n_=_$(model.n).png", figure_actual)

end


function draw_delta_DOD(model, actual_areas::Vector{Float64}, previous_areas::Vector{Float64}, delta_max::Float64, new_pos::Vector{Tuple{Float64, Float64}}, path_points::Vector{Tuple{Float64, Float64}} = [])
        ##Draw the figure of the agents with their change in DOD
        for id in 1:nagents(model)
                #print("Current A is $(model[id].A), previous areas was $(previous_areas[id])\n")
                colours[id] = (abs(model[id].A - model.target_area)-abs(previous_areas[id]-model.target_area))/(2*delta_max)
        end
        figure_difference, ax, colourbarthing = Makie.scatter([Tuple(point) for point in new_pos], axis = (; limits = (0, rect_bound, 0, rect_bound)), marker = '→', markersize = 20, rotations = rotations, color = colours, colormap = :viridis, colorrange = (-0.1, 0.1)) #Note that I have no idea what the colorbarthing is for
        #=for i in 1:nagents(model)
                text!(new_pos[i], text = "$i", align = (:center, :top))
        end=#
        #Makie.scatter!([Tuple(point) for point in path_points], marker = :circle, color = :black, markersize = 20)
        #draw_path(path_points)
        Colorbar(figure_difference[1,2], colourbarthing)
        save("./Simulation_Images_Difference_Areas/shannon_flock_n_=_$(model.n).png", figure_difference)

end


###Function for drawing future figures and whatnot
function draw_figures_futures(model, actual_areas::Vector{Float64}, previous_areas::Vector{Float64}, delta_max::Float64, new_pos::Vector{Tuple{Float64, Float64}}, path_points::Vector{Tuple{Float64, Float64}} = [])
        ##Draw the standard figure of the agents with their DODs after the step
        colours::Vector{Float64} = []
        rotations::Vector{Float64} = []
        allagents_iterable = allagents(model)
        target_area::Float64 = model.target_area
        com::Tuple{Float64, Float64} = center_of_mass(model)
        for id in 1:nagents(model)
                #push!(colours, abs(model[id].A-model.target_area)/(delta_max))
                #push!(colours, radial_distance(model[id], com)/200.0)
                push!(colours, distance(model[id].pos, best_pos[id]))
                push!(rotations, atan(model[id].vel[2], model[id].vel[1]))
        end
        #figure, _ = abmplot(model)
        print("\n\n\nThe number of points in new_pos is $(length(new_pos)), the first element is $(new_pos[1])\n")
        #print("About to do the figure\n")


        #figure, ax, colourbarthing = Makie.scatter([Tuple(point) for point in new_pos], axis = (; title = "Model state at step $(model.n)", limits = (0, rect_bound, 0, rect_bound), aspect = 1), marker = '→', markersize = 20, rotations = rotations, color = colours, colormap = cgrad(:matter, 300, categorical = true))
	figure, ax, colourbarthing = Makie.scatter([model[i].pos for i in 1:nagents(model)], axis = (;  limits = (0, rect_bound, 0, rect_bound), aspect = 1), marker = :circle,  rotations = rotations, color = colours, colormap = :viridis, colorrange = (0.0, 100.0))
	Makie.scatter!([Tuple(best_pos[i]) for i in 1:nagents(model) if distance(best_pos[i], com) < 0.7 * distance(model[i].pos, com)], marker = :circle, color = :blue)
	
	for i in 1:length(new_pos)
		Makie.lines!([new_pos[i], best_pos[i]], color= :black)
	end

        for i in 1:nagents(model)
                if(distance(best_pos[i], com) < 0.7*distance(model[i].pos, com))
			text!(model[i].pos, text = "$i", align = (:center, :top), fontsize = 40)
		end
        end 

        #print("The number of points in path points is $(length(path_points))\n")
        #draw_path(path_points)
        #title!("Model state at step $(model.n)")
        #text!(model[model.tracked_agent].pos, text = "$(model.tracked_agent)", align = (:center, :top))
        ###tracking the radial distance of each agent from group center
        radial_distances::Vector{Float64}  = []
        #=for i in 1:nagents(model)
                push!(radial_distances, radial_distance(model[i], com))
        end
        for i in 1:nagents(model)
                text!(new_pos[i], text = "$(trunc(radial_distances[i]))", align = (:center, :top))
        end=#
        Colorbar(figure[1,2], colourbarthing)
        save("./Better_Positions/shannon_flock_n_=_$(model.n).png", figure)
end

function draw_better_positions(model, better_positions::Vector{Tuple{Float64, Float64}})
	figure, ax, colourbarthing = Makie.scatter([Tuple(point) for point in better_positions], axis = (;  limits = (0, rect_bound, 0, rect_bound), aspect = 1), marker = :circle, color = (:blue, 0.5))
	Makie.scatter!([model[i].pos for i in 1:nagents(model)], marker = :circle,  color = :black)
	save("./Better_Positions/shannon_flock_n_=_$(model.n).png", figure)
end

function draw_path(points)
        Makie.scatter!([Tuple(point) for point in points], marker = :circle, color = :black, markersize = 5)
end

function draw_half_planes_generic!(half_planes::Vector{Tuple{Float64, Tuple{Float64, Float64}, Tuple{Float64, Float64}, Int64}})
	for half_plane in half_planes
                rj::Tuple{Float64, Float64} = half_plane[3]
                pqj::Tuple{Float64, Float64} = half_plane[2]
		pqj = pqj ./ norm(pqj) .* 15.0
		Makie.arrows!([rj[1]-pqj[1]], [rj[2]-pqj[2]], [2*pqj[1]], [2*pqj[2]], color = :black, linewidth = 3)
        end
end

function draw_half_planes(id::Int64, positions::Vector{Tuple{Float64, Float64}}; fig_box = ((0.0, 0.0), (rect_bound, rect_bound)), markersize_arg = 40, label_offset = (0.0, 0.0))
	ri::Tuple{Float64, Float64} = positions[id]
	half_planes::Vector{Tuple{Float64, Tuple{Float64, Float64}, Tuple{Float64, Float64}, Int64}} = Vector{Tuple{Float64, Tuple{Float64, Float64}, Tuple{Float64, Float64}, Int64}}(undef, 0)
	n::Int64 = Int64(length(positions))
	 r_ji::Tuple{Float64, Float64} = (0.0, 0.0)
        half_plane_point::Tuple{Float64, Float64} = (0.0, 0.0)
        v_jix::Float64 = 0.0
        v_jiy::Float64 = 0.0
        pq::Tuple{Float64, Float64} = (0.0, 0.0)
        is_box::Int64 = -100000

	for j in 1:n	
		if(j == id) continue end
		r_ji = positions[j] .- ri
		half_plane_point = 0.5 .* r_ji .+ ri
		v_jix = -1.0 * (0.5 * r_ji[2])
                v_jiy = 0.5 * r_ji[1] #Hopefully you can see that this is literally just v = [-sin(\theta), \cos(\theta)]
		pq = (v_jix, v_jiy)
		angle = atan(v_jiy, v_jix)
		is_box = j
		half_plane = (angle, pq, half_plane_point, is_box)
		push!(half_planes, half_plane) 
	end

	figure, ax, colourbarthing = Makie.scatter(positions,axis = (;   limits = (fig_box[1][1], fig_box[2][1], fig_box[1][2], fig_box[2][2]), aspect = 1, ), marker = :circle,  markersize = markersize_arg, color = :black)
	for i in 1:n
		text!(positions[i] .+ label_offset, text = "$i", align= (:center, :top), fontsize = 40)
	end
	hidedecorations!(ax)
	for half_plane in half_planes
		rj::Tuple{Float64, Float64} = half_plane[3]
		pqj::Tuple{Float64, Float64} = half_plane[2]
		Makie.arrows!([rj[1], rj[1]], [rj[2], rj[2]], [-pqj[1], pqj[1]], [-pqj[2], pqj[2]], color = :red)
	end

	return figure	
end

function draw_half_planes_quick(id::Int64, model; fig_box = ((0.0, 0.0), (rect_bound, rect_bound)), label_offset = (0.0, 0.0))
	positions::Vector{Tuple{Float64, Float64}} = Vector{Tuple{Float64, Float64}}(undef, 0)
	for i in 1:nagents(model)
		push!(positions, model[i].pos)
	end
	return draw_half_planes(id, positions; fig_box, label_offset = label_offset)
end

function draw_best_pos(model, target_area; view_box = ((0.0, 0.0), (rect_bound, rect_bound)))
        positions::Vector{Tuple{Float64, Float64}} =Vector{Tuple{Float64, Float64}}(undef, 0)
        best_positions::Vector{Tuple{Float64, Float64}} =Vector{Tuple{Float64, Float64}}(undef, 0)
        n = nagents(model)
        for i in 1:n
                push!(positions, model[i].pos)
        end

        fig, ax = Makie.scatter(positions, axis = (;  limits = (view_box[1][1], view_box[2][1], view_box[1][2], view_box[2][2]), aspect = 1), marker = :circle,   color = :blue)

        for i in 1:n
                k1 = [0.0, 0.0, 0.0, 0.0]
                move_tuple = move_gradient_alt(model[i], model, k1, 8, 100, rho, target_area)
                print("The thing was $(move_tuple[1])\n")
                best_pos_i = move_tuple[1]
                push!(best_positions, best_pos_i)
        end

        Makie.scatter!(best_positions,  marker = :circle,   color = :cyan)
        for i in 1:length(positions)
                Makie.lines!([positions[i], best_positions[i]], color= :black)
        end

        return fig, ax

end
