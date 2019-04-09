using Pkg
using LightGraphs, MetaGraphs
using IterTools
using DataStructures
using Base
using Combinatorics
using StatsBase
using Profile



function make_iowa_graph()

	g = MetaGraph(SimpleGraph(99))

	add_edge!(g , 1 , 2 )
	add_edge!(g , 1 , 12 )

	add_edge!(g , 2 , 3 )
	add_edge!(g , 2 , 13 )

	add_edge!(g , 3 , 4 )
	add_edge!(g , 3 , 14 )

	add_edge!(g , 4 , 5 )
	add_edge!(g , 4 , 15 )

	add_edge!(g , 5 , 6 )
	add_edge!(g , 5 , 15 )
	add_edge!(g , 5 , 16 )
	add_edge!(g , 5 , 26 )

	add_edge!(g , 6 , 16 )
	add_edge!(g , 6 , 7 )

	add_edge!(g , 7 , 8 )
	add_edge!(g , 7 , 17 )

	add_edge!(g , 8 , 9 )
	add_edge!(g , 8 , 17 )
	add_edge!(g , 8 , 18 )

	add_edge!(g , 9 , 10 )
	add_edge!(g , 9 , 19 )

	add_edge!(g , 10 , 11 )
	add_edge!(g , 10 , 19 )
	add_edge!(g , 10 , 20 )

	add_edge!(g , 11 , 21 )

	add_edge!(g , 12 , 13 )
	add_edge!(g , 12 , 22 )
	add_edge!(g , 12 , 14 )

	add_edge!(g , 13 , 23 )

	add_edge!(g , 14 , 15 )
	add_edge!(g , 14 , 24 )

	add_edge!(g , 15 , 25 )

	add_edge!(g , 16 , 17 )
	add_edge!(g , 16 , 27 )

	add_edge!(g , 17 , 18 )
	add_edge!(g , 17 , 28 )

	add_edge!(g , 18 , 19 )
	add_edge!(g , 18 , 29 )

	add_edge!(g , 19 , 20 )
	add_edge!(g , 19 , 30 )

	add_edge!(g , 20 , 21 )
	add_edge!(g , 20 , 30 )
	add_edge!(g , 20 , 40 )

	add_edge!(g , 21 , 41 )
	add_edge!(g , 21 , 42 )

	add_edge!(g , 22 , 23 )
	add_edge!(g , 22 , 31 )

	add_edge!(g , 23 , 24 )
	add_edge!(g , 23 , 31 )
	add_edge!(g , 23 , 32 )

	add_edge!(g , 24 , 25 )
	add_edge!(g , 24 , 33 )

	add_edge!(g , 25 , 26 )
	add_edge!(g , 25 , 34 )
	add_edge!(g , 25 , 35 )

	add_edge!(g , 26 , 27 )
	add_edge!(g , 26 , 35 )

	add_edge!(g , 27 , 28 )
	add_edge!(g , 27 , 35 )
	add_edge!(g , 27 , 36 )

	add_edge!(g , 28 , 29 )
	add_edge!(g , 28 , 37 )

	add_edge!(g , 29 , 30 )
	add_edge!(g , 29 , 38 )
	add_edge!(g , 29 , 39 )

	add_edge!(g , 30 , 39 )

	add_edge!(g , 31 , 32 )
	add_edge!(g , 31 , 43 )

	add_edge!(g , 32 , 33 )
	add_edge!(g , 32 , 44 )

	add_edge!(g , 33 , 34 )
	add_edge!(g , 33 , 44 )
	add_edge!(g , 33 , 45 )

	add_edge!(g , 34 , 35 )
	add_edge!(g , 34 , 45 )
	add_edge!(g , 34 , 46 )

	add_edge!(g , 35 , 36 )
	add_edge!(g , 35 , 46 )
	add_edge!(g , 35 , 47 )

	add_edge!(g , 36 , 37 )
	add_edge!(g , 36 , 47 )
	add_edge!(g , 36 , 48 )

	add_edge!(g , 37 , 38 )
	add_edge!(g , 37 , 48 )
	add_edge!(g , 37 , 49 )

	add_edge!(g , 38 , 39 )
	add_edge!(g , 38 , 49 )
	add_edge!(g , 38 , 50 )

	add_edge!(g , 39 , 40 )
	add_edge!(g , 39 , 50 )
	add_edge!(g , 39 , 51 )

	add_edge!(g , 40 , 41 )
	add_edge!(g , 40 , 51 )
	add_edge!(g , 40 , 52 )
	add_edge!(g , 41 , 42 )
	add_edge!(g , 41 , 52 )
	add_edge!(g , 41 , 53 )
	add_edge!(g , 42 , 53 )
	add_edge!(g , 42 , 54 )
	add_edge!(g , 43 , 44 )
	add_edge!(g , 43 , 55 )
	add_edge!(g , 44 , 45 )
	add_edge!(g , 44 , 55 )
	add_edge!(g , 44 , 56 )
	add_edge!(g , 45 , 46 )
	add_edge!(g , 45 , 57 )
	add_edge!(g , 45 , 58 )
	add_edge!(g , 46 , 47 )
	add_edge!(g , 46 , 58 )
	add_edge!(g , 46 , 59 )
	add_edge!(g , 47 , 48 )
	add_edge!(g , 47 , 59 )
	add_edge!(g , 47 , 60 )
	add_edge!(g , 48 , 49 )
	add_edge!(g , 48 , 60 )
	add_edge!(g , 48 , 61 )
	add_edge!(g , 49 , 50 )
	add_edge!(g , 49 , 61 )
	add_edge!(g , 50 , 51 )
	add_edge!(g , 50 , 62 )
	add_edge!(g , 51 , 52 )
	add_edge!(g , 51 , 63 )
	add_edge!(g , 52 , 53 )
	add_edge!(g , 52 , 64 )
	add_edge!(g , 52 , 65 )
	add_edge!(g , 53 , 54 )
	add_edge!(g , 53 , 65 )
	add_edge!(g , 53 , 66 )
	add_edge!(g , 54 , 66 )
	add_edge!(g , 55 , 56 )
	add_edge!(g , 55 , 69 )
	add_edge!(g , 56 , 57 )
	add_edge!(g , 56 , 69 )
	add_edge!(g , 56 , 70 )
	add_edge!(g , 57 , 58 )
	add_edge!(g , 57 , 70 )
	add_edge!(g , 58 , 59 )
	add_edge!(g , 58 , 71 )
	add_edge!(g , 59 , 60 )
	add_edge!(g , 59 , 72 )
	add_edge!(g , 60 , 61 )
	add_edge!(g , 60 , 73 )
	#add_edge!(g , 60 , 74 )
	add_edge!(g , 61 , 62 )
	add_edge!(g , 61 , 74 )
	add_edge!(g , 61 , 75 )
	add_edge!(g , 62 , 63 )
	add_edge!(g , 62 , 75 )
	add_edge!(g , 62 , 76 )
	add_edge!(g , 63 , 64 )
	add_edge!(g , 63 , 76 )
	add_edge!(g , 63 , 77 )
	add_edge!(g , 64 , 65 )
	add_edge!(g , 64 , 67 )
	add_edge!(g , 64 , 77 )
	add_edge!(g , 64 , 78 )
	add_edge!(g , 65 , 66 )
	add_edge!(g , 65 , 67 )
	add_edge!(g , 65 , 68 )
	add_edge!(g , 66 , 68 )
	add_edge!(g , 67 , 78 )
	add_edge!(g , 67 , 68 )
	add_edge!(g , 69 , 70 )
	add_edge!(g , 69 , 79 )
	add_edge!(g , 69 , 80 )

	add_edge!(g , 70 , 71 )
	add_edge!(g , 70 , 80 )
	add_edge!(g , 70 , 81 )

	add_edge!(g , 71 , 72 )
	add_edge!(g , 71 , 81 )
	add_edge!(g , 71 , 82 )
	add_edge!(g , 72 , 73 )
	add_edge!(g , 72 , 82 )
	add_edge!(g , 72 , 83 )
	add_edge!(g , 73 , 74 )
	add_edge!(g , 73 , 83 )
	add_edge!(g , 73 , 84 )
	add_edge!(g , 74 , 75 )
	add_edge!(g , 74 , 84 )
	add_edge!(g , 74 , 85 )
	add_edge!(g , 75 , 76 )
	add_edge!(g , 75 , 85 )
	add_edge!(g , 75 , 86 )
	add_edge!(g , 76 , 77 )
	add_edge!(g , 76 , 86 )
	add_edge!(g , 76 , 87 )
	add_edge!(g , 77 , 78 )
	add_edge!(g , 77 , 87 )
	add_edge!(g , 77 , 88 )
	add_edge!(g , 78 , 88 )
	add_edge!(g , 78 , 89 )
	add_edge!(g , 79 , 80 )
	add_edge!(g , 79 , 90 )
	add_edge!(g , 80 , 81 )
	add_edge!(g , 80 , 91 )
	add_edge!(g , 81 , 82 )
	add_edge!(g , 81 , 92 )
	add_edge!(g , 82 , 83 )
	add_edge!(g , 82 , 93 )
	add_edge!(g , 83 , 84 )
	add_edge!(g , 83 , 94 )
	add_edge!(g , 84 , 85 )
	add_edge!(g , 84 , 95 )
	add_edge!(g , 85 , 86 )
	add_edge!(g , 85 , 96 )
	add_edge!(g , 86 , 87 )
	add_edge!(g , 86 , 97 )
	add_edge!(g , 87 , 88 )
	add_edge!(g , 87 , 98 )
	add_edge!(g , 88 , 89 )
	add_edge!(g , 88 , 98 )
	add_edge!(g , 88 , 99 )
	add_edge!(g , 89 , 99 )
	add_edge!(g , 90 , 91 )
	add_edge!(g , 91 , 92 )
	add_edge!(g , 92 , 93 )
	add_edge!(g , 93 , 94 )
	add_edge!(g , 94 , 95 )
	add_edge!(g , 95 , 96 )
	add_edge!(g , 96 , 97 )
	add_edge!(g , 97 , 98 )
	add_edge!(g , 98 , 99 )





	set_prop!(g, 1, :pop, 11581)
	set_prop!(g, 2, :pop, 6462)
	set_prop!(g, 3, :pop, 16667)
	set_prop!(g, 4, :pop, 10302)
	set_prop!(g, 5, :pop, 15543)
	set_prop!(g, 6, :pop, 10866)
	set_prop!(g, 7, :pop, 7598)
	set_prop!(g, 8, :pop, 10776)
	set_prop!(g, 9, :pop, 9566)
	set_prop!(g, 10, :pop, 21056)
	set_prop!(g, 11, :pop, 14330)
	set_prop!(g, 12, :pop, 33704)
	set_prop!(g, 13, :pop, 14398)
	set_prop!(g, 14, :pop, 16667)
	set_prop!(g, 15, :pop, 9421)
	set_prop!(g, 16, :pop, 11341)
	set_prop!(g, 17, :pop, 44151)
	set_prop!(g, 18, :pop, 16303)
	set_prop!(g, 19, :pop, 12439)
	set_prop!(g, 20, :pop, 20880)
	set_prop!(g, 21, :pop, 18129)
	set_prop!(g, 22, :pop, 24986)
	set_prop!(g, 23, :pop, 12072)
	set_prop!(g, 24, :pop, 20260)
	set_prop!(g, 25, :pop, 7310)
	set_prop!(g, 26, :pop, 9815)
	set_prop!(g, 27, :pop, 13229)
	set_prop!(g, 28, :pop, 10680)
	set_prop!(g, 29, :pop, 14867)
	set_prop!(g, 30, :pop, 24276)
	set_prop!(g, 31, :pop, 102172)
	set_prop!(g, 32, :pop, 7089)
	set_prop!(g, 33, :pop, 10350)
	set_prop!(g, 34, :pop, 9670)
	set_prop!(g, 35, :pop, 38013)
	set_prop!(g, 36, :pop, 15673)
	set_prop!(g, 37, :pop, 17534)
	set_prop!(g, 38, :pop, 12453)
	set_prop!(g, 39, :pop, 131090)
	set_prop!(g, 40, :pop, 20958)
	set_prop!(g, 41, :pop, 17764)
	set_prop!(g, 42, :pop, 93653)
	set_prop!(g, 43, :pop, 9243)
	set_prop!(g, 44, :pop, 17096)
	set_prop!(g, 45, :pop, 20816)
	set_prop!(g, 46, :pop, 9336)
	set_prop!(g, 47, :pop, 26306)
	set_prop!(g, 48, :pop, 89542)
	set_prop!(g, 49, :pop, 40648)
	set_prop!(g, 50, :pop, 17767)
	set_prop!(g, 51, :pop, 26076)
	set_prop!(g, 52, :pop, 211226)
	set_prop!(g, 53, :pop, 20638)
	set_prop!(g, 54, :pop, 19848)
	set_prop!(g, 55, :pop, 14928)
	set_prop!(g, 56, :pop, 12167)
	set_prop!(g, 57, :pop, 6119)
	set_prop!(g, 58, :pop, 10954)
	set_prop!(g, 59, :pop, 66135)
	set_prop!(g, 60, :pop, 430640)
	set_prop!(g, 61, :pop, 36842)
	set_prop!(g, 62, :pop, 18914)
	set_prop!(g, 63, :pop, 16355)
	set_prop!(g, 64, :pop, 130882)
	set_prop!(g, 65, :pop, 18499)
	set_prop!(g, 66, :pop, 49116)
	set_prop!(g, 67, :pop, 42745)
	set_prop!(g, 68, :pop, 165224)
	set_prop!(g, 69, :pop, 93158)
	set_prop!(g, 70, :pop, 13956)
	set_prop!(g, 71, :pop, 7682)
	set_prop!(g, 72, :pop, 15679)
	set_prop!(g, 73, :pop, 46225)
	set_prop!(g, 74, :pop, 33309)
	set_prop!(g, 75, :pop, 22381)
	set_prop!(g, 76, :pop, 10511)
	set_prop!(g, 77, :pop, 21704)
	set_prop!(g, 78, :pop, 11387)
	set_prop!(g, 79, :pop, 15059)
	set_prop!(g, 80, :pop, 10740)
	set_prop!(g, 81, :pop, 4029)
	set_prop!(g, 82, :pop, 12534)
	set_prop!(g, 83, :pop, 9286)
	set_prop!(g, 84, :pop, 8898)
	set_prop!(g, 85, :pop, 7970)
	set_prop!(g, 86, :pop, 35625)
	set_prop!(g, 87, :pop, 16843)
	set_prop!(g, 88, :pop, 20145)
	set_prop!(g, 89, :pop, 40325)
	set_prop!(g, 90, :pop, 7441)
	set_prop!(g, 91, :pop, 15932)
	set_prop!(g, 92, :pop, 6317)
	set_prop!(g, 93, :pop, 5131)
	set_prop!(g, 94, :pop, 8457)
	set_prop!(g, 95, :pop, 6403)
	set_prop!(g, 96, :pop, 12887)
	set_prop!(g, 97, :pop, 8753)
	set_prop!(g, 98, :pop, 7570)
	set_prop!(g, 99, :pop, 35862)


	return g 
end

const iagr = make_iowa_graph()

ia_dict = DefaultDict(Set)

for e in edges(iagr)
    push!(ia_dict[src(e)], dst(e))
    push!(ia_dict[dst(e)], src(e))
end

function distpop(om)
    g = induced_subgraph(iagr, [i for i in findall(x->x == 1,om)])[1]
    return sum( get_prop(g,v,:pop) for v in vertices(g)   )
end


function iowa_holes(om,pop_tol)
    g = induced_subgraph(iagr, [i for i in findall(x->x == 0,om)])[1]
    for c in connected_components(g)
       p=0 
       for v in c           
           p+= get_prop(g,v,:pop)    
        end
        if p < pop_tol[1]
            return false
        end
    end
    return true
end

function stepdown(om, recent, minm, maxm, forbid, pop_tol,outf)
	print([ind for ind=1:99 if om[ind]==1],"                  ",'\r')
	if distpop(om) > pop_tol[2] #|| !iowa_holes(om,pop_tol)
		return

	elseif pop_tol[1] <= distpop(om) <= pop_tol[2] && iowa_holes(om,pop_tol)
		write(outf,"$(om)\n")

	end


	cands = Set()


	for j=minm:maxm
		if om[j] == 1
			for nbr in ia_dict[j]
				if nbr > minm && om[nbr] == 0 && nbr ∉ forbid
					push!(cands,nbr)
				end
			end
		end
	end


for c in cands
	newom = om[:]
	newom[c] = 1
	stepdown(newom,c,minm,max(c,maxm),forbid,pop_tol,outf)
	filter!(e->e≠c,cands)
	push!(forbid,c)
end



end

sf = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
nums = [67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99]
function recurse_dfs(om, forbid, pop_tol, outf,minm,maxm)
# 	if -1 ∉ sf.-om

 	print(distpop(om), "  ",[ind for ind=1:99 if om[ind]==1],"                  ",'\r')
# end
	if [ind for ind=1:99 if om[ind]==1] == [67,68,79]
		print("\nAAAAAA\n")
		exit()
	end
	if distpop(om) > pop_tol[2] || !iowa_holes(om,pop_tol)
		return

	elseif pop_tol[1] <= distpop(om) <= pop_tol[2] && iowa_holes(om,pop_tol)
		write(outf,"$(om)\n")

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
	cands = sort(collect(cands))
	newforbid = Set(forbid)
	for c in cands
		om[c] = 1
		if iowa_holes(om,pop_tol)
			recurse_dfs(om,newforbid,pop_tol,outf,minm,99)
	push!(newforbid,c)
		
			
		end
		om[c] = 0

	end


end



function enumerate()
for i=67:67
	outf = open("ia_dists_pm500/dfs2$i.txt","w")
	s = vec(zeros(Int8,1,99))
	s[i] = 1
	stepdown(s,i,i,i,Set(),[761000,762000],outf)

end
end


function enumerate2()
	for i=66:66
	outf = open("ia_dists_pm500/dfs2-s$i.txt","w")
	s = vec(zeros(Int8,1,99))
	s[i] = 1
	recurse_dfs(s,Set(),[761000,762000],outf,i,i)

end
end



@time enumerate2()
