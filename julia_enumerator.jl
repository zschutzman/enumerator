
# These are the packages we need to use.  If you don't
# have one, uncomment and run in the next block the
# appropriate lines and then run this block again
lxx = 0
lct = 0
using Pkg
using LightGraphs, MetaGraphs
using IterTools
using DataStructures
using Base
using Combinatorics

#Pkg.add("LightGraphs")
#Pkg.add("IterTools")
#Pkg.add("DataStructures")
#Pkg.add("Base")
#Pkg.add("Combinatorics")
#Pkg.add("MetaGraphs")

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

    g = induced_subgraph(graph, [i for i in findall(x->x == 1,omino)])[1]

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
if length(omlist) == 0
    return []
end
    if length(omlist[1])!=nv(graph)
        print("BAD INPUT\n")
        return
    end
    newoms = Set()
    while length(omlist)>0
        omino = pop!(omlist)
        #print("BIGGENING todo $(length(omlist)) \r")
        for i=first_one(omino)[1]+1:length(omino)
            z = zeros(Int8,length(omino))
            z[i]=1
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
    g = induced_subgraph(graph, [i for i in findall(x->x == 0,om)])[1]
    
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
        if _c && check_graph_holes(omlist[i]+omlist[j],gr,bad_holes)
            push!(conflict[i],j)
            push!(conflict[j],i)
        end        
    end
    return firstdict,conflict
end

function iowa_holes(om,graph,pop_tol)
    #print("$(om)\r")
    g = induced_subgraph(graph, [i for i in findall(x->x == 0,om)])[1]
    if length(connected_components(g)) > 3
        return false
    end
    for c in connected_components(g)
       p=0 
       for v in c
            
           p+= get_prop(g,v,:pop)
            
        end
        if p < pop_tol[1] #|| pop_tol[2] < p < 2*pop_tol[1]
            return false
        end
    end
    return true
end

function iowa_pop(om,graph)
    global lxx
    global lct
    g = induced_subgraph(graph, [i for i in findall(x->x == 1,om)])[1]
    print("len: $(length(vertices(g))) prog: $(round((100*lct/lxx)))   pop: $(sum( get_prop(g,v,:pop) for v in vertices(g)   ))     \r")
    return sum( get_prop(g,v,:pop) for v in vertices(g)   )

    
    
end

function build_iowa_conflicts(omlist,iagr,pop_tol)
    
        
    
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
        if _c && iowa_holes(omlist[i]+omlist[j],iagr,pop_tol)
            push!(conflict[i],j)
            push!(conflict[j],i)
        end        
    end
    return firstdict,conflict
end

function iowa_enumerator(pop_tol, num_parts, io=false)
    count = 0
    oms = []
    bad_hole_sizes = []#[ [i for i = 1:minimum(om_sizes)-1] ;[i for i = maximum(om_sizes)+1:2*minimum(om_sizes)-1]        ]
    iagr = make_iowa_graph()
    
    for i=58:-1:46
    outf = open("ia_dists_pm500/$i.txt","w")

    tmp_oms = []
        s = vec(zeros(Int8,1,99))
        s[i]=1
        push!(tmp_oms,s)
    #=
    if io
        
        outfile = open(replace("enumerations/iowaenum_$(pop_tol)_$(num_parts).txt"," "=>""),"w")
    end
    =#
    
    oms = [o for o in tmp_oms if pop_tol[1]<=iowa_pop(o,iagr)<=pop_tol[2]   ]
    for o in oms
        write(outf,"$(o)\n")
    end    
    tmp_oms = [ o for o in tmp_oms if iowa_pop(o,iagr)<=pop_tol[2]] 

    while length(tmp_oms)>0
       print("\n")
       cxx = sum(tmp_oms[1])+1
       sort!(tmp_oms)
       new_oms = []
       global lxx
       global lct=0
       lxx = length(tmp_oms)
       n= []
       while length(tmp_oms)>0
       c = pop!(tmp_oms)
        lct +=1

        n = [n;biggen_graph([c],iagr)]

        print("len: $(sum(c)+1) prog: $(round(100*lct/lxx))    \r")

        if lct%10000 == 0
            n = unique(n)
        end
        if length(n) > 200000
            n = unique(n)

            n = [ o for o in n if iowa_holes(o,iagr,pop_tol) && iowa_pop(o,iagr)<=pop_tol[2] ]
            new_oms = [new_oms;n]
            new_oms = unique(new_oms)
            n = []
        end
       end
       n = unique(n)
       n = [ o for o in n if iowa_holes(o,iagr,pop_tol) && iowa_pop(o,iagr)<=pop_tol[2] ]
       new_oms = [new_oms;n]
       new_oms = unique(new_oms)       
       tmp_oms = new_oms
       print("\nVALIDATING $(length(tmp_oms))\n")
       #tmp_oms = [ o for o in tmp_oms if iowa_holes(o,iagr,pop_tol)]

       oms = [o for o in tmp_oms if pop_tol[1]<=iowa_pop(o,iagr)<=pop_tol[2]   ]

       for o in oms
        write(outf,"$(o)\n")
       end
       #tmp_oms = [ o for o in tmp_oms if iowa_pop(o,iagr)<=pop_tol[2]]

       print("$i DONE SIZE $(cxx) checking $(length(tmp_oms))  have $(length(oms))   \n")

    end
       
       
       
    close(outf)
    end                
return 0
    

    print("MADE OMINOS\n")
    
    
    
    fd,cf = build_iowa_conflicts(oms,iagr,pop_tol)
    print("MADE DICTIONARIES\n")           
    print("$fd\n")
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
                print("$count\r")
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
        print(" ",p," ")
        recurs_part([p],num_parts-1)
    end
    
    
   print('\n')
    if io
        close(outfile)
    end
   return count 
    
end



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

    
    
    
    print(g)
    
   return g 
end







@time print(" $(iowa_enumerator([761000,762000],4,true))\n")
