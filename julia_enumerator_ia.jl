
# These are the packages we need to use.  If you don't
# have one, uncomment and run in the next block the
# appropriate lines and then run this block again

using Pkg
using LightGraphs
using IterTools
using DataStructures
using Base
using Combinatorics

#Pkg.add("LightGraphs")
#Pkg.add("IterTools")
#Pkg.add("DataStructures")
#Pkg.add("Base")
#Pkg.add("Combinatorics")


function make_iowa_graph()
    
    g = SimpleGraph(99)
    
add_edge!(g,1,2)
add_edge!(g,1,12)
add_edge!(g,2,3)
add_edge!(g,2,13)
add_edge!(g,3,4)
add_edge!(g,3,14)
add_edge!(g,4,5)
add_edge!(g,4,15)
add_edge!(g,5,6)
add_edge!(g,5,15)
add_edge!(g,5,16)
add_edge!(g,6,16)
add_edge!(g,6,7)
add_edge!(g,7,8)
add_edge!(g,7,17)
add_edge!(g,8,9)
add_edge!(g,8,17)
add_edge!(g,8,18)
add_edge!(g,9,10)
add_edge!(g,9,19)
add_edge!(g,10,11)
add_edge!(g,10,19)
add_edge!(g,10,20)
add_edge!(g,11,21)
add_edge!(g,12,13)
add_edge!(g,12,22)
add_edge!(g,13,23)
add_edge!(g,13,14)
add_edge!(g,14,15)
add_edge!(g,14,24)
add_edge!(g,15,25)
add_edge!(g,16,17)
add_edge!(g,16,27)
add_edge!(g,17,18)
add_edge!(g,17,28)
add_edge!(g,18,19)
add_edge!(g,18,29)
add_edge!(g,19,20)
add_edge!(g,19,30)
add_edge!(g,20,21)
add_edge!(g,20,30)
add_edge!(g,20,40)
add_edge!(g,21,41)
add_edge!(g,21,42)
add_edge!(g,22,23)
add_edge!(g,22,31)
add_edge!(g,23,24)
add_edge!(g,23,31)
add_edge!(g,23,32)
add_edge!(g,24,25)
add_edge!(g,24,33)
add_edge!(g,25,26)
add_edge!(g,25,34)
add_edge!(g,25,35)
add_edge!(g,26,27)
add_edge!(g,26,35)
add_edge!(g,27,28)
add_edge!(g,27,35)
add_edge!(g,27,36)
add_edge!(g,28,29)
add_edge!(g,28,37)
add_edge!(g,29,30)
add_edge!(g,29,38)
add_edge!(g,29,39)
add_edge!(g,30,39)
add_edge!(g,31,32)
add_edge!(g,31,43)
add_edge!(g,32,33)
add_edge!(g,32,44)
add_edge!(g,33,34)
add_edge!(g,33,44)
add_edge!(g,33,45)
add_edge!(g,34,35)
add_edge!(g,34,45)
add_edge!(g,34,46)
add_edge!(g,35,36)
add_edge!(g,35,46)
add_edge!(g,35,47)
add_edge!(g,36,37)
add_edge!(g,36,47)
add_edge!(g,36,48)
add_edge!(g,37,38)
add_edge!(g,37,48)
add_edge!(g,37,49)
add_edge!(g,38,39)
add_edge!(g,38,49)
add_edge!(g,38,50)
add_edge!(g,39,40)
add_edge!(g,39,50)
add_edge!(g,39,51)
add_edge!(g,40,41)
add_edge!(g,40,51)
add_edge!(g,40,52)
add_edge!(g,41,42)
add_edge!(g,41,52)
add_edge!(g,41,53)
add_edge!(g,42,53)
add_edge!(g,42,54)
add_edge!(g,43,44)
add_edge!(g,43,55)
add_edge!(g,44,45)
add_edge!(g,44,55)
add_edge!(g,44,56)
add_edge!(g,45,46)
add_edge!(g,45,57)
add_edge!(g,45,58)
add_edge!(g,46,47)
add_edge!(g,46,58)
add_edge!(g,46,58)
add_edge!(g,47,48)
add_edge!(g,47,59)
add_edge!(g,47,60)
add_edge!(g,48,49)
add_edge!(g,48,60)
add_edge!(g,48,61)
add_edge!(g,49,50)
add_edge!(g,49,61)
add_edge!(g,50,51)
add_edge!(g,50,62)
add_edge!(g,51,52)
add_edge!(g,51,63)
add_edge!(g,52,53)
add_edge!(g,52,64)
add_edge!(g,52,65)
add_edge!(g,53,54)
add_edge!(g,53,65)
add_edge!(g,53,66)
add_edge!(g,54,66)
add_edge!(g,55,56)
add_edge!(g,55,69)
add_edge!(g,56,57)
add_edge!(g,56,69)
add_edge!(g,56,70)
add_edge!(g,57,58)
add_edge!(g,57,70)
add_edge!(g,58,59)
add_edge!(g,58,71)
add_edge!(g,59,60)
add_edge!(g,59,72)
add_edge!(g,60,61)
add_edge!(g,60,73)
add_edge!(g,60,74)
add_edge!(g,61,62)
add_edge!(g,71,74)
add_edge!(g,61,75)
add_edge!(g,62,63)
add_edge!(g,62,75)
add_edge!(g,62,76)
add_edge!(g,63,64)
add_edge!(g,63,76)
add_edge!(g,63,77)
add_edge!(g,64,65)
add_edge!(g,64,67)
add_edge!(g,64,77)
add_edge!(g,64,78)
add_edge!(g,65,66)
add_edge!(g,65,67)
add_edge!(g,65,68)
add_edge!(g,66,68)
add_edge!(g,67,78)
add_edge!(g,67,68)
add_edge!(g,69,70)
add_edge!(g,69,79)
add_edge!(g,69,80)
add_edge!(g,70,71)
add_edge!(g,70,80)
add_edge!(g,70,81)
add_edge!(g,71,72)
add_edge!(g,71,81)
add_edge!(g,71,82)
add_edge!(g,72,73)
add_edge!(g,72,82)
add_edge!(g,72,83)
add_edge!(g,73,74)
add_edge!(g,73,83)
add_edge!(g,73,84)
add_edge!(g,74,75)
add_edge!(g,74,84)
add_edge!(g,74,85)
add_edge!(g,75,76)
add_edge!(g,75,85)
add_edge!(g,75,86)
add_edge!(g,76,77)
add_edge!(g,76,86)
add_edge!(g,76,87)
add_edge!(g,77,78)
add_edge!(g,77,87)
add_edge!(g,77,88)
add_edge!(g,78,88)
add_edge!(g,78,89)
add_edge!(g,79,80)
add_edge!(g,79,90)
add_edge!(g,80,81)
add_edge!(g,80,91)
add_edge!(g,81,82)
add_edge!(g,81,92)
add_edge!(g,82,83)
add_edge!(g,82,93)
add_edge!(g,83,84)
add_edge!(g,83,94)
add_edge!(g,84,85)
add_edge!(g,84,95)
add_edge!(g,85,86)
add_edge!(g,85,96)
add_edge!(g,86,87)
add_edge!(g,96,97)
add_edge!(g,87,88)
add_edge!(g,87,98)
add_edge!(g,88,89)
add_edge!(g,88,98)
add_edge!(g,88,99)
add_edge!(g,89,99)
add_edge!(g,90,91)
add_edge!(g,91,92)
add_edge!(g,92,93)
add_edge!(g,93,94)
add_edge!(g,94,95)
add_edge!(g,95,96)
add_edge!(g,96,97)
add_edge!(g,97,98)
add_edge!(g,98,99)
    
    
    
    
   return g 
end





"""
Checks if an omino is 'valid'. 
A valid omino is a binary matrix where
all of the ones are positioned such that
they form a single (rook/queen)-connected
component.
"""
function valid_omino(omino,cont="rc")
    if 2 in omino
        return false
    end
    n1 = size(omino)[1]
    n2 = size(omino)[2]
    check = zeros(Int8, n1,n2)
    _f = false
    g = Grid([n1,n2])
 
    if cont == "qc" 
        for i=1:n1-1
           for j=1:n2-1
               add_edge!(g,((i-1)*n2+j),i*n2+j+1) 
            end
        end
        
        for i=1:n1-1
            for j=2:n2
                add_edge!(g,((i-1)*n2+j),i*n2+j-1)
            end
        end
    end
    
    for i=n1:-1:1
        for j=n2:-1:1
           if omino[i,j] ==0
                rem_vertex!(g,((i-1)*n2+j))
            end  
        end   
    end
    
    return length(connected_components(g)) == 1  
end
    



"""
Given a list of indices [(i_1,j_1),(i_2,j_2),...]
checks if setting the values at those indices in
a grid of size grid[1]xgrid[2] yields a valid
omino as according to the specified continuity
rule.  

If so, returns that omino.  If not,
returns the grid[1]xgrid[2] zeros matrix.
"""
function make_omino(inds,grid,cont="rc")
    
    p = zeros(Int8,grid[1],grid[2])
    for loc in inds
        p[loc[1],loc[2]]=1
    end
    
    if valid_omino(p,cont)
        return p
    else
        return zeros(Int8,grid[1],grid[2])
    end
end


"""
Returns the set of valid grid[1]xgrid[2] ominos, 
according to the continuity rule, which have 
cells ones.

Note: starting with make_omino_set(1,[...]) and
calling biggen(...) in a loop is generally much
faster than this method.  Since this operates
by combinatorial enumeration, checking all
possible subsets of indices.
"""
function make_omino_set(cells,grid,cont="rc")
    
   pair_idx = []
    for i=1:grid[1]
        for j=1:grid[2]
            push!(pair_idx, (i,j))
        end
    end
    
    ominos = []
    for t in subsets(pair_idx, Val{cells}())
        p = make_omino(t,grid,cont)
        
        if sum(p)!=0
            push!(ominos,p)
        end
    end   
    return ominos    
end


    

"""
Takes as input a collection of ominos
and returns the list of valid ominos on
the same shape grid which can be formed
by changing a single zero to a one in
any element of omlist.
"""
function biggen(omlist,cont="rc")
    grid = size(omlist[1])
    new_oms = Set()
    for o in omlist
        
        for i = 1:grid[1]
            for j = 1:grid[2]
                z = zeros(Int8,grid[1],grid[2])
                z[i,j]+=1
                if o[i,j]==0 && valid_omino(z+o,cont)
                    push!(new_oms,z+o)                 
                end
            end
        end       
    end
    return collect(new_oms)
end

"""
Given an omino, and a collection of bad
hole sizes (bad_holes), returns true
if none of the connected components formed
by the ominos zeros are of a size in that
list.

For example if we're looking at splitting the 3x3
grid into 3 rook connected pieces of size 3, then we
might have bad_holes=[1,2,4,5], since it's going to
be impossible to add any collection of our 3-ominos
to this omino to complete the partitioning.  Therefore,
if we call this method on

0 1 0
1 1 0
0 0 0

it would return false.
"""
function check_holes(omino, bad_holes,cont="rc")

    n1 = size(omino)[1]
    n2 = size(omino)[2]
    check = ones(Int8, n1,n2)-omino
    _f = false
    g = Grid([n1,n2])
     
    if cont == "qc"
        for i=1:n1-1
           for j=1:n2-1
               add_edge!(g,((i-1)*n2+j),i*n2+j+1  ) 
            end
        end
        
        for i=1:n1-1
            for j=2:n2
                add_edge!(g,((i-1)*n2+j),i*n2+j-1)
            end
        end        
    end
    
    for i=n1:-1:1
        for j=n2:-1:1
           if check[i,j] ==0
                rem_vertex!(g,((i-1)*n2+j))
            end            
        end   
    end
    
    for c in connected_components(g)
        if length(c) in bad_holes
            return false
        end
    end
    
    return true
end


"""
Given a list of ominos, a list of bad hole sizes, the number
of parts we want to partition into, and a continuity rule,
generates two dictionaries to guide the dynamic program.

It is important that omlist indeed be a list, since we do our
hashing by indexing into that list, so it's order needs
to be fixed.

The first dictionary, firstdict, has a key for each (row,col)
pair to index into the ominos.  The values are the set of ominos
for which first_one(omino)==(row,col).  This will allow the 
algorithm to easily ask for the list of ominos which have their
first one in a particular index.

The second dictionary, conflict, has a key for each omino and
the values are the set of ominos which are 'compatible' with
the key.  Here, compatibility means they do not overlap, and
combining both of them does not create any bad holes.  These
are necessary conditions for the pair of ominos to be able
to be used together in some partitioning.
"""
function build_conflicts(omlist, bad_holes,cont="rc")
    
    
    firstdict = DefaultDict(Set)
    
    for o in 1:length(omlist)
        k = first_one(omlist[o])
        push!(firstdict[k],o)
    end
    
    conflict = DefaultDict(Set)
    for os in subsets(1:length(omlist),Val{2}())
        i = os[1]
        j = os[2]
        _c = true
        for p in zip(omlist[i],omlist[j])
            if _c && p[1]*p[2] ==1
                _c = false
            end
        end
        if _c && check_holes(omlist[i]+omlist[j],bad_holes,cont)
            push!(conflict[i],j)
            push!(conflict[j],i)
        end        
    end
    return firstdict,conflict
end

"""
Returns the first (lexicographically)
(row,column) index where the entry
of mat is zero.
"""
function first_zero(mat)
    
   for i=1:size(mat,1)
        for j=1:size(mat,2)
            if mat[i,j]==0
                return (i,j)
            end
        end
    end
    return nothing  
end

"""
Returns the first (lexicographically)
(row,column) index where the entry
of mat is one.
"""
function first_one(mat)
    
   for i=1:size(mat,1)
        for j=1:size(mat,2)
            if mat[i,j]==1
                return (i,j)
            end
        end
    end
    return nothing 
end

"""
The enumerator. Takes five arguments:
- grid: a pair [m,n] which give the dimension of
        the grid to be partitioned
- om_sizes: a list of integers [a,b,...] which 
            are the allowed sizes of ominos
- num_parts: an integer, the number of parts
- cont: a string "rc" or "qc" to give a continuity rule
- io: a boolean, whether or not to write the list of partitions
      to a file.

returns: an integer, counting the number of valid partitions

usage: to partition the 4x6 grid into 4 rook connected pieces
       of size 4,5,6, with file output, you would call
       enumerator([4,6],[4,5,6],4,"rc",true)

The output format is a text file, where each partition
is on its own line.  The components are numbered 1,2,...num_parts
and the linear order corresponds with the lexicographic order of the
indexing of the grid.  For example, the representation of

1 2 2
1 1 2
3 3 3

is

1,2,2,1,1,2,3,3,3

The file naming convention is [<m>,<n>]_[<p_1>,<p_2>,...,<p_l>]_k_<cont>.txt where 
m and n are the dimensions of the grid, the p_i are the allowed sizes of the chunks, 
k is the number of pieces, and cont is either rc for rook contiguity or qc for queen contiguity.



includes three helper methods defined locally:

verify(a,b) checks if the ominos at indices a,b
conflict with each other as according to the 
conflict dictionary constructed by make_conflicts()

get_next() takes a partial partitioning and gives the
collection of ominos which have their first one where
the partial partition has its first zero and which do not
conflict with any of the ominos in the partial partition

recurs_part() uses get_next() to recursively build
all of the partitions.  If it finds a valid one,
it increments the counter and (if io==true) writes
it to the output file
"""
function enumerator(grid, om_sizes,num_parts, cont="rc", io=false)
    count = 0
    oms = []
    bad_hole_sizes = [ [i for i = 1:minimum(om_sizes)-1] ;[i for i = maximum(om_sizes)+1:2*minimum(om_sizes)-1]        ]
    
    tmp_oms = make_omino_set(1,grid,cont)
    if io
        os = om_sizes
        gr = grid
        np = num_parts
        outfile = open(replace("enumerations/enum_$(gr)_$(os)_$(np)_$(cont).txt"," "=>""),"w")
    end
    
    
    if 1 in om_sizes
        oms = [oms;tmp_oms]
    end
    
    for sz = 2:maximum(om_sizes)
        tmp_oms = biggen(tmp_oms,cont)
        if sz in om_sizes
            oms = [oms;tmp_oms]
        end
        #print("MADE SZ ",sz ,' ',length(tmp_oms),"\n")


    end
    
    
    oms = [ o for o in oms if check_holes(o,bad_hole_sizes,cont)]

    #print("MADE OMINOS\n")
    
    
    
    fd,cf = build_conflicts(oms,bad_hole_sizes,cont)
    #print("MADE DICTIONARIES\n")           
    
    function verify(plan)
        #print(plan,'\n')
        
        for p in subsets(plan,Val{2}())
            if !(p[2] in cf[p[1]])
                return false
            end
        end
        return true
    end
           

    function get_next(fd, curr_inds, omlist) 
       return [d for d in fd[first_zero(sum([omlist[j] for j in curr_inds]))] if verify(curr_inds + d)]     
    end                  
                
    function recurs_part(plan,steps)
        #print("plan:",plan,"  sum: ",sum([oms[j] for j in plan]),'\n')
        if steps == 0
            if sum(sum( [oms[j] for j in plan])) == grid[1]*grid[2] #&& sort!(collect([sum(oms[j]) for j in plan    ] )) == om_sizes
                count +=1
                if io
                    strrep = "$(sum([j.*oms[plan[j]] for j in 1:length(plan)]))\n"
                    strrep = replace(strrep," "=>",")
                    strrep = replace(strrep,"["=>"")
                    strrep = replace(strrep,";"=>"")
                    strrep = replace(strrep,"]"=>"")
                    write(outfile,  strrep)
                end
                return
            end
        elseif sum(sum( [oms[j] for j in plan])) == grid[1]*grid[2]
        return
        end
        for q in fd[first_zero( sum([oms[j] for j in plan     ]))]
            if verify([plan;[q]])
                recurs_part([plan;[q]],steps-1)
            end
        end
    end
    
    #print("NEED TO DO ",length(fd[(1,1)]), " TOP-LEVELS\n")
    for p in fd[(1,1)]
        #print(" ",p," ")
        recurs_part([p],num_parts-1)
    end
    
    
   print('\n')
    if io
        close(outfile)
    end
   return count 
    
end

#@time print(enumerator([4,6],[6],4,"rc",false))

function valid_graph_om(omino,graph)
    if length(omino)!=nv(graph)
        print("BAD INPUT\n")
        return
    end
    if 2 in omino
        return false
    end

    g = induced_subgraph(graph, [i[2] for i in findall(x->x == 1,omino)])[1]

    #=
    g = deepcopy(graph)
    for i=nv(graph):-1:1
        #print("HERE $i\n")
       if omino[i]==0
            rem_vertex!(g,i)
        
        end    
    end
    =#
    #print("ENDED LOOP! $(collect(connected_components(g))) \n")
    return length(collect(connected_components(g)))==1

end



function biggen_graph(omlist, graph)
    if length(omlist[1])!=nv(graph)
        print("BAD INPUT\n")
        return
    end
    newoms = Set()
    for omino in omlist
        
        for i=1:length(omino)
            z = zeros(Int8,size(omino))
            z[i]+=1
                if valid_graph_om(omino+z,graph)
                    push!(newoms,omino+z)
                end
            
        end
    end

    return collect(newoms)
end



function check_graph_holes(om,graph,bad_holes)
    if length(om)!=nv(graph)
        print("BAD INPUT\n")
        return
    end
    g = induced_subgraph(graph, [i[2] for i in findall(x->x == 0,om)])[1]
    
    #=
    g = deepcopy(graph)
    for i=nv(graph):-1:1
        #print("HERE $i\n")
       if omino[i]==0
            rem_vertex!(g,i)
        
        end    
    end
    =#
    #print("ENDED LOOP! $(collect(connected_components(g))) \n")
    for c in connected_components(g)
        #print("$(length(c))\n")
        if length(c) in bad_holes
            return false
        end
    end
    return true
end





function build_graph_conflicts(omlist, gr,bad_holes)
    
    print("HAVE $(length(omlist)) oms\n")
    firstdict = DefaultDict(Set)
    
    for o in 1:length(omlist)
        k = first_one(omlist[o])
        push!(firstdict[k],o)
    end
    
    conflict = DefaultDict(Set)
    for os in subsets(1:length(omlist),Val{2}())
        print("$os\r")
        i = os[1]
        j = os[2]
        _c = true
        for p in zip(omlist[i],omlist[j])
            if _c && p[1]*p[2] ==1
                _c = false
            end
        end
        
        if _c && check_graph_holes(omlist[i]+omlist[j],gr,bad_holes)
            push!(conflict[i],j)
            push!(conflict[j],i)
        end
        
    end
    return firstdict,conflict
end


function iowa_enumerator(om_sizes,num_parts, io=false)
    count = 0
    oms = []
    bad_hole_sizes = []#[ [i for i = 1:minimum(om_sizes)-1] ;[i for i = maximum(om_sizes)+1:2*minimum(om_sizes)-1]        ]
    iagr = make_iowa_graph()
    
    tmp_oms = []
    for i=1:99
        s = zeros(Int8,1,99)
        s[i]=1
        push!(tmp_oms,s)
    end
    
    if io
    print("IOing")
        os = om_sizes
        
        np = num_parts
        outfile = open(replace("enumerations/iowaenum_$(os)_$(np).txt"," "=>""),"w")
    end
    
   
    
    if 1 in om_sizes
        oms = [oms;tmp_oms]
    end
    
    for sz = 2:maximum(om_sizes)
    
        tmp_oms = biggen_graph(tmp_oms,iagr)
        tmp_oms = [ o for o in tmp_oms if check_graph_holes(o,iagr,bad_hole_sizes)]
        if sz in om_sizes
            oms = [oms;tmp_oms]
        end
        print("MADE SZ ",sz ,' ',length(tmp_oms),"\n")


    end
    
    
    oms = [ o for o in oms if check_graph_holes(o,iagr,bad_hole_sizes)]

    print("MADE OMINOS\n")
    
    
    
    fd,cf = build_graph_conflicts(oms,iagr,bad_hole_sizes)
    print("MADE DICTIONARIES\n")           
    function verify(plan)
        #print(plan,'\n')
        
        for p in subsets(plan,Val{2}())
            if !(p[2] in cf[p[1]])
                return false
            end
        end
        return true
    end
           

    function get_next(fd, curr_inds, omlist) 
       return [d for d in fd[first_zero(sum([omlist[j] for j in curr_inds]))] if verify(curr_inds + d)]     
    end                  
                
    function recurs_part(plan,steps)
        #print("plan:",plan,"  sum: ",sum([oms[j] for j in plan]),'\n')
        if steps == 0
            if sum(sum( [oms[j] for j in plan])) == nv(iagr) #&& sort!(collect([sum(oms[j]) for j in plan    ] )) == om_sizes
                count +=1
                if io
                    strrep = "$(sum([j.*oms[plan[j]] for j in 1:length(plan)]))\n"
                    strrep = replace(strrep," "=>",")
                    strrep = replace(strrep,"["=>"")
                    strrep = replace(strrep,";"=>"")
                    strrep = replace(strrep,"]"=>"")
                    write(outfile,  strrep)
                end
                print("$count\r")
                if count == 10000
                    if io
                        close(outfile)
                    end
                exit()
                end
                return
            end
        elseif sum(sum( [oms[j] for j in plan])) == nv(iagr)
        return
        end
        for q in fd[first_zero( sum([oms[j] for j in plan     ]))]
            if verify([plan;[q]])
                recurs_part([plan;[q]],steps-1)
            end
        end
    end
    
    print("NEED TO DO ",length(fd[(1,1)]), " TOP-LEVELS\n")
    for p in fd[(1,1)]
        print(" ",p," \n")
        recurs_part([p],num_parts-1)
    end
    
    
   print('\n')
    if io
        close(outfile)
    end
   return count 
    
end

using Profile


@time print(iowa_enumerator([24,25],4,true))
