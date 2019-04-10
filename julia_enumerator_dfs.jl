using Pkg
using LightGraphs, MetaGraphs
using IterTools
using DataStructures
using Base
using Combinatorics
using StatsBase
using Profile

include("iowa_graph.jl")



const iagr = make_iowa_graph()

ia_d = DefaultDict(Set)

for e in edges(iagr)
	push!(ia_d[src(e)], dst(e))
	push!(ia_d[dst(e)], src(e))
end

const ia_dict = ia_d


    


function distpop(om)
	g = induced_subgraph(iagr, [i for i in findall(x->x == 1,om)])[1]
	return sum( get_prop(g,v,:pop) for v in vertices(g)   )
end


function iowa_holes(om,pop_tol)
	g = induced_subgraph(iagr, [i for i in findall(x->x == 0,om)])[1]
	for c in connected_components(g)
		if sum( get_prop(g,v,:pop) for v in c  )  < pop_tol[1]
			return false  
		end
	end
	return true
end






function recurse_dfs(om, forbid, pop_tol, outf,minm,maxm)
	# 	if -1 ∉ sf.-om

	# end

	if distpop(om) > pop_tol[2]
		return

	elseif pop_tol[1] <= distpop(om) <= pop_tol[2] && iowa_holes(om,pop_tol)
		str = replace(string(om), "," => "")
		str = replace(str, "Int8" => "")
		str = replace(str, "[" => "")
		str = replace(str, "]" => "")
		str = replace(str, " " => "")
		write(outf,"$(str)\n")
		global found
		found +=1
		print("found:  ",found,"                  ",'\r')
	end



	cands = Set()
	for j=minm:maxm
		if om[j] == 1
			for n in ia_dict[j]
				if n>minm && om[n] ==0 && n ∉ forbid
					push!(cands,n)
				end
			end
		end

	end
	#cands = sort(collect(cands))
	newforbid = Set(forbid)
	for c in cands
		om[c] = 1
		if iowa_holes(om,pop_tol)
			recurse_dfs(om,newforbid,pop_tol,outf,minm,max(c,maxm))
			push!(newforbid,c)

			
		end
		om[c] = 0

	end


end





function enumerate(i)
	global found

		found = 0

		print('\n',i,'\n')
		outf = open("ia_dists_pm500/dfs-$i.txt","w")
		s = vec(zeros(Int8,1,99))
		s[i] = 1
		recurse_dfs(s,Set(),[761000,762000],outf,i,i)
		close(outf)
end



@time enumerate(2)
